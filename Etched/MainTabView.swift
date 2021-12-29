//
//  MainTabView.swift
//  Etched
//
//  Created by Yemi Gabriel on 12/26/21.
//

import SwiftUI

struct MainTabView: View {
    @State private var currentPage = 0
    @State private var isAddJournalShowing = false
    
    
    var body: some View {
        ZStack (alignment: .bottom) {
            
            TabView(selection: $currentPage) {
                JournalListView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                Text("Timeline")
                    .tabItem {
                        Label("Timeline", systemImage: "calendar")
                    }
                Text("Add")
                    .tabItem {
                            Label("Add", systemImage: "plus")
                    }
                    .foregroundColor(.green)
                Text("Stats")
                    .tabItem {
                        Label("Stats", systemImage: "chart.line.uptrend.xyaxis")
                    }
                Text("Settings")
                    .tabItem {
                        Label("Settings", systemImage: "gearshape")
                    }
            }
            .sheet(isPresented: $isAddJournalShowing) {
                AddJournalView()
            }
            
            Button{
                print("add")
                isAddJournalShowing = true
            }label: {
                Image(systemName: "plus")
                    .frame(width: 40)
            }
            .padding()
            .foregroundColor(.white)
            .font(.title.bold())
            .background(.purple)
            .clipShape(Circle())
            .shadow(color: .purple, radius: 10)
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
