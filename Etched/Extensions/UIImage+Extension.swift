//
//  UIImage+Extension.swift
//  Etched
//
//  Created by Yemi Gabriel on 1/9/22.
//

import Foundation
import UIKit

extension UIImage {
    
    static func loadFirst(from paths: [String]) -> UIImage? {
        guard let imagePath = paths.first else { return nil }
        guard let uiImage = UIImage(contentsOfFile:imagePath) else { return nil }
        return uiImage
    }
}
