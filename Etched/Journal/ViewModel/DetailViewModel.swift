//
//  DetailViewModel.swift
//  Etched
//
//  Created by Yemi Gabriel on 1/9/22.
//

import Foundation

class DetailViewModel: ObservableObject {
    @Published var journal: JournalMO
    
    init(journal: JournalMO){
        self.journal = journal
    }
    
    
    
}
