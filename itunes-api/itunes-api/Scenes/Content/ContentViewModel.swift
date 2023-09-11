//
//  ContentViewModel.swift
//  itunes-api
//
//  Created by Cem Ege on 4.09.2023.
//

import SwiftUI
import Combine
import API

final class ContentViewModel: BaseViewModel<ContentViewRouter> {
    
    // MARK: - Properties
    private var response: SoftwareSearchResponse?
    private let maxAsyncTaskCount: Int = 3
    
    var service: SearchServiceProtocol = SearchService()
    var cancellables = Set<AnyCancellable>()
    
    @Published var searchTerm: String = ""
    @Published var screenshotUrls: [String] = []
    @Published var maxAsyncTaskItems: Array<[String]> = []
    @Published var imageLoader = ImageLoader()
    @Published var fetchImageTask: Task<Void, Error>?
    
    @Published var lowSizeImageData: [IdentifiableDataSourceModel] = []
    @Published var midSizeImageData: [IdentifiableDataSourceModel] = []
    @Published var highSizeImageData: [IdentifiableDataSourceModel] = []
    @Published var giganticSizeImageData: [IdentifiableDataSourceModel] = []
    
    override init(router: ContentViewRouter) {
        super.init(router: router)
        
        sinkSearchTerm()
        sinkScreenshotUrls()
        sinkImageLoaderDataList()
    }
}

// MARK: - API Call
extension ContentViewModel {
    func fetchSoftwareSearchResponse(term: String) {
        guard !term.isEmpty else { return } //TODO: add isBlank
        let request = SearchRequestType.SoftwareSearch(term: term)
        service.softwareSearch(request: request)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    debugPrint(error)
                case .finished:
                    debugPrint("Finished")
                }
            } receiveValue: { [weak self] response in
                guard let self else { return }
                self.response = response
                debugPrint("Search Request ended")
                screenshotUrls = getScreenshotsUrls()
            }
            .store(in: &cancellables)
    }
}

// MARK: - Sink Helper
private extension ContentViewModel {
    private func sinkSearchTerm() {
        $searchTerm
            .debounce(for: .seconds(0.8), scheduler: RunLoop.main)
            .sink { term in
                if term.isEmpty {
                    self.fetchImageTask?.cancel()
                    debugPrint("------------------TASK CANCELLEDDDDDDDDDD-------------")
                }
                
                self.emptyAllData()
                self.fetchSoftwareSearchResponse(term: term)
            }
            .store(in: &cancellables)
    }
    
    private func sinkScreenshotUrls() {
        $screenshotUrls
            .sink { screenshotUrls in
                
                guard !self.searchTerm.isEmpty else {
                    self.emptyAllData()
                    return
                }
                
                let screenshotUrlSet = Set<String>(screenshotUrls)
                
                for item in stride(from: 0, to: screenshotUrlSet.count, by: self.maxAsyncTaskCount) {
                    guard !self.searchTerm.isEmpty else {
                        self.emptyAllData()
                        break
                    }
                    
                    let endIndex = min(item + self.maxAsyncTaskCount, screenshotUrls.count)
                    let subArray = Array(screenshotUrls[item..<endIndex])
                    self.maxAsyncTaskItems.append(subArray)
                    
                    
//                    var index = 0
//                    guard let firstURL = URL(string: screenshotUrls[safe: index] ?? ""),
//                          let secondURL = URL(string: screenshotUrls[safe: index + 1] ?? ""),
//                          let thirdURL = URL(string: screenshotUrls[safe: index + 2] ?? "")
//                    else {  return }
//
//                    self.fetchImageTask = Task {
//                        guard !self.searchTerm.isEmpty else {
//                            self.emptyAllData()
//                            return
//                        }
//
//                        debugPrint("Download started \(self.searchTerm)")
//                        await self.imageLoader.downloadImages(firstURL: firstURL, secondURL: secondURL, thirdURL: thirdURL)
//                        debugPrint("Download ended \(self.searchTerm)")
//
//                        //TODO: Downloaded images must be added to cache
//                    }
//
//                    index += 3
                }
                
                self.sinkMaxAsyncTaskItems()
            }
            .store(in: &cancellables)
    }
    
    private func sinkMaxAsyncTaskItems() {
        guard !self.searchTerm.isEmpty else {
            self.emptyAllData()
            return
        }
        
        for urls in maxAsyncTaskItems {
            guard !self.searchTerm.isEmpty else {
                self.emptyAllData()
                break
            }
            
            self.fetchImageTask = Task {
                try await self.imageLoader.downloadImagesWithTaskGroup(urls: urls)
//                await self.imageLoader.downloadImagesStatically(firstURL: urls[safe: 0], secondURL: urls[safe: 1], thirdURL: urls[safe: 2])
            }
        }
    }
    
    private func sinkImageLoaderDataList() {
        imageLoader.$imageDataList
            .sink { dataList in
                for data in dataList {
                    guard !self.searchTerm.isEmpty else {
                        self.emptyAllData()
                        return
                    }
                    
                    self.configureImageDataBySize(data: data)
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Data Source Helper
private extension ContentViewModel {
    private func getScreenshotsUrls() -> [String] {
        guard let response, let results = response.results else { return [] }
        return results.compactMap({ $0.screenshotUrls }).flatMap({ $0 })
    }
    
    private func configureImageDataBySize(data: IdentifiableDataSourceModel) {
        guard let sizeInBytes = data.imageData?.count else { return }
        
        let imageDataSizeInKB = sizeInBytes / 1024
        
        switch imageDataSizeInKB {
        case 0..<100:
            lowSizeImageData.append(data)
            
        case 100..<250:
            midSizeImageData.append(data)
            
        case 250..<500:
            highSizeImageData.append(data)
            
        case 500..<Int.max:
            giganticSizeImageData.append(data)
            
        default: break
        }
    }
    
    private func emptyAllData() {
        lowSizeImageData = []
        midSizeImageData = []
        highSizeImageData = []
        giganticSizeImageData = []
    }
}

// MARK: - Identifiable Model Helper
extension ContentViewModel {
    struct IdentifiableDataSourceModel: Identifiable, Hashable {
        let id: UUID = UUID()
        var imageData: Data?
        var url: URL?
    }
}
