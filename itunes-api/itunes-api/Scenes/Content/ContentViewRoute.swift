//
//  ContentViewRoute.swift
//  itunes-api
//
//  Created by Cem Ege on 4.09.2023.
//

import class API.SearchService

protocol ContentViewRoute {
    func presentContentView() -> ContentView
}

extension ContentViewRoute where Self: Router {
    func presentContentView() -> ContentView {
        return ContentView(viewModel: .init(router: .init()))
    }
}
