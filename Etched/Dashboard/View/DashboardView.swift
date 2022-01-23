//
//  DashboardView.swift
//  Etched
//
//  Created by Yemi Gabriel on 1/15/22.
//

import SwiftUI

struct DashboardView: View {
    
    var columns = [
        GridItem(.adaptive(minimum: 150, maximum: 400))
    ]
    
    @State var showPlaces = false
    @State var showMoodStats = false
    @State var addNewJournal = false
    @State var showDetail = false
    @State private var selectedAction: DashboardAction = .addNewJournal
    
    var body: some View {
        
        NavigationView {
            ZStack {
                
                Circle()
                    .fill(.purple.opacity(0.5))
                    .frame(width: 400, height: 400)
                    .offset(x: -100, y: -400)
                
                List {
                    LazyVGrid(columns: columns) {
                        ForEach(DashboardCard.dashboardCards, id: \.title) { card in
                            
                                DashboardCardView(cardTitile: card.title,
                                                  cardImage: card.image,
                                                  cardSize: card.size)
                                .onTapGesture {
                                    selectedAction = card.action
                                    showDetail.toggle()
                                }
                        }
                        
                        NavigationLink(destination: destination(selectedAction), isActive: $showDetail) {}.isDetailLink(false).opacity(0)
                        


                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .padding(.horizontal, -10)
                    
                    Text("Recent Journals")
                        .font(.title)
                        .kerning(2.5)
                        .padding(.top, 20)
                        .listRowBackground(Color.clear)
                    
                    JournalListView()
                    
                }
                .onAppear {
                    UITableView.appearance().backgroundColor = UIColor.clear
                }
                
            }
            .navigationTitle("Etched")
            .background(Color(UIColor.systemGray5))
        }
    }
    
    @ViewBuilder
    func destination(_ action: DashboardAction) -> some View {
        switch action {
        case .showPlaces:
            PlacesView()
        case .showMood:
            Text("Show Mood")
        default:
            Text("Add Journal")
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
