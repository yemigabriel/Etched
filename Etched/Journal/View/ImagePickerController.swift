//
//  ImagePickerController.swift
//  Etched
//
//  Created by Yemi Gabriel on 1/10/22.
//

import Foundation
import SwiftUI

struct ImagePickerController: UIViewControllerRepresentable {
    
    @Binding var image: UIImage?
    @Binding var imageUrlPath: String?
    @Binding var isShown: Bool
    
    let sourceType: UIImagePickerController.SourceType
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePickerController
        
        init(_ parent: ImagePickerController) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
            guard let imageUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL  else { return }
            
            let savedImagesFolder = FileManager.default.getSavedImagesFolder()
            let savedImagePath = savedImagesFolder.appendingPathComponent("\(Date.fileNameByTimestamp()).jpg")
            
            do {
                try FileManager.default.copyItem(at: imageUrl, to: savedImagePath)
                parent.imageUrlPath = savedImagePath.lastPathComponent
                print(parent.imageUrlPath)
                parent.image = image
            } catch {
                print(error.localizedDescription)
            }
            
            parent.isShown = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isShown = false
        }
        
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            picker.sourceType = sourceType
        }
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
}
