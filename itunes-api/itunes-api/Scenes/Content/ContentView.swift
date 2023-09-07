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
    
    @State var contentMode = ContentMode.fit
    @FocusState var isInputActive: Bool
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.lowSizeImageData.isEmpty, viewModel.midSizeImageData.isEmpty, viewModel.highSizeImageData.isEmpty, viewModel.giganticSizeImageData.isEmpty {
                    VStack(alignment: .center) {
                        Text("Start search for some screenshots :)")
                            .font(.largeTitle)
                    }
                    
                } else {
                    ScrollView {
                        Divider()
                        
                        VStack(alignment: .center, spacing: 8) {
                            Text("LOW")
                                .font(.largeTitle)
                            
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]) {
                                ForEach(viewModel.lowSizeImageData) { data in
                                    Image(data: data.imageData ?? Data())
                                        .aspectRatio(contentMode: contentMode)
                                        .font(.system(size: 30))
                                        .frame(width: UIScreen.width / 3 - 52, height: UIScreen.width / 3 - 52)
                                        .cornerRadius(8)
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color.gray, lineWidth: 1)
                                        }
                                }
                            }
                            .padding(16)
                        }
                        
                        Divider()
                        
                        VStack(alignment: .center, spacing: 8) {
                            Text("MID")
                                .font(.largeTitle)
                            
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]) {
                                ForEach(viewModel.midSizeImageData) { data in
                                    Image(data: data.imageData ?? Data())
                                        .aspectRatio(contentMode: contentMode)
                                        .font(.system(size: 30))
                                        .frame(width: UIScreen.width / 3 - 52, height: UIScreen.width / 3 - 52)
                                        .cornerRadius(8)
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color.gray, lineWidth: 1)
                                        }
                                }
                            }
                            .padding(16)
                        }
                        
                        Divider()
                        
                        VStack(alignment: .center, spacing: 8) {
                            Text("HIGH")
                                .font(.largeTitle)
                            
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]) {
                                ForEach(viewModel.highSizeImageData) { data in
                                    Image(data: data.imageData ?? Data())
                                        .aspectRatio(contentMode: contentMode)
                                        .font(.system(size: 30))
                                        .frame(width: UIScreen.width / 3 - 52, height: UIScreen.width / 3 - 52)
                                        .cornerRadius(8)
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color.gray, lineWidth: 1)
                                        }
                                }
                            }
                            .padding(16)
                        }
                        
                        Divider()
                        
                        VStack(alignment: .center, spacing: 8) {
                            Text("GIGANTIC")
                                .font(.largeTitle)
                            
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]) {
                                ForEach(viewModel.giganticSizeImageData) { data in
                                    Image(data: data.imageData ?? Data())
                                        .aspectRatio(contentMode: contentMode)
                                        .font(.system(size: 30))
                                        .frame(width: UIScreen.width / 3 - 52, height: UIScreen.width / 3 - 52)
                                        .cornerRadius(8)
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color.gray, lineWidth: 1)
                                        }
                                }
                            }
                            .padding(16)
                        }
                    }
                }
            }
            .searchable(text: $viewModel.searchTerm)
            .autocorrectionDisabled()
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
