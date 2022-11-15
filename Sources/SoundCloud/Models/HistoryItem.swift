//
//  HistoryItem.swift
//  Nuage
//
//  Created by Laurin Brandner on 10.11.20.
//  Copyright © 2020 Laurin Brandner. All rights reserved.
//

import Foundation

public struct HistoryItem: SoundCloudIdentifiable, Decodable {
    
    public var id: String {
        return track.id
    }
    
    public var date: Date
    public var track: Track

    enum CodingKeys: String, CodingKey {
        case date = "played_at"
        case track
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let timestamp = try container.decode(Double.self, forKey: .date)
        date = Date(timeIntervalSince1970: timestamp)
        track = try container.decode(Track.self, forKey: .track)
    }
    
}
