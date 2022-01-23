//
//  Dashboard.swift
//  Etched
//
//  Created by Yemi Gabriel on 1/20/22.
//

import SwiftUI

struct DashboardCard {
    
    let title: String
    let image: String
    let size: CGSize
    let action: DashboardAction
    
    static let dashboardCards = [
        DashboardCard(title: "Where you've been ...", image: "dashboard_places", size: CGSize(width: 190, height: 150), action: .showPlaces),
        DashboardCard(title: "How you feel ...", image: "dashboard_mood", size: CGSize(width: 190, height: 150), action: .showMood)
    ]
}

enum DashboardAction {
    case showPlaces
    case showMood
    case addNewJournal
}
