//
//  FileManager+Extension.swift
//  Etched
//
//  Created by Yemi Gabriel on 1/8/22.
//

import Foundation

extension FileManager {
    
    static let ETCHED_IMAGES_FOLDER = "Journal/Photos"
    
    func getDocumentDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func getSavedImagesFolder() -> URL {
        let savedImagesFolder = getDocumentDirectory().appendingPathComponent(FileManager.ETCHED_IMAGES_FOLDER)
        if !FileManager.default.fileExists(atPath: savedImagesFolder.path) {
            do {
                try FileManager.default.createDirectory(at: savedImagesFolder, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
        return savedImagesFolder
    }
    
}
