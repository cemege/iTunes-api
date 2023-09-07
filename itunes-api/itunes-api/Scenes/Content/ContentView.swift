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
            ScrollView {
                VStack {
                    if viewModel.lowSizeImageData.isEmpty, viewModel.midSizeImageData.isEmpty, viewModel.highSizeImageData.isEmpty, viewModel.giganticSizeImageData.isEmpty {
                        VStack(alignment: .center) {
                            Text("Start search for some screenshots :)")
                                .font(.largeTitle)
                        }
                        
                    } else {
                        Divider()
                        
                        if !viewModel.lowSizeImageData.isEmpty {
                            AsyncImageGridView(title: "LOW Quality", dataList: viewModel.lowSizeImageData)
                        }

                        if !viewModel.midSizeImageData.isEmpty {
                            AsyncImageGridView(title: "MID Quality", dataList: viewModel.midSizeImageData)
                        }

                        if !viewModel.highSizeImageData.isEmpty {
                            AsyncImageGridView(title: "HIGH Quality", dataList: viewModel.highSizeImageData)
                        }

                        if !viewModel.giganticSizeImageData.isEmpty {
                            AsyncImageGridView(title: "GIGANTIC Quality", dataList: viewModel.giganticSizeImageData)
                        }
                    }
                }
                .searchable(text: $viewModel.searchTerm, placement: .navigationBarDrawer(displayMode: .always))
                .autocorrectionDisabled()
                .padding()
                .navigationTitle("Screenshots")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: .init(router: .init()))
    }
}
