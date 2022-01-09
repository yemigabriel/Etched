//
//  View+Extension.swift
//  Etched
//
//  Created by Yemi Gabriel on 1/8/22.
//

import SwiftUI

extension View {
    func onboardingButtonStyle<T>(shape: T) -> some View where T: Shape{
        modifier(OnboardingButtonStyle(shape: shape))
    }
}
