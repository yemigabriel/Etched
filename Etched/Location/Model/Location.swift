//
//  LocationModel.swift
//  Etched
//
//  Created by Yemi Gabriel on 1/12/22.
//

import Foundation

struct Location: Identifiable, Codable {
    var id: UUID?
    var name: String?
    var latitude: Double
    var longitude: Double
}
