//
//  ContentView.swift
//  Etched
//
//  Created by Yemi Gabriel on 12/26/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var viewRouter: ViewRouter
    @ObservedObject var journalViewModel = JournalViewModel()
    
    var body: some View {
        if viewRouter.isNewUser {
            OnboardingView()
        } else {
            MainTabView()
                .environmentObject(journalViewModel)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
