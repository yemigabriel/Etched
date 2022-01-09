//
//  JournalListView.swift
//  Etched
//
//  Created by Yemi Gabriel on 12/26/21.
//

import SwiftUI
import AVFoundation
import Combine

struct JournalListView: View {
    @StateObject var journalViewModel = JournalListViewModel()
    @State var selectedIndex = 0
    @State var showingEditView = false
    @State var selectedJournal: JournalMO?
    @State var isDetailView = true
    @State var showDeleteAlert = false
    
    var body: some View {
        NavigationView {
            List {
                //use enumerated to get index as well as the journal
                ForEach(journalViewModel.journals, id: \.wrappedId) { journal in
                    if journal.id != nil {
                        JournalCardView(journal: journal)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
//                            .onTapGesture {
//                                selectedJournal = journal
//                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    if let offset = journalViewModel.journals.firstIndex(where: {$0 == journal}) {
                                        selectedIndex = offset
                                        showDeleteAlert = true
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                .frame(width: 50, height: 50)
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button {
                                    selectedJournal = journal
                                } label: {
                                    Label("Edit", systemImage: "square.and.pencil")
                                }
                                .background(Color.clear)
                            }
                            .background(
                                NavigationLink(destination: JournalDetailView(viewModel: DetailViewModel(journal: journal))){}.opacity(0)
                            )
                    }
                }
                
            }
            
            .navigationTitle("Home")
            .onAppear {
                UITableView.appearance().backgroundColor = UIColor.clear
            }
            .background(Color(UIColor.systemGray5))
            .onChange(of: selectedJournal, perform: { _ in
                if selectedJournal != nil {
                    showingEditView = true
                }
            })
            .sheet(isPresented: $showingEditView, onDismiss: {
                selectedJournal = nil //reset to previous
            }, content: {
                if let selectedJournal = selectedJournal {
                    AddJournalView(viewModel: AddEditJournalViewModel(), selectedJournal: selectedJournal)
                }
            })
            .alert("Are you sure you want to delete this journal?", isPresented: $showDeleteAlert) {
                Button("Delete", role: .destructive) {
                    journalViewModel.delete(journal: journalViewModel.journals[selectedIndex])
                }
            }
            
        }
        
    }
    
}

struct JournalListView_Previews: PreviewProvider {
    static var previews: some View {
        JournalListView()
    }
}
