//
//  ContentView.swift
//  Etched
//
//  Created by Yemi Gabriel on 12/26/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var viewRouter: ViewRouter
    @AppStorage(wrappedValue: true, "DARK_MODE") var darkMode
    
    init() {
    }
    
    var body: some View {
        if viewRouter.isNewUser {
            OnboardingView()
        } else {
            MainTabView()
                .preferredColorScheme(darkMode ? .dark : .light)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

class ContentViewModel: ObservableObject {
    
}
