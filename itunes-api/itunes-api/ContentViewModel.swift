//
//  ContentViewModel.swift
//  itunes-api
//
//  Created by Cem Ege on 4.09.2023.
//

import Combine
import API

final class ContentViewModel: BaseViewModel<ContentViewRouter> {
    
    // MARK: - Properties
    private var response: SoftwareSearchResponse?
    
    var service: SearchServiceProtocol?
    var cancellables = Set<AnyCancellable>()
    
    @Published var searchTerm: String = ""
    
    override init(router: ContentViewRouter) {
        super.init(router: router)
        
        $searchTerm
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { term in
                self.fetchSoftwareSearchResponse(term: term)
            }.store(in: &cancellables)
    }
}

// MARK: - API Call
extension ContentViewModel {
    func fetchSoftwareSearchResponse(term: String) {
        let request = SearchRequestType.SoftwareSearch(term: term)
        service?.softwareSearch(request: request)
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
                debugPrint(response)
                
                
            }
            .store(in: &cancellables)
    }
}

// MARK: - Data Source Helper
extension ContentViewModel {
    func getScreenshotsURLs() -> [String] {
        guard let response, let results = response.results else { return [] }
        return results.compactMap({ $0.screenshotUrls }).flatMap({ $0 })
    }
}
