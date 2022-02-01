//
//  ViewRouter.swift
//  Etched
//
//  Created by Yemi Gabriel on 12/26/21.
//

import Foundation
import SwiftUI

class ViewRouter: ObservableObject {
    @AppStorage("NEW_USER") var isNewUser = true
    
    enum AppView {
        case onboarding, main
    }
}
