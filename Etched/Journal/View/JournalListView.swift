//
//  JournalListView.swift
//  Etched
//
//  Created by Yemi Gabriel on 12/26/21.
//

import SwiftUI
import Combine

struct JournalListView: View {
    @StateObject var viewModel = JournalListViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        ForEach(viewModel.journals, id: \.wrappedId) { journal in
            JournalCardView(journal: journal)
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button(role: .destructive) {
                        if let offset = viewModel.journals.firstIndex(where: {$0 == journal}) {
                            viewModel.selectedIndex = offset
                            viewModel.showDeleteAlert = true
                        }
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    .frame(width: 50, height: 50)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button {
                        viewModel.selectedJournal = journal
                        viewModel.showingEditView = true
                    } label: {
                        Label("Edit", systemImage: "square.and.pencil")
                    }
                }
                .background(
                    NavigationLink(destination: JournalDetailView(viewModel: DetailViewModel(journal: journal))){}.opacity(0)
                )
            
        }
        .onChange(of: viewModel.selectedJournal, perform: { _ in
            if viewModel.selectedJournal != nil && viewModel.showDetailView == true {
                //                viewModel.showingEditView = true
                print("go tot detail: ", viewModel.selectedJournal!.wrappedTimestamp.formattedShortDate())
                
            }
        })
        
        .sheet(isPresented: $viewModel.showingEditView, content: {
            if let selectedJournal = viewModel.selectedJournal {
                AddJournalView(viewModel: AddEditJournalViewModel(journalPublisher: Just(selectedJournal).eraseToAnyPublisher()))
                
            }
        })
        .alert("Are you sure you want to delete this journal?", isPresented: $viewModel.showDeleteAlert) {
            Button("Delete", role: .destructive) {
                viewModel.delete()
            }
        }
        
    }
    
    //    @ViewBuilder
    //    func buildNavigationLink(selectedJournal: JournalMO?, showDetail: Binding<Bool>) -> AnyView {
    //        if let selectedJournal = selectedJournal, showDetail.wrappedValue == true {
    //            return AnyView(JournalDetailView(viewModel: DetailViewModel(journal: selectedJournal)))
    //        } else {
    //            return AnyView(EmptyView())
    //        }
    //    }
    
}

struct JournalListView_Previews: PreviewProvider {
    static var previews: some View {
        JournalListView()
    }
}
