//
//  UIScreenExtension.swift
//  itunes-api
//
//  Created by Cem Ege on 5.09.2023.
//

import UIKit.UIScreen

extension UIScreen {
    class var orientation: UIInterfaceOrientation {
        return UIApplication
            .shared
            .connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?
            .windowScene?
            .interfaceOrientation ?? .portrait
    }
    
    class var width: CGFloat {
        return orientation.isPortrait ? UIScreen.main.bounds.size.width : UIScreen.main.bounds.size.height
    }
    
    class var height: CGFloat {
        return orientation.isPortrait ? UIScreen.main.bounds.size.height : UIScreen.main.bounds.size.width
    }
}
