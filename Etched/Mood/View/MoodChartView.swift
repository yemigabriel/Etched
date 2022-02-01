//
//  MoodChartView.swift
//  Etched
//
//  Created by Yemi Gabriel on 1/23/22.
//

import SwiftUI

struct MoodChartView: View {
    @StateObject var viewModel = MoodChartViewModel()
    
    let legendColumns = [
        GridItem(.adaptive(minimum: 100, maximum: 200))
    ]
    let message = "No journals with moods have been created"
    
    var body: some View {
        VStack {
            if viewModel.chartData.isEmpty {
                EmptyList(message: message)
            }
            ZStack(alignment: .center) {
                GeometryReader { proxy in
                    let frame = proxy.frame(in: .local)
                    ZStack {
                        ForEach(0..<viewModel.chartData.count, id: \.self) { i in
                            PieChartSlice(
                                center: CGPoint(x: frame.midX, y: frame.midY),
                                radius: frame.width/2,
                                startDegree: viewModel.pieSlices[i].startDegree,
                                endDegree: viewModel.pieSlices[i].endDegree,
                                isTouched: false,
                                accentColor: viewModel.accentColors[i],
                                separatorColor: viewModel.separatorColor)
                                .onTapGesture {
                                    viewModel.showDetail.toggle()
                                    viewModel.selectedMood = viewModel.chartData[i].label
                                }
                        }
                        
                        Circle()
                            .fill(viewModel.separatorColor)
                            .frame(width: frame.width/2, height: frame.width/2, alignment: .center)
                    }
                }
                .aspectRatio(contentMode: .fit)
            }
            .padding()
            LazyVGrid(columns: legendColumns) {
                ForEach(0..<viewModel.chartData.count, id: \.self) { i in
                        HStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(viewModel.accentColors[i])
                                .frame(width: 25, height: 25)
                            Text("\(viewModel.chartData[i].label)")
                                .font(.largeTitle)
                        }
                        .onTapGesture {
                            viewModel.selectedMood = viewModel.chartData[i].label
                            viewModel.showDetail.toggle()
                        }
                }
            }
            .padding()
            
            if let selectedMood = viewModel.selectedMood {
                NavigationLink("", isActive: $viewModel.showDetail) {
                    List {
                        JournalListView(moodEmoji: selectedMood)
                    }
                    .navigationTitle("Feeling \(selectedMood)")
                    .background(Color(UIColor.systemGray5))
                }
            }
            
            Spacer()
        }
        .navigationTitle("Mood Stats")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            viewModel.selectedMood = nil
            viewModel.getChartData()
        }
    }
}

struct MoodChartView_Previews: PreviewProvider {
    static var previews: some View {
        MoodChartView()
    }
}
