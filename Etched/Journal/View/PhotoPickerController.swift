//
//  ImagePickerController.swift
//  Etched
//
//  Created by Yemi Gabriel on 1/6/22.
//

import SwiftUI
import PhotosUI

struct PhotoPickerController: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var imagePath: String?
    
    init(image: Binding<UIImage?>, imagePath: Binding<String?>) {
        _image = image
        _imagePath = imagePath
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        
        var parent: PhotoPickerController
        
        init(_ parent: PhotoPickerController) {
            self.parent = parent
        }
        
        
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true, completion: nil)
            
            guard let provider = results.first?.itemProvider else { return }
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, error in
                    guard let image = image as? UIImage else { return }
                    guard let data = image.jpegData(compressionQuality: 0.8) else { return }
                    
                    let savedImagesFolder = FileManager.default.getSavedImagesFolder()
                    let imagePath = savedImagesFolder.appendingPathComponent("\(Date.fileNameByTimestamp()).jpg")
                    
                    do {
                        try data.write(to: imagePath, options: .completeFileProtection)
                        self.parent.imagePath = imagePath.lastPathComponent
                        print(imagePath)
//                        DispatchQueue.main.async { [weak self] in
                            self.parent.image = image
                            print(imagePath.pathComponents)
//                            self?.parent._imagePath.wrappedValue = "\(imagePath.lastPathComponent).jpg"
//                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                }
            }
            
//            if let imgUrl = info[UIImagePickerControllerImageURL] as? URL{
//                   let imgName = imgUrl.lastPathComponent
//                   let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
//                   let localPath = documentDirectory?.appending(imgName)
//
//                   let image = info[UIImagePickerControllerOriginalImage] as! UIImage
//                   let data = UIImagePNGRepresentation(image)! as NSData
//                   data.write(toFile: localPath!, atomically: true)
//                   //let imageData = NSData(contentsOfFile: localPath!)!
//                   let photoURL = URL.init(fileURLWithPath: localPath!)//NSURL(fileURLWithPath: localPath!)
//                   print(photoURL)
//
//               }
//
//            let imageURL = info[UIImagePickerControllerReferenceURL] as NSURL
//                let imageName = imageURL.path!.lastPathComponent
//                let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first as String
//                let localPath = documentDirectory.stringByAppendingPathComponent(imageName)
//
//                let image = info[UIImagePickerControllerOriginalImage] as UIImage
//                let data = UIImagePNGRepresentation(image)
//                data.writeToFile(localPath, atomically: true)
//
//                let imageData = NSData(contentsOfFile: localPath)!
//                let photoURL = NSURL(fileURLWithPath: localPath)
//                let imageWithData = UIImage(data: imageData)!

        }
        
    }
    
//    func makeUIViewController(context: Context) -> PHPickerViewController {
//        var config = PHPickerConfiguration()
//        config.filter = .images
//
//        let picker = PHPickerViewController(configuration: config)
//        picker.delegate = context.coordinator
//        return picker
//    }
//
//    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
//
//    }
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    
}
