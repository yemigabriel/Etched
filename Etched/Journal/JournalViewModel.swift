//
//  JournalViewModel.swift
//  Etched
//
//  Created by Yemi Gabriel on 12/26/21.
//

import Foundation
import SwiftUI

class JournalViewModel: ObservableObject {
    
    @Published var journals = [Journal]()
    private var managedObjectContext = CoreDataHelper.shared.container.viewContext
    
//    @FetchRequest var journalMOs: FetchedResults<JournalMO>
    
    init() {
//        _journalMOs = FetchRequest(sortDescriptors: [], predicate: nil)
        getJournals()
    }
    
    func getJournals() {
//        var journals: [Journal] = []
        journals.removeAll()
        do {
            let journalMOs = try managedObjectContext.fetch(JournalMO.fetchRequest())
            for journalMO in journalMOs {
                let journal = Journal(id: journalMO.wrappedId, content: journalMO.wrappedContent, timestamp: journalMO.wrappedTimestamp, images: journalMO.wrappedImages, audio: journalMO.wrappedAudio, video: journalMO.wrappedVideo, location: journalMO.wrappedLocation, mood: journalMO.wrappedMood)
                self.journals.append(journal)
            }
        } catch {
            print("Fetch Error: \(error.localizedDescription)")
        }
    }
    
    func filter(by filter: String) {
        
    }
    
    func add(journal: Journal) {
        
    }
    
    func addSampleJournals() {
        
        for sampleJournal in Journal.sampleJournals {
            let journalMO = JournalMO(context: managedObjectContext)
            journalMO.id = sampleJournal.id
            journalMO.content = sampleJournal.content
            journalMO.timestamp = sampleJournal.timestamp
            journalMO.images = sampleJournal.images?.joined(separator: ",") ?? nil
            journalMO.audio = sampleJournal.audio
            journalMO.video = sampleJournal.video
            if let sampleJournalLocation = sampleJournal.location {
                journalMO.location = LocationMO(context: managedObjectContext)
                journalMO.location?.id =  sampleJournalLocation.id
                journalMO.location?.name =  sampleJournalLocation.name
                journalMO.location?.latitude =  sampleJournalLocation.latitude ?? 0
                journalMO.location?.longitude =  sampleJournalLocation.longitude ?? 0
            }
            
            if let sampleJournalMood = sampleJournal.mood {
                journalMO.mood = MoodMO(context: managedObjectContext)
                journalMO.mood?.id = sampleJournalMood.id
                journalMO.mood?.name = sampleJournalMood.name
                journalMO.mood?.emoji = sampleJournalMood.emoji
            }
        }
        do {
            try managedObjectContext.save()
            getJournals()
        } catch {
            print(error)
            print("Error saving MOC: \(error.localizedDescription)")
        }
    }
    
    func edit(journal: Journal) {
        
    }
    
    func delete(journal: Journal) {
        
    }
    
    func deleteAll() {
        if let journalMOs = try? managedObjectContext.fetch(JournalMO.fetchRequest()) {
            for mo in journalMOs {
                managedObjectContext.delete(mo)
            }
            try? managedObjectContext.save()
        }
        getJournals()
    }
    
}
