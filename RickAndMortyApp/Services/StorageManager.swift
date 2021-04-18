//
//  StorageManager.swift
//  RickAndMortyApp
//
//  Created by Нагоев Магомед on 13.04.2021.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    static func saveObject(charName: String, image: UIImage, id: Int ) {
        let chars = realm.objects(FavoriteCharacters.self)
        for char in chars {
            if char.charId == id {
                return
            }
        }
        let char = FavoriteCharacters()
        char.name = charName
        char.charId = id
        char.imageData = image.pngData()
        try! realm.write {
            realm.add(char)
        }
    }

    static func deleteObject(id: Int) {
        let chars = realm.objects(FavoriteCharacters.self)
        for char in chars {
            if char.charId == id {
                try! realm.write {
                    realm.delete(char)
                }
            }
        }

    }
}
