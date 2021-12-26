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
        Page(id: UUID(), description: "Write daily journal", imageName: "page-1", background: .indigo),
        Page(id: UUID(), description: "Lock securely", imageName: "page-2", background: .orange),
        Page(id: UUID(), description: "Backup so you never lose anything", imageName: "page-3", background: .purple),
    ]
}
