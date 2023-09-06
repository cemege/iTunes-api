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
    
    @Published var searchTerm: String = ""
    @Published var screenshotUrls: [String] = []
    @Published var imageLoader = ImageLoader()
    @Published var imageData: [Data] = []
    
    override init(router: ContentViewRouter) {
        super.init(router: router)
        
        $searchTerm
            .debounce(for: .seconds(0.8), scheduler: RunLoop.main)
            .sink { term in
                debugPrint("Search Request sended")
                self.imageData = []
                self.fetchSoftwareSearchResponse(term: term)
            }
            .store(in: &cancellables)
        
        $screenshotUrls
            .sink { screenshotUrls in
                var index = 0
                screenshotUrls.forEach { _ in
                    guard !self.searchTerm.isEmpty else {
                        debugPrint("searchTerm is empty")
                        return
                    }
                    guard let firstURL = URL(string: screenshotUrls[safe: index] ?? ""),
                          let secondURL = URL(string: screenshotUrls[safe: index + 1] ?? ""),
                          let thirdURL = URL(string: screenshotUrls[safe: index + 2] ?? "")
                    else {  return }
                    
                    Task {
                        guard !self.searchTerm.isEmpty else {
                            self.imageData = []
                            return
                        }
                        
                        debugPrint("Download started \(self.searchTerm)")
                        await self.imageLoader.loadImages(firstURL: firstURL, secondURL: secondURL, thirdURL: thirdURL)
                        debugPrint("Download ended \(self.searchTerm)")
                        
                        //TODO: TASK MUST BE CANCEL
                        //TODO: Downloaded images must be added to cache
                    }
                    
                    index += 3
                }
            }
            .store(in: &cancellables)
        
        imageLoader.$imageData
            .sink { imageDatas in
                debugPrint("\(imageDatas) for \(self.searchTerm)")
                
                imageDatas.forEach { imageData in
                    guard !self.searchTerm.isEmpty else {
                        self.imageData = []
                        return
                    }
                    self.imageData.append(imageData)
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - API Call
extension ContentViewModel {
    func fetchSoftwareSearchResponse(term: String) {
//        guard !term.isEmpty else { return } //TODO: add isBlank
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
    func getScreenshotsUrls() -> [String] {
        guard let response, let results = response.results else { return [] }
        return results.compactMap({ $0.screenshotUrls }).flatMap({ $0 })
    }
}
