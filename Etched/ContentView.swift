//
//  ContentView.swift
//  Etched
//
//  Created by Yemi Gabriel on 12/26/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var viewRouter: ViewRouter
    
    var body: some View {
        if viewRouter.isNewUser {
            OnboardingView()
        } else {
            MainTabView()
        }
//        switch viewRouter.currentView {
//        case .onboarding:
//            OnboardingView()
//        case .main:
//            Text("Main")
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
