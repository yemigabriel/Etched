//
//  MainTabView.swift
//  Etched
//
//  Created by Yemi Gabriel on 12/26/21.
//

import SwiftUI

struct MainTabView: View {
    @State private var currentPage = 0
    
    var body: some View {
        TabView(selection: $currentPage) {
            JournalListView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            Text("Timeline")
                .tabItem {
                    Label("Timeline", systemImage: "calendar")
                }
            Text("Stats")
                .tabItem {
                    Label("Stats", systemImage: "chart.line.uptrend.xyaxis")
                }
            Text("Settings")
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
