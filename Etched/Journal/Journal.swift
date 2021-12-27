//
//  Journal.swift
//  Etched
//
//  Created by Yemi Gabriel on 12/26/21.
//

import Foundation

struct Journal: Identifiable, Codable {
    let id: UUID
    var content: String
    let timestamp: Date
    var images: [String]?
    var audio: String?
    var video: String?
    var location: Location?
    var mood: Mood?
    
    var formattedDate: String {
        var formattedDate = "Unknown"
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        formattedDate = dateFormatter.string(from: timestamp)
        return formattedDate
    }
    
    // samples
    static let location0 = Location(id: UUID(), name: "Earth", latitude: 0, longitude: 0)
    static let location1 = Location(id: UUID(), name: "Minastirith", latitude: 0.403033, longitude: 5.494329)
    static let mood0 = Mood(id: UUID(), name: "Happy", emoji: "😃")
    static let mood1 = Mood(id: UUID(), name: "Disgusted", emoji: "🤮")
    static let mood2 = Mood(id: UUID(), name: "Crush", emoji: "😍")
    
    static let sampleJournals = [
        Journal(id: UUID(), content: "Sample Journal One Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Dictumst quisque sagittis purus sit amet volutpat consequat mauris nunc. Etiam tempor orci eu lobortis. Erat nam at lectus urna. Purus ut faucibus pulvinar elementum. Ipsum nunc aliquet bibendum enim facilisis gravida. Est lorem ipsum dolor sit amet consectetur adipiscing.", timestamp: Date(), images: ["hey-firl"], audio: nil, video: nil, location: location0, mood: nil),
        Journal(id: UUID(), content: "You want to bam ba Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Dictumst quisque sagittis purus sit amet volutpat consequat mauris nunc. Etiam tempor orci eu lobortis. Erat nam at lectus urna. Purus ut faucibus pulvinar elementum. Ipsum nunc aliquet bibendum enim facilisis gravida. Est lorem ipsum dolor sit amet consectetur adipiscing.", timestamp: Date(), images: ["dorime"], audio: nil, video: nil, location: nil, mood: nil),
        Journal(id: UUID(), content: "Put your head on my shoulders Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Dictumst quisque sagittis purus sit amet volutpat consequat mauris nunc. Etiam tempor orci eu lobortis. Erat nam at lectus urna. Purus ut faucibus pulvinar elementum. Ipsum nunc aliquet bibendum enim facilisis gravida. Est lorem ipsum dolor sit amet consectetur adipiscing.", timestamp: Date(), images: ["tiktok"], audio: nil, video: nil, location: nil, mood: mood2),
        Journal(id: UUID(), content: "Oh the places you'll go Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Dictumst quisque sagittis purus sit amet volutpat consequat mauris nunc. Etiam tempor orci eu lobortis. Erat nam at lectus urna. Purus ut faucibus pulvinar elementum. Ipsum nunc aliquet bibendum enim facilisis gravida. Est lorem ipsum dolor sit amet consectetur adipiscing.", timestamp: Date(), images: ["dr-seuss"], audio: nil, video: nil, location: location1, mood: mood0),
        Journal(id: UUID(), content: "Looking good in Di'or \nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Dictumst quisque sagittis purus sit amet volutpat consequat mauris nunc. Etiam tempor orci eu lobortis. Erat nam at lectus urna. Purus ut faucibus pulvinar elementum. Ipsum nunc aliquet bibendum enim facilisis gravida. Est lorem ipsum dolor sit amet consectetur adipiscing.", timestamp: Date(), images: nil, audio: nil, video: nil, location: location1, mood: mood1),
    ]
}

struct Location: Identifiable, Codable {
    var id: UUID?
    var name: String?
    var latitude: Double?
    var longitude: Double?
}

struct Mood: Identifiable, Codable {
    var id: UUID?
    var name: String?
    var emoji: String?
}
