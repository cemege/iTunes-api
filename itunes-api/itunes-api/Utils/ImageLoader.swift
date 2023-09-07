//
//  ImageLoader.swift
//  itunes-api
//
//  Created by Cem Ege on 5.09.2023.
//

import Foundation
import Combine

enum ImageLoaderError: Error {
    case serverError
    case notFound
}

final class ImageLoader: ObservableObject {
    
    // MARK: - Properties
    @Published var error: Bool = false
    @Published var imageDataList: [ContentViewModel.IdentifiableImageData] = []
    
    func getImageData(url: URL?) async throws -> Data {
        guard let url else {
            throw ImageLoaderError.notFound
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw ImageLoaderError.serverError
        }
        
        return data
    }
    
    @MainActor
    func downloadImages(firstURL: URL?, secondURL: URL?, thirdURL: URL?) async  {
        Task {
            async let firsImageData = getImageData(url: firstURL)
            async let secondImageData = getImageData(url: secondURL)
            async let thirdImageData = getImageData(url: thirdURL)
            
            imageDataList = try await [
                ContentViewModel.IdentifiableImageData(imageData: firsImageData, url: firstURL),
                ContentViewModel.IdentifiableImageData(imageData: secondImageData, url: secondURL),
                ContentViewModel.IdentifiableImageData(imageData: thirdImageData, url: thirdURL)
            ]
        }
    }
}
