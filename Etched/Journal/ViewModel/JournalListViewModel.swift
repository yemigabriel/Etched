//
//  JournalViewModel.swift
//  Etched
//
//  Created by Yemi Gabriel on 12/26/21.
//

import Foundation
import SwiftUI
import CoreData
import Combine

class JournalListViewModel: ObservableObject {
    
    @Published var journals = [JournalMO]()
    @State var selectedIndex = 0
    @State var showingEditView = false
    @State var isDetailView = true
    @State var showDeleteAlert = false
    @State var selectedJournal: JournalMO?
    
    private var cancellable: AnyCancellable?
    
    init(journalPublisher: AnyPublisher<[JournalMO], Never> =
         CoreDataHelper.shared.journals.eraseToAnyPublisher()) {
        cancellable = journalPublisher.sink(receiveValue: { journals in
            print("UPDATED JOURNAL COUNT: \(journals.count)")
            DispatchQueue.main.async {
                self.journals = journals
            }
        })
    }
    
    func filter(by filter: String) {
        
    }
    
    func delete() {
        CoreDataHelper.shared.delete(journal: journals[selectedIndex])
    }
    
}
