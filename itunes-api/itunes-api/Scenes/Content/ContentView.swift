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
                 
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 8) {
                        ForEach(viewModel.imageData, id: \.self) { data in
                            Image(data: data)
                                .resizable()
                                .aspectRatio(1, contentMode: .fit)
                                .frame(width: (UIScreen.width - 32) / 2)
                                .frame(height: (UIScreen.width - 32) / 2)
                        }
                    }
                    .padding(16)
                }
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
