//
//  MoodChartViewModel.swift
//  Etched
//
//  Created by Yemi Gabriel on 1/23/22.
//

import Combine
import SwiftUI

class MoodChartViewModel: ObservableObject {
    
    @Published var moods = [MoodMO]()
    @Published var chartData = [ChartData]()
    
    @Published var pieSlices = [PieSlice]()
    
    @Published var showDetail = false
    @Published var selectedMood: String?
    
    private var cancellable: AnyCancellable?
    
    let accentColors: [Color] = [.red, .blue, .yellow, .purple , .cyan, .mint, .pink, .brown, .orange, .green]
    let separatorColor = Color(uiColor: UIColor.systemBackground)
    
    init(publisher: AnyPublisher<[MoodMO], Never> = MoodCoreDataHelper.shared.moods.eraseToAnyPublisher()){
        cancellable = publisher.sink { [weak self] moods in
            self?.moods = moods
            print("Moods ", moods.count)
        }
    }
    
    func getChartData() {
        var chartData = [ChartData]()
        moods.forEach{ mood in
            if mood.wrappedJournals.isNotEmpty() {
                let data = ChartData(label: mood.wrappedEmoji, secondaryLabel: mood.wrappedName, value: mood.wrappedJournals.count)
                chartData.append(data)
            }
        }
        getPieSlices(chartData)
        print("CHart data: ", chartData.count)
        self.chartData = chartData
    }
    
    func getPieSlices(_ chartData: [ChartData]) {
        var slices = [PieSlice]()
        chartData.enumerated().forEach { index, _ in
            let value = normalizedSliceValue(for: index, chartData)
            if slices.isEmpty {
                slices.append(PieSlice(startDegree: 0, endDegree: value))
            } else {
                slices.append(PieSlice(startDegree: slices.last!.endDegree, endDegree: value + slices.last!.endDegree))
            }
        }
        pieSlices = slices
        print("Pie SLices ", pieSlices)
    }
    
    func normalizedSliceValue(for index: Int, _ chartData: [ChartData]) -> Double {
        let sum = chartData.reduce(0){ $0 + $1.value}
        let value = Double(chartData[index].value) * 360.0 / Double(sum)
        return value
    }
    
}

