//
//  ContentView.swift
//  itunes-api
//
//  Created by Cem Ege on 4.09.2023.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Properties
    @StateObject var viewModel: ContentViewModel
        
    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack {
                Divider()
                Text("Hello, world!")
                
            }
            .searchable(text: $viewModel.searchTerm)
            .padding()
            .navigationTitle("Screenshots")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: .init(router: .init()))
    }
}

// (0-100kb, 100-250kb, 250-500kb, 500+kb) 4 sections in a List
