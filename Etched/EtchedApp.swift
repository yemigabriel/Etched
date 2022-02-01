//
//  EtchedApp.swift
//  Etched
//
//  Created by Yemi Gabriel on 12/26/21.
//

import SwiftUI

@main
struct EtchedApp: App {
    @Environment(\.scenePhase) var scenePhase
    @StateObject private var viewRouter = ViewRouter()
    @StateObject private var settingsViewModel = SettingsViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewRouter)
                .environmentObject(settingsViewModel)
//                .onChange(of: scenePhase) { newPhase in
//                    if newPhase != .active {
//                        if settingsViewModel.isPasscodeEnabled { settingsViewModel.isLocked = true}
//                    }
//                }
                .onAppear(perform: {
                    if settingsViewModel.isPasscodeEnabled { settingsViewModel.isLocked = true}
                    
                })
        }
    }
}
