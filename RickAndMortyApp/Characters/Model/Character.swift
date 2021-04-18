//
//  Model.swift
//  RickAndMortyApp
//
//  Created by Нагоев Магомед on 09.04.2021.
//
import RealmSwift
import Foundation

struct CharacterInfoModel: Decodable, Hashable {
    var results: [Character]?
    let info: CharacterInfo
}
struct CharacterInfo: Decodable, Hashable {
    let count: Int?
    let next: String?
    let pages: Int?
    let prev: String?
}

struct Character: Decodable, Hashable {
    let id: Int?
    let name: String?
    let episodes: [String]?
    let image: String?
    let url: String?
    var isCharFavorite: Bool?
}

class FavoriteCharacters: Object {

    @objc dynamic var name: String?
    @objc dynamic var imageData: Data?
    @objc dynamic var charId = 0

    convenience init (name: String?, imageData: Data?, charId: Int) {
        self.init()
        self.name = name
        self.imageData = imageData
        self.charId = charId
    }
}
