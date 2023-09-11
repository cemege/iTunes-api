//
//  FullScreenImageView.swift
//  itunes-api
//
//  Created by Cem Ege on 9.09.2023.
//

import SwiftUI

struct FullScreenImageView: View {
    
    // MARK: - Properties
    @Environment(\.dismiss) var dismiss
    
    var imageData: Data?
    var url: URL?
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .center) {
                Color.black.opacity(1).ignoresSafeArea()
                
                AsyncImage(url: url)
                    .scaledToFit()
            }
            .background {
                
            }
            .toolbar {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "multiply")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundColor(.white)
                }
            }
        }
    }
    
    struct IdentifiableModel: Identifiable {
        let id: String = UUID().uuidString
        let url: URL?
    }
}

struct FullScreenImageView_Previews: PreviewProvider {
    static var previews: some View {
        FullScreenImageView(imageData: nil)
    }
}
