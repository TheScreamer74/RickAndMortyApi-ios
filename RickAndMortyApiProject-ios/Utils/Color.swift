//
//  Color.swift
//  RickAndMortyApiProject-ios
//
//  Created by Thomas on 01/05/2021.
//

import UIKit

enum Color: Int, CaseIterable {
    case red
    case orange
    case yellow
    case pea
    case green
    case turquoise
    case cyan
    case curellian
    case blue
    case purple
    case magenta
    case pink

    var hue: CGFloat {
        return CGFloat(rawValue) / 12
    }

    var uiColor: UIColor {
        return UIColor(hue: hue,
                       saturation: 1,
                       brightness: 1,
                       alpha: 1)
    }
}
