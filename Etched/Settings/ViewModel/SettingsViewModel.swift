//
//  SettingsViewModel.swift
//  Etched
//
//  Created by Yemi Gabriel on 1/30/22.
//

import SwiftUI
import UserNotifications
import SwiftKeychainWrapper

class SettingsViewModel: ObservableObject {
    
    @AppStorage(wrappedValue: false, "DARK_MODE") var storedColorScheme
    @AppStorage(wrappedValue: false, "PASSCODE") var isPasscodeEnabled
    @AppStorage(wrappedValue: false, "LOCKED") var isLocked
    
    @Published var passcode = ""
    @Published var confirmPasscode = ""
    @Published var hasError = false
    @Published var errorMessage = ""
    @Published var passcodeState: PasscodeState = .newPasscode
    
    @Published var isReminder = false
    @Published var selectedTime = Date.now + (60 * 60)
    @Published var selectedFrequency: ReminderFrequency = .daily
    @Published var showPassCodeView = false
    
    let maxLength = 4
    static let notificationId = "com.yemigabriel.etched.notification"
    static let writeActionId = "com.yemigabriel.etched.notification.action.write"
    static let reminders: [(title: String, subtitle: String, action: String)] = [
        (title: "Etched", subtitle: "Write in your journal now?", action: "Write now"),
        (title: "Etched", subtitle: "What are you grateful for?", action: "Write now")
    ]
    
    static let privacyPolicy = "https://docs.google.com/document/d/1PYlXzY6uPLrvjlkZ5hUgEm5Tv3JayJtmRNQSy1lsozs/edit?usp=sharing"
    static let termsOfUse = "https://docs.google.com/document/d/1orcLD9OQZy-lEKSjjNQpehR6GyL0uMJpgDO8Xxxcqok/edit?usp=sharing"
    
    
    func lock() {
        KeychainWrapper.standard[.passcode] = passcode
        isLocked = true
        isPasscodeEnabled = true
        reset()
    }
    
    func unlock() -> Bool {
        if let storedPasscode = KeychainWrapper.standard.string(forKey: .passcode) {
            if storedPasscode == passcode {
                isLocked = false
                reset()
                return true
            }
            else {
                hasError = true
                errorMessage = "Passcode does not match. Try again"
            }
        }
        return false
    }
    
    func trim(_ text: String, at maxLength: Int) -> String {
        var text = text
        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return "" }
        guard Int(text) != nil else {
            text.removeLast()
            return text
        }
        if text.count > maxLength {
            return String( text.prefix(maxLength) )
        }
        return text
    }
    
    func isMaxLength(text: String) -> Bool {
        if text.count == maxLength { return true }
        return false
    }
    
    func isPasswordConfirmed() -> Bool {
        passcode == confirmPasscode
    }
    
    func reset() {
        passcode = ""
        confirmPasscode = ""
    }
    
    // reminders
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if let error = error {
                //TODO: custom error plus alert
                print(error.localizedDescription)
            }
        }
    }
    
    func checkAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
            if settings.authorizationStatus == .notDetermined {
                self?.requestNotificationPermission()
            } else if settings.authorizationStatus == .denied {
                //TODO: custom error plus alert
                UIApplication.requestSettings()
            } else if settings.authorizationStatus == .authorized {
//                self?.scheduleReminder()
            }
        }
    }
    
    func scheduleReminder() {
        
        let content = UNMutableNotificationContent()
        
        guard let reminderContent = Self.reminders.randomElement() else {return}
        content.title = reminderContent.title
        content.subtitle = reminderContent.subtitle
        content.sound = .default
        
        let calendar = Calendar.current
        let dailyComponents = calendar.dateComponents([.hour, .minute], from: selectedTime)
        let weeklyComponents = calendar.dateComponents([.day, .hour, .minute], from: selectedTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: selectedFrequency == .daily ? dailyComponents : weeklyComponents, repeats: selectedFrequency != .noRepeat)
        
        let action = UNNotificationAction(identifier: Self.writeActionId, title: reminderContent.action, options: [])
        let category = UNNotificationCategory(identifier: "reminder", actions: [action], intentIdentifiers: [], options: [])
        let request = UNNotificationRequest(identifier: Self.notificationId, content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.setNotificationCategories([category])
        center.add(request)
    }
    
    func cancelReminder() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [Self.notificationId])
    }
    
}

enum PasscodeState {
    case newPasscode, confirmPasscode, enterPasscode
    var description: String {
        switch self {
        case .newPasscode:
            return "Create a new 4 digit passcode to lock access to your journals."
        case .confirmPasscode:
            return "Confirm your 4 digit passcode"
        case .enterPasscode:
            return "Enter your secure passcode to gain access to your journals."
        }
    }
}

enum ReminderFrequency: String, CaseIterable {
    case daily = "Daily"
    case weekly = "Weekly"
    case noRepeat = "Do not repeat"
}
