//
//  Constants.swift
//  LampaFridge
//
//  Created by Yurii Honcharov on 07.12.2023.
//

import Foundation
import UIKit

struct BaseConstants {
    static let screen = "screen"
    static let play = "play"
    static let scene = "art.scnassets/player.scn"
}

struct StringConstants {
    static let goToFridge = String(localized: "GoToFridge")
    static let start = String(localized: "START")
    static let fridge = String(localized: "Fridge")
}

struct AssetsConstants {
    static let lampaLogo = UIImage(named: "lampaLogo")
    static let yellowColor = UIColor(named: "BaseYellow")
    static let yellowColor40 = UIColor(named: "BaseYellow40")
    static let whiteColor = UIColor(named: "BaseWhite")
}

struct VideoConstants {
    static let defaultVideoName = "Default"
    static let trackingImages = "TrackingImages"
    static let plane = "plane"
}
