//
//  SectionView.swift
//  itunes-api
//
//  Created by Cem Ege on 9.09.2023.
//

import SwiftUI

struct SectionView: View {
    
    // MARK: - Properties    
    let title: String
    let dataList: [ContentViewModel.IdentifiableDataSourceModel]
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.title)
            
            ScrollView(.horizontal) {
                LazyHStack(alignment: .top, spacing: 8) {
                    Rectangle().foregroundColor(.clear).frame(height: 1.0)
                    ForEach(dataList, id: \.id) { data in
                        SectionImageView(url: data.url)
                            .id(data.id)
                    }
                }
                .frame(height: UIScreen.width / 3 - 52)
            }
        }
    }
}

struct SectionView_Previews: PreviewProvider {
    static var previews: some View {
        SectionView(title: "Low Quality",dataList: [])
    }
}
