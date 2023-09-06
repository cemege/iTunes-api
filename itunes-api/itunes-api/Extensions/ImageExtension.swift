//
//  ImageExtension.swift
//  itunes-api
//
//  Created by Cem Ege on 5.09.2023.
//

import SwiftUI
import UIKit.UIImage

extension Image {
    init(data: Data) {
        if let uiImage = UIImage(data: data) {
            self.init(uiImage: uiImage)
        } else {
            self.init(systemName: "questionmark")
        }
    }
}
