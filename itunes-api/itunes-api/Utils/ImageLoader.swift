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
    @Published var imageDataList: [ContentViewModel.IdentifiableDataSourceModel] = []
    
    // MARK: - Download Image
    func getImageData(urlString: String?) async throws -> ContentViewModel.IdentifiableDataSourceModel {
        guard let url = URL(string: urlString ?? "") else {
            throw ImageLoaderError.notFound
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw ImageLoaderError.serverError
        }
        
        debugPrint("-------------------------Download ENDED-------------------------")
        return ContentViewModel.IdentifiableDataSourceModel(imageData: data, url: url)
    }
    
    // MARK: - Tasks
    @MainActor
    func downloadImagesWithTaskGroup(urls: [String]) async throws {
        try await withThrowingTaskGroup(of: ContentViewModel.IdentifiableDataSourceModel.self) { group in
            for url in urls {
                debugPrint("-------------------------TASK START-------------------------")
                group.addTask { try await self.getImageData(urlString: url) }
            }
            
            debugPrint("-------------------------TASK DONE-------------------------")
            for try await item in group {
                imageDataList.append(item)
            }
        }
    }
    
    @MainActor
    func downloadImagesStatically(firstURL: String?, secondURL: String?, thirdURL: String?) async {
        Task {
            async let firstImageData = getImageData(urlString: firstURL)
            async let secondImageData = getImageData(urlString: secondURL)
            async let thirdImageData = getImageData(urlString: thirdURL)
            
            imageDataList = try await [firstImageData, secondImageData, thirdImageData]
        }
    }
}
