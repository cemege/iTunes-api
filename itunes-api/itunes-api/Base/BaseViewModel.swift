//
//  BaseViewModel.swift
//  itunes-api
//
//  Created by Cem Ege on 4.09.2023.
//

import SwiftUI
import struct API.APIError

protocol BaseViewModelProtocol: ObservableObject {}

class BaseViewModel<R: Router>: BaseViewModelProtocol {
    
    // MARK: - Properties
    let router: R
    
    init(router: R) {
        self.router = router
    }
    
    deinit {
        debugPrint("deinit: \(self)")
    }
}

