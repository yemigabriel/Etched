//
//  JournalListView.swift
//  Etched
//
//  Created by Yemi Gabriel on 12/26/21.
//

import SwiftUI

struct JournalListView: View {
    @ObservedObject var journalViewModel = JournalViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(journalViewModel.journals, id: \.id) { journal in
                    JournalCardView(journal: journal)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                }
                
            }
            .navigationTitle("Home")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button{
                        journalViewModel.addSampleJournals()
                    } label: {
                        Label("Add", systemImage: "plus")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button{
                        journalViewModel.deleteAll()
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
            .onAppear {
                UITableView.appearance().backgroundColor = UIColor.clear
            }
            .background(Color(UIColor.systemGray5))
        }
        
    }
    
}

struct JournalListView_Previews: PreviewProvider {
    static var previews: some View {
        JournalListView()
    }
}
