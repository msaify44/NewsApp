//
//  MediaDTO.swift
//  NewsApp
//
//  Created by Murtuza Saify on 20/11/2025.
//

import Foundation

enum MediaFormat: String, Decodable {
    case thumbnail = "Standard Thumbnail"
    case medium210 = "mediumThreeByTwo210"
    case medium440 = "mediumThreeByTwo440"
}

struct MediaDTO: Decodable {
    let metadata: [MediaMetadataDTO]
    
    enum CodingKeys: String, CodingKey {
        case metadata = "media-metadata"
    }
}

struct MediaMetadataDTO: Decodable {
    let url: String
    let format: MediaFormat
}
