//
//  DetailViewModel.swift
//  Etched
//
//  Created by Yemi Gabriel on 1/9/22.
//

import SwiftUI

class DetailViewModel: ObservableObject {
    @Published var journal: JournalMO
    
    init(journal: JournalMO){
        self.journal = journal
    }
    
    func delete() {
        CoreDataHelper.shared.delete(journal: journal)
    }
    
    
}
