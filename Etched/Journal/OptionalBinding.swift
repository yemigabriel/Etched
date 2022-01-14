//
//  OptionalBinding.swift
//  Etched
//
//  Created by Yemi Gabriel on 12/28/21.
//

import SwiftUI

func ??<T>(lhs: Binding<Optional<T>>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}

func !=<T>(lhs: Binding<Optional<T>>, rhs: Optional<T>) -> Binding<Bool> where T:Equatable {
    Binding (
        get: { lhs.wrappedValue != rhs },
        set: { lhs.wrappedValue = $0 as? T ?? nil }
        )
}
