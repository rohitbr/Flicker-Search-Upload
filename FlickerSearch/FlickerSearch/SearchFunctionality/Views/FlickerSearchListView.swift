//
//  FlickerSearchListView.swift
//  FlickerSearch
//
//  Created by Bhat, Rohit on 5/27/24.
//

import SwiftUI

enum CustomError : Error {
    case noData
    case emptyUrl
    case invalidUrl
    case invalidResult
}

struct FlickerSearchListView: View {
    
    @StateObject var vm = FlickerSearchListViewModel(networkManager: NetworkManager())
    
    private var columns: [GridItem] = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8),
    ]
    
    var body: some View {
        NavigationStack {
            Group {
                switch vm.state {
                case .noResults:
                    VStack {
                        Text("Sorry no results for \(vm.debouncedText)")
                            .font(.largeTitle)
                    }
                case .error(let error):
                    VStack {
                        Text("Sorry no results \(error)")
                            .font(.largeTitle)
                    }
                case .noQuery:
                    VStack {
                        DefaultSearchView(searchTerm: $vm.searchText)
                    }
                case .photosLoaded, .firstQueryLoading, .photosLoading:
                    ScrollView {
                        if vm.photoArray.count > 0 {
                            LazyVGrid(columns: columns) {
                                ForEach(0..<vm.photoArray.count, id: \.self) { imageIdx in
                                    vm.photoArray[imageIdx]
                                        .resizable()
                                        .scaledToFit()
                                }
                                Color.gray
                                    .onAppear {
                                        Task {
                                            await vm.fetchImages()
                                        }
                                    }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Search Flickr")
            .toolbar {
                NavigationLink("Settings") {
                    SettingsScreen()
                }
            }
            .searchable(text: $vm.searchText, placement: .automatic, prompt: "Enter search term")
            .overlay {
                if vm.state == .photosLoading || vm.state == .firstQueryLoading {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.gray)
                            .frame(width: 200)
                            .frame(height: 200)
                        ProgressView("Loading 🎞 Please wait!")
                            .foregroundColor(Color.white)
                            .controlSize(.large)
                    }
                }
            }
            .disabled(vm.state == .photosLoading || vm.state == .firstQueryLoading)
        }
    }
}

//struct FlickerSearchListView_Previews: PreviewProvider {
//    static var previews: some View {
////        FlickerSearchListView(imageDataService: FlickerDataService(networkManager: NetworkManager(), tag: ""))
////        FlickerSearchListView(vm: FlickerSearchListViewModel(networkManager: NetworkManager()))
//    }
//}
