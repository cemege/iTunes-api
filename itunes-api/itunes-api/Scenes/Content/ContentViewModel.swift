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
    
    var service: SearchServiceProtocol = SearchService()
    var cancellables = Set<AnyCancellable>()
    
    var firstImageURL: URL?
    var secondImageURL: URL?
    var thirdImageURL: URL?
    
    @Published var searchTerm: String = ""
    @Published var screenshotUrls: [String] = []
    @Published var imageLoader = ImageLoader()
    @Published var fetchImageTask: Task<Void, Never>?
    
    @Published var lowSizeImageData: [IdentifiableImageData] = []
    @Published var midSizeImageData: [IdentifiableImageData] = []
    @Published var highSizeImageData: [IdentifiableImageData] = []
    @Published var giganticSizeImageData: [IdentifiableImageData] = []
    
    override init(router: ContentViewRouter) {
        super.init(router: router)
        
        $searchTerm
            .debounce(for: .seconds(0.8), scheduler: RunLoop.main)
            .sink { term in
                debugPrint("Search Request sended")
                
                if term.isEmpty {
                    self.fetchImageTask?.cancel()
                    debugPrint("------------------TASK CANCELLEDDDDDDDDDD-------------")
                }
                
                self.emptyAllData()
                self.fetchSoftwareSearchResponse(term: term)
            }
            .store(in: &cancellables)
        
        $screenshotUrls
            .sink { screenshotUrls in
                var index = 0
                
                for _ in screenshotUrls {
                    guard !self.searchTerm.isEmpty else {
                        debugPrint("searchTerm is empty")
                        return
                    }
                    
                    guard let firstURL = URL(string: screenshotUrls[safe: index] ?? ""),
                          let secondURL = URL(string: screenshotUrls[safe: index + 1] ?? ""),
                          let thirdURL = URL(string: screenshotUrls[safe: index + 2] ?? "")
                    else {  return }
                    
                    self.fetchImageTask = Task {
                        guard !self.searchTerm.isEmpty else {
                            self.emptyAllData()
                            return
                        }
                        
                        debugPrint("Download started \(self.searchTerm)")
                        await self.imageLoader.loadImages(firstURL: firstURL, secondURL: secondURL, thirdURL: thirdURL)
                        debugPrint("Download ended \(self.searchTerm)")
                        
                        //TODO: Downloaded images must be added to cache
                    }
                    
                    index += 3
                }
            }
            .store(in: &cancellables)
        
        imageLoader.$imageData
            .sink { dataModel in
                dataModel.forEach { data in
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

// MARK: - Data Source Helper
extension ContentViewModel {
    struct IdentifiableImageData: Identifiable, Hashable {
        let id: String = UUID().uuidString
        var imageData: Data?
    }
    
    func getScreenshotsUrls() -> [String] {
        guard let response, let results = response.results else { return [] }
        return results.compactMap({ $0.screenshotUrls }).flatMap({ $0 })
    }
    
    func configureImageDataBySize(data: IdentifiableImageData) {
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
    
    func emptyAllData() {
        lowSizeImageData = []
        midSizeImageData = []
        highSizeImageData = []
        giganticSizeImageData = []
    }
}
