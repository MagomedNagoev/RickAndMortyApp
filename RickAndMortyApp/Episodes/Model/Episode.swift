//
//  Episode.swift
//  RickAndMortyApp
//
//  Created by Нагоев Магомед on 10.04.2021.
//

import Foundation

struct EpisodeInfoModel: Decodable, Hashable {
    let info: EpisodeInfo
}
struct EpisodeInfo: Decodable, Hashable {
    let count: Int?
    let next: String?
    let pages: Int?
    let prev: String?
}

struct Episode: Decodable, Hashable {
    let id: Int?
    let name: String?
    let episode: String?
    let characters: [String]?
}
