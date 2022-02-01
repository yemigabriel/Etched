//
//  SetPassCode.swift
//  Etched
//
//  Created by Yemi Gabriel on 1/27/22.
//

import SwiftUI
import SwiftKeychainWrapper

struct SetPassCode: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @FocusState private var focused: Bool
    let maxLength = 4
    var passcodeState: PasscodeState?
    
    init(passcodeState: PasscodeState = .newPasscode) {
        self.passcodeState = passcodeState
    }
    
    
    var body: some View {
        NavigationView {
            VStack(spacing: 100){
                Text(settingsViewModel.passcodeState.description)
                    .font(.headline)
                    .kerning(2.5)
                    .multilineTextAlignment(.center)
                
                if settingsViewModel.passcodeState == .newPasscode {
                    TextField("* * * *", text: $settingsViewModel.passcode)
                        .focused($focused)
                        .font(.largeTitle)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        .onChange(of: settingsViewModel.passcode) { text in
                            settingsViewModel.passcode = settingsViewModel.trim(text, at: maxLength)
                            if settingsViewModel.passcode.count == maxLength {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    settingsViewModel.passcodeState = .confirmPasscode
                                }
                            }
                        }
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                focused = true
                            }
                        }
                }
                
                if settingsViewModel.passcodeState == .confirmPasscode {
                    TextField("* * * *", text: $settingsViewModel.confirmPasscode)
                        .focused($focused)
                        .font(.largeTitle)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        .onChange(of: settingsViewModel.confirmPasscode) { text in
                            settingsViewModel.confirmPasscode = settingsViewModel.trim(text, at: maxLength)
                            if settingsViewModel.isMaxLength(text: settingsViewModel.confirmPasscode) && !settingsViewModel.isPasswordConfirmed(){
                                settingsViewModel.hasError = true
                                settingsViewModel.errorMessage = "Passcode doesn't match"
                            }
                        }
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                focused = true
                            }
                        }
                }
                
                if settingsViewModel.passcodeState == .enterPasscode {
                    TextField("* * * *", text: $settingsViewModel.passcode)
                        .focused($focused)
                        .font(.largeTitle)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        .onChange(of: settingsViewModel.passcode) { text in
                            settingsViewModel.passcode = settingsViewModel.trim(text, at: maxLength)
                            if settingsViewModel.isMaxLength(text: settingsViewModel.passcode) {
                                if settingsViewModel.unlock() {
                                    dismiss()
                                }
                            }
                        }
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                focused = true
                            }
                        }
                }
                
                if settingsViewModel.hasError{
                    Text(settingsViewModel.errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .kerning(2.5)
                }
                    
                
            }
            .onAppear(perform: {
                settingsViewModel.passcodeState = passcodeState!
            })
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if settingsViewModel.passcodeState != .enterPasscode {
                        Button{
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.headline.bold())
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if settingsViewModel.passcodeState == .confirmPasscode {
                        Button("Save Passcode"){
                            settingsViewModel.lock()
                            dismiss()
                        }
                        .disabled(settingsViewModel.passcode != settingsViewModel.confirmPasscode)
                    }
                }
            }
        }
    }
    
}

struct SetPassCode_Previews: PreviewProvider {
    static var previews: some View {
        SetPassCode()
    }
}

extension KeychainWrapper.Key {
    static let passcode: KeychainWrapper.Key = "PASSCODE"
}
