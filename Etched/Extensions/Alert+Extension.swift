//
//  Alert+Extension.swift
//  Etched
//
//  Created by Yemi Gabriel on 1/12/22.
//

import SwiftUI

extension Alert {
    init(localizedError: LocalizedError) {
        self = Alert(title: Text(localizedError.localizedDescription), message: Text(localizedError.recoverySuggestion ?? ""), dismissButton: .default(Text("OK")))
    }
    
    init(error: LocationError?, primaryButtonTitle: String, secondaryButtonTitle: String, primaryAction: @escaping ()->Void, secondaryAction: @escaping ()->Void) {
        let message: Text? = {
            let message = error?.recoverySuggestion
            return Text(message ?? "")
        }()
        self = Alert(title: Text(error?.localizedDescription ?? "Oops"),
                     message: message,
                     primaryButton: .default(Text(primaryButtonTitle), action: primaryAction),
                     secondaryButton: .default(Text(secondaryButtonTitle), action: secondaryAction ))
    }
}
