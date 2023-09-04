//
//  ContentView.swift
//  itunes-api
//
//  Created by Cem Ege on 4.09.2023.
//

import SwiftUI
import API
import Combine

struct ContentView: View {
    
    @StateObject var viewModel: ContentViewModel
    
    var body: some View {
        VStack {
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            viewModel.getSearchResponse()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: .init(router: .init()))
    }
}
