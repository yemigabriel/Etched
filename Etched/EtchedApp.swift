//
//  EtchedApp.swift
//  Etched
//
//  Created by Yemi Gabriel on 12/26/21.
//

import SwiftUI

@main
struct EtchedApp: App {
    @StateObject private var viewRouter = ViewRouter()
    var body: some Scene {
        WindowGroup {
            ContentView()
//                .preferredColorScheme(.dark)
                .environmentObject(viewRouter)
        }
    }
}
