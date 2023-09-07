//
//  ImageGridView.swift
//  itunes-api
//
//  Created by Cem Ege on 7.09.2023.
//

import SwiftUI

struct ImageGridView: View {
    
    // MARK: - Properties
    var title: String
    var dataList: [ContentViewModel.IdentifiableImageData] = []
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text(title)
                .font(.largeTitle)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]) {
                ForEach(dataList) { data in
                    Image(data: data.imageData ?? Data())
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.width / 3 - 52, height: UIScreen.width / 3 - 52)
                        .cornerRadius(8)
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        }
                }
            }
            .padding(16)
            
            Divider()
        }
    }
}

struct ImageGridView_Previews: PreviewProvider {
    static var previews: some View {
        ImageGridView(title: "LOW QUALITY", dataList: [])
    }
}
