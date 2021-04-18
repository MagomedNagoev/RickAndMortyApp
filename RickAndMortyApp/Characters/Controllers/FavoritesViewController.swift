//
//  FavoritesViewContriller.swift
//  RickAndMortyApp
//
//  Created by Нагоев Магомед on 13.04.2021.
//

protocol FavoriteDelegate {
    func reloadCollectionFavoretes()
}

import UIKit
import RealmSwift

class FavoritesViewController: UIViewController {
    private var collectionView: UICollectionView!

    private var favoriteCharacters: Results<FavoriteCharacters>!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        favoriteCharacters = realm.objects(FavoriteCharacters.self)
        print(favoriteCharacters.count)

    }

    func configureUI() {
        view.backgroundColor = .white
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear

        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.register(CharacterCell.self, forCellWithReuseIdentifier: CharacterCell.identifier)

        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        collectionView.autoPinEdge(toSuperviewSafeArea: .top)
        collectionView.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
        collectionView.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
        collectionView.autoPinEdge(toSuperviewSafeArea: .bottom)
    }

    func reloadData() {
        collectionView.reloadData()
    }

}

extension FavoritesViewController: FavoriteDelegate {
    func reloadCollectionFavoretes() {
        print("delegate")
        collectionView.reloadData()
    }

}
// MARK: - UICollectionView
extension FavoritesViewController: UICollectionViewDelegate,
                                   UICollectionViewDataSource,
                                   UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteCharacters.isEmpty ? 0 : favoriteCharacters.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let charCell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCell.identifier,
                                                          for: indexPath) as? CharacterCell
        guard let cell = charCell else {
            return UICollectionViewCell()
        }
        let favchar = favoriteCharacters[indexPath.item]
        
        cell.set(title: favchar.name!, id: favchar.charId, favoriteCharacter: true, urlString: "")
        cell.image.image = UIImage(data: favchar.imageData!)
        cell.favButton.isHidden = false
        
        let configuration = UIImage.SymbolConfiguration(pointSize: 20, weight: .light, scale: .large)
        let image = UIImage(systemName: "star.fill", withConfiguration: configuration)?.withTintColor(.yellow, renderingMode: .alwaysOriginal)
        
        cell.favButton.setImage(image, for: .normal)
        cell.favButton.addTarget(cell, action: #selector(cell.deleteFavChar), for: .touchUpInside)
        cell.favoriteDelegate = self
        cell.designMyCell()
        return cell

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.size.width - 10) / 2
        return CGSize(width: size, height: size)
    }

}
