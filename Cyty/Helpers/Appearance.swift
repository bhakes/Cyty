//
//  Appearance.swift
//  Cyty
//
//  Created by Benjamin Hakes on 2/4/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

import UIKit

struct Appearance {
    
    // setup Nav Bar Appearance
    static func setupNavAppearance() {
        UINavigationBar.appearance().tintColor = .accentColor
        UINavigationBar.appearance().barTintColor = .darkColor
        UINavigationBar.appearance().largeTitleTextAttributes = [ .foregroundColor: UIColor.accentColor]
        UINavigationBar.appearance().titleTextAttributes = [ .foregroundColor: UIColor.accentColor]
        UINavigationBar.appearance().prefersLargeTitles = true
        UINavigationBar.appearance().isTranslucent = false
        
    }
    
    // setup SegmentedControlAppearance
    static func setupSegmentedControlAppearance() {
        UISegmentedControl.appearance().tintColor = .accentColor
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.darkColor], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.accentColor], for: .normal)
        
    }
    
}

// add UIColor extensions
extension UIColor {
    static let darkColor = UIColor(red: 0.125, green: 0.125, blue: 0.16, alpha: 1.0)
    static let accentColor = UIColor(red: 182/255, green: 60/255, blue: 58/255, alpha: 1)
    static let submitColor = UIColor(red: 0/255, green: 143/255, blue: 0/255, alpha: 1)
}
