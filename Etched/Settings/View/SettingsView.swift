//
//  SettingsView.swift
//  Etched
//
//  Created by Yemi Gabriel on 1/26/22.
//

import SwiftUI


struct SettingsView: View {
    
    @EnvironmentObject private var viewModel: SettingsViewModel
    @AppStorage(wrappedValue: false, PersistenceController.syncCloudKey) var shouldSyncWithCloud
    
    var body: some View {
        NavigationView {
            Form {
                Section("General") {
                    HStack {
                        Toggle("Reminders", isOn: $viewModel.isReminder.animation())
                            .onAppear{
                                viewModel.checkAuthorizationStatus()
                            }
                            .onChange(of: viewModel.isReminder) { newValue in
                                if !newValue {
                                    viewModel.cancelReminder()
                                }
                            }
                    }
                    if viewModel.isReminder {
                        HStack {
                            DatePicker("Time", selection: $viewModel.selectedTime, displayedComponents: .hourAndMinute)
                                .onAppear {
                                    viewModel.scheduleReminder()
                                }
                                .onChange(of: viewModel.selectedTime) { _ in
                                    viewModel.scheduleReminder()
                                }
                        }
                        HStack {
                            Picker("Repeat", selection: $viewModel.selectedFrequency) {
                                Section {
                                    ForEach(ReminderFrequency.allCases, id: \.self) {
                                        Text($0.rawValue)
                                    }
                                }
                            }
                            .onChange(of: viewModel.selectedFrequency) { _ in
                                viewModel.scheduleReminder()
                            }
                        }
                    }
                    Toggle("Dark mode", isOn: $viewModel.storedColorScheme)
                }
                Section("Data & Security") {
                    Toggle("Sync with iCloud", isOn: $shouldSyncWithCloud)
                        .onChange(of: shouldSyncWithCloud) { sync in
                            if sync {
                                print("sync: ", sync)
                            }
                        }
                    
                    Toggle("Set Passcode", isOn: $viewModel.isPasscodeEnabled)
                        .onChange(of: viewModel.isPasscodeEnabled) { _ in
                            if viewModel.isPasscodeEnabled == false {
                                viewModel.isLocked = false
                            } else {
                                viewModel.showPassCodeView = true
                            }
                    }
                }
                Section("About") {
                    HStack {
                        Text("Terms of Use")
                            .onTapGesture {
                                if let url = URL(string: SettingsViewModel.termsOfUse) {
                                    UIApplication.shared.open(url, options: [:])
                                }
                            }
                    }
                    HStack {
                        Text("Privacy Policy")
                            .onTapGesture {
                                if let url = URL(string: SettingsViewModel.privacyPolicy) {
                                    UIApplication.shared.open(url, options: [:])
                                }
                            }
                    }
                    HStack {
                        VStack {
                            Text("Etched 1.0.0")
                            Text("Copyright 2022")
                                .font(.footnote)
                        }
                        Spacer()
                    }
                }
            }
            .fullScreenCover(isPresented: $viewModel.showPassCodeView, content: {
                SetPassCode()
            })
            .navigationTitle("Settings")
        }
        .navigationViewStyle(.stack)
    }
    
    
    func setReminder() {
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
