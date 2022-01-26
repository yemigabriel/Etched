//
//  ChartData.swift
//  Etched
//
//  Created by Yemi Gabriel on 1/25/22.
//

import Foundation

struct ChartData {
    var label: String
    var secondaryLabel: String
    var value: Int
    
    static let sample = [
        ChartData(label: "😀", secondaryLabel: "Happy", value: 3),
        ChartData(label: "😍", secondaryLabel: "In Love", value: 1),
        ChartData(label: "😎", secondaryLabel: "Confident", value: 5),
        ChartData(label: "😱", secondaryLabel: "Scared", value: 1),
        ChartData(label: "😔", secondaryLabel: "Sad", value: 2)
    ]
}

extension ChartData: Equatable {
    static func == (lhs: ChartData, rhs: ChartData) -> Bool {
        lhs.label == rhs.label && lhs.value == rhs.value ? true : false
    }
}

struct PieSlice {
    var startDegree: Double
    var endDegree: Double
}
