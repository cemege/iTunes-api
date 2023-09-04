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
    let service: SearchServiceProtocol = SearchService()
    var cancellables = Set<AnyCancellable>()
    
    private var response: SoftwareSearchResponse?
}

// MARK: - API Call
extension ContentViewModel {
    func getSearchResponse() {
        let request = SearchRequestType.SoftwareSearch(term: "swift")
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
                debugPrint(response)
            }
            .store(in: &cancellables)
    }
}
