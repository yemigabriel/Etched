//
//  PageModel.swift
//  Etched
//
//  Created by Yemi Gabriel on 12/26/21.
//

import Foundation
import SwiftUI

struct Page {
    let id: UUID
    let description: String
    let imageName: String
    let background: Color
    
    static let pages = [
        Page(id: UUID(), description: "Capture moments in your daily journal", imageName: "page-1", background: Color.green),
        Page(id: UUID(), description: "Secure your private thoughts", imageName: "page-2", background: Color.orange),
        Page(id: UUID(), description: "Sync with your iCloud so you share across multiple devices", imageName: "page-3", background: Color.purple),
    ]
}
