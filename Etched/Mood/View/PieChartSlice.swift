//
//  PieChartSliceView.swift
//  Etched
//
//  Created by Yemi Gabriel on 1/25/22.
//

import SwiftUI

struct PieChartSlice: View {
    var center: CGPoint
    var radius: CGFloat
    var startDegree: Double
    var endDegree: Double
    
    var isTouched: Bool
    var accentColor: Color
    var separatorColor: Color
    
    var path: Path {
        var path = Path()
        path.addArc(center: center, radius: radius, startAngle: .degrees(startDegree), endAngle: .degrees(endDegree), clockwise: false)
        path.addLine(to: center)
        path.closeSubpath()
        return path
    }
    
    var body: some View {
        VStack {
            path
                .fill(accentColor)
                .overlay(path.stroke(separatorColor, lineWidth: 2))
                .scaleEffect(isTouched ? 1.05 : 1)
                .animation(.spring(), value: 0.5)
        }
    }
}
