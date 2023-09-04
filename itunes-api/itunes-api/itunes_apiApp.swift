//
//  itunes_apiApp.swift
//  itunes-api
//
//  Created by Cem Ege on 4.09.2023.
//

import SwiftUI

@main
struct itunes_apiApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: .init(router: .init()))
        }
    }
}
