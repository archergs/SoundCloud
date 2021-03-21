//
//  Post.swift
//  Nuage
//
//  Created by Laurin Brandner on 10.11.20.
//  Copyright © 2020 Laurin Brandner. All rights reserved.
//

import Foundation

public class Post: SoundCloudIdentifiable, Decodable {
    
    public enum Kind {
        case track(Track)
        case trackRepost(Track)
        case playlist(UserPlaylist)
        case playlistRepost(UserPlaylist)
    }
    
    public enum Item {
        case track(Track)
        case playlist(UserPlaylist)
    }
    
    public var id: String
    public var date: Date
    public var caption: String?
    
    public var kind: Kind
    public var user: User
    
    public var isRepost: Bool {
        switch kind {
        case .trackRepost(_): return true
        case .playlistRepost(_): return true
        default: return false
        }
    }
    
    public var isTrack: Bool {
        switch kind {
        case .track(_): return true
        case .trackRepost(_): return true
        default: return false
        }
    }
    
    public var tracks: [Track] {
        switch kind {
        case .track(let track): return [track]
        case .trackRepost(let track): return [track]
        case .playlist(let playlist): fallthrough
        case .playlistRepost(let playlist): return playlist.tracks ?? []
        }
    }
    
    public var item: Item {
        switch kind {
        case .track(let track): return .track(track)
        case .trackRepost(let track): return .track(track)
        case .playlist(let playlist): return .playlist(playlist)
        case .playlistRepost(let playlist): return .playlist(playlist)
        }
    }
    
    
    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case date = "created_at"
        case caption
        case type
        case track
        case playlist
        case user
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        date = try container.decode(Date.self, forKey: .date)
        caption = try container.decodeIfPresent(String.self, forKey:.caption)
        
        user = try container.decode(User.self, forKey: .user)
        let type = try container.decode(String.self, forKey: .type)
        switch type {
        case "track":
            let track = try container.decode(Track.self, forKey: .track)
            kind = .track(track)
        case "track-repost":
            let track = try container.decode(Track.self, forKey: .track)
            kind = .trackRepost(track)
        case "playlist":
            let playlist = try container.decode(UserPlaylist.self, forKey: .playlist)
            kind = .playlist(playlist)
        case "playlist-repost":
            let playlist = try container.decode(UserPlaylist.self, forKey: .playlist)
            kind = .playlistRepost(playlist)
        default:
            throw UndefinedPostTypeError(type: type)
        }
    }
    
}

public struct UndefinedPostTypeError: Error {
    
    public var type: String
    
}
