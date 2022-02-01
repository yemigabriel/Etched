//
//  MainTabView.swift
//  Etched
//
//  Created by Yemi Gabriel on 12/26/21.
//

import SwiftUI

struct MainTabView: View {
    @State private var isAddJournalShowing = false
    @Environment(\.dismiss) var dismiss
    @AppStorage(wrappedValue: false, "LOCKED") var isLocked
    
    
    var body: some View {
        ZStack (alignment: .bottom) {
            
            TabView{
                DashboardView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                
                Text("Add")
                    .tabItem {
                            Label("Add", systemImage: "plus")
                    }
                
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gearshape")
                    }
            }
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name(SettingsViewModel.notificationId)), perform: { response in
                if (response.object as? UNNotificationContent) != nil {
                    isAddJournalShowing = true
                }
            })
            .sheet(isPresented: $isAddJournalShowing) {
                AddJournalView()
            }
            .fullScreenCover(isPresented: $isLocked, content: {
                SetPassCode(passcodeState: PasscodeState.enterPasscode)
            })
            
            
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
