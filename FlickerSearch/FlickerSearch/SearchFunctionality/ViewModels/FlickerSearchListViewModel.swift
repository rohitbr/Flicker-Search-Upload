//
//  FlickerSearchListViewModel.swift
//  FlickerSearch
//
//  Created by Bhat, Rohit on 5/28/24.
//

import Foundation
import SwiftUI

class FlickerSearchListViewModel : ObservableObject {
    
    enum CustomError : Error {
        case decodingError
        case downloadError
        
        func error() -> String {
            switch self {
            case .decodingError:
                return "Decoding Error"
            case .downloadError:
                return "Download Error"
            }
        }
    }
    
    enum State : Comparable {
        case noQuery
        case firstQueryLoading
        case photosLoading
        case photosLoaded
        case noResults
        case error(String)
    }
     
    @Published var debouncedText = ""
    @Published var searchText = ""
    @Published var photoArray : [Image] = []
    @Published var state : State = .noQuery

    private let networkManager: NetworkManager
   
    var pageNumber: Int = 1
    var needMoreData = false
    
        
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        
        let debounced = $searchText.debounce(for: .seconds(1), scheduler: RunLoop.main).values

        Task {
            for await value in debounced {
                print("value is \(value)")
                await MainActor.run {
                    debouncedText = value
                    resetState()
                    
                    if debouncedText.isEmpty {
                        state = .noQuery
                        return
                    }
                }
                if !debouncedText.isEmpty {
                    await fetchImages()
                }
            }
        }
    }
    
    func resetState()  {
        Task {
            await MainActor.run {
                pageNumber = 1
                photoArray = []
            }
        }
    }
    
    func initializeUrl(pageNumber: Int) -> String {
        
        print("Debounced text is \(debouncedText)")
        
        let baseUrl = "https://api.flickr.com/services/rest/?&method=flickr.photos.search"
        let apiString = "&api_key=\(Constants.kApiKey)"
        let searchString = "&tags=\(debouncedText)"
        let format = "&format=json"
        let jsonNoCallBack = "&nojsoncallback=1"
        let page = "&page=\(pageNumber)"
        let finalUrl = baseUrl+apiString+searchString+format+jsonNoCallBack + page
        
        return finalUrl
    }
    
    func downloadProfileImage(imageUrl: URL?) async throws -> UIImage?
    {
        guard let url = imageUrl
        else {
            return nil
        }
        
        guard let data = try? await URLSession.shared.data(from: url)
        else {
            return nil
        }
        
        guard let image = UIImage(data: data.0)
        else {
            return nil
        }
        
        return image
    }

    func fetchImages() async {
        guard !debouncedText.isEmpty else {
            return
        }
        
        guard state != .photosLoading && state != .firstQueryLoading else {
            return
        }
        
        await MainActor.run {
            state = .firstQueryLoading
        }
        

        let searchUrl = initializeUrl(pageNumber: self.pageNumber)
        let data = await networkManager.getData(url: searchUrl)
        
        switch data {
        case .success(let data):
            await downloadImages(data)
        case .failure:
            await MainActor.run {
                state = .error(CustomError.downloadError.error())
            }
            break
        }
    }
    
    func downloadImages(_ data: Data) async {
        await MainActor.run {
            state = .photosLoading
        }
        do {
            let decoded = try JSONDecoder().decode(FlickerResponse.self, from: data)
            print("decoding succeeded")
            print(decoded.photos.page)
            
            let photosArray = decoded.photos.photo
            
            do {
                try await withThrowingTaskGroup(of: UIImage?.self, body: { group in
                    for photo in photosArray {
                        group.addTask { [weak self] in
                            try? await self?.downloadProfileImage(imageUrl: photo.photoUrl)
                        }
                    }
                    
                    for try await image in group {
                        await MainActor.run {
                            if let image {
                                photoArray.append(Image(uiImage: image))
                                print("Appending here")
                            }
                        }
                    }
                    print("Done with the for loop here \(pageNumber)")

                    
                    await MainActor.run {
                        if photosArray.isEmpty {
                            state = .noResults
                        } else {
                            state = .photosLoaded
                            // ask for more pages if necessary
                            if pageNumber < decoded.photos.pages {
                                pageNumber += 1
                            }
                        }
                    }
                })
            } catch {
                await MainActor.run {
                    state = .error(CustomError.downloadError.error())
                    resetState()
                }
                print("downloading failed")
            }
        } catch {
            state = .error(CustomError.decodingError.error())
            resetState()
            print("decoding failed")
        }
    }
}
