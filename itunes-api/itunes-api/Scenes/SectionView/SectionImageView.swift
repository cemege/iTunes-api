//
//  SectionImageView.swift
//  itunes-api
//
//  Created by Cem Ege on 11.09.2023.
//

import SwiftUI

struct SectionImageView: View {
    
    // MARK: - Properties
    @State private var fullScreenImageModel: FullScreenImageView.IdentifiableModel?
    
    var url: URL?
    
    var body: some View {
        ZStack {
            AsyncImage(url: url)
                .aspectRatio(contentMode: .fit)
                .frame(width: UIScreen.width / 3 - 52, height: UIScreen.width / 3 - 52)
                .cornerRadius(8)
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                }
                .onTapGesture {
                    fullScreenImageModel = .init(url: url)
                }
        }
        .fullScreenCover(item: $fullScreenImageModel) { model in
            FullScreenImageView(url: model.url)
        }
    }
}

struct SectionImageView_Previews: PreviewProvider {
    static var previews: some View {
        SectionImageView()
    }
}
