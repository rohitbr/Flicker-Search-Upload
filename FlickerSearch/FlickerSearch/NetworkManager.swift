//
//  File.swift
//  FlickerSearch
//
//  Created by Bhat, Rohit on 5/28/24.
//

import Foundation

class NetworkManager {
    
    func getData(url: String) async -> Result<Data, CustomError> {
        
        guard !url.isEmpty else {
            return .failure(.emptyUrl)
        }
        
        guard let url = URL(string: url) else {
            return .failure(.invalidUrl)
        }
        
        guard let result = try? await URLSession.shared.data(from: url)
        else {
            return .failure(.invalidResult)
        }
        
        guard let response = result.1 as? HTTPURLResponse,
              (200..<300).contains(response.statusCode)
        else {
            return .failure(.invalidResult)
        }
        
        return .success(result.0)
    }
}
