//
//  MainTabPage.swift
//  Etched
//
//  Created by Yemi Gabriel on 12/26/21.
//

import Foundation
import SwiftUI

struct MainTabPage {
    let title: String
    let imageName: String
    let view: MainTab
    
    static let pages = [
        MainTabPage(title: "Home", imageName: "house", view: .home),
        MainTabPage(title: "Timeline", imageName: "calendar", view: .timeline),
        MainTabPage(title: "Add", imageName: "plus", view: .add),
        MainTabPage(title: "Stats", imageName: "chart.line.uptrend.xyaxis", view: .stats),
        MainTabPage(title: "Settings", imageName: "gearshape", view: .settings)
    ]
}

enum MainTab {
    case home, timeline, add, stats, settings
}
