//
//  SearchViewController.swift
//  RickAndMortyApp
//
//  Created by Нагоев Магомед on 09.04.2021.
//
import UIKit
import RealmSwift

class SearchViewController: UIViewController {
    private var collectionView: UICollectionView!
    private var episodesInfo: CharacterInfoModel?
    private var characters = [Character]()
    private var favoriteCharacters: Results<FavoriteCharacters>!

    private var url = "https://rickandmortyapi.com/api/character/?name="
    private let searchBar = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        hideKeyboardOnTap()
        favoriteCharacters = realm.objects(FavoriteCharacters.self)
    }
    func containsFavoriteCharacter(id: Int) -> Bool {
        var characterFavorite: Bool = false
        for character in favoriteCharacters {
            if character.charId == id {
                characterFavorite = true
                break
            } else {
                characterFavorite = false
                continue
            }
        }
        return characterFavorite
    }
    func configureUI() {

        view.backgroundColor = .white
        searchBar.delegate = self

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .white

        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.register(CharacterCell.self, forCellWithReuseIdentifier: CharacterCell.identifier)
        collectionView.register(LoadingCell.self, forCellWithReuseIdentifier: LoadingCell.identifier)

        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(searchBar)
        searchBar.autoPinEdge(toSuperviewSafeArea: .top)
        searchBar.autoPinEdge(toSuperviewSafeArea: .left)
        searchBar.autoPinEdge(toSuperviewSafeArea: .right)
        
        view.addSubview(collectionView)
        collectionView.autoPinEdge(.top, to: .bottom, of: searchBar, withOffset: -1)
        collectionView.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
        collectionView.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
        collectionView.autoPinEdge(toSuperviewSafeArea: .bottom)
    }

    func reloadData() {
        collectionView.reloadData()
        collectionView.performBatchUpdates(nil, completion: nil)
    }

}
// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {

    func getData (with searchText: String?) {
        if let text = searchText {
            let newUrl = self.url + text
            NetworkManager.fetchData(url: newUrl, model: self.episodesInfo) { [weak self](characters) in
                guard let results = characters?.results else {return}
                self?.characters = results
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self?.collectionView.reloadData()

                }
            }
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        getData(with: searchText)
    }
}
// MARK: - UICollectionView
extension SearchViewController: UICollectionViewDelegate,
                                UICollectionViewDataSource,
                                UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        characters.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let char = characters[indexPath.item]

        let charCell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCell.identifier,
                                                          for: indexPath) as? CharacterCell
        guard let cell = charCell else {
            return UICollectionViewCell()
        }
        guard let name = char.name, let id = char.id, let urlString = char.image else {
            return UICollectionViewCell()
        }

        cell.set(title: name, id: id, favoriteCharacter: containsFavoriteCharacter(id: id), urlString: urlString)
        cell.downloadedImage()
        cell.favButton.isHidden = false
        cell.designMyCell()
        cell.favoriteDelegate = self

        if cell.favoriteCharacter == true {
            let configuration = UIImage.SymbolConfiguration(pointSize: 20, weight: .light, scale: .large)
            let image = UIImage(systemName: "star.fill", withConfiguration: configuration)?.withTintColor(.yellow, renderingMode: .alwaysOriginal)
            cell.favButton.setImage(image, for: .normal)
            cell.favButton.addTarget(cell, action: #selector(cell.deleteFavChar), for: .touchUpInside)
        } else {
            let configuration = UIImage.SymbolConfiguration(pointSize: 20, weight: .light, scale: .large)
            let image = UIImage(systemName: "star", withConfiguration: configuration)?.withTintColor(.yellow, renderingMode: .alwaysOriginal)
            cell.favButton.setImage(image, for: .normal)
            cell.favButton.addTarget(cell, action: #selector(cell.addFavChar), for: .touchUpInside)

        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.size.width - 10) / 2
        return CGSize(width: size, height: size)
    }

}

extension SearchViewController: FavoriteDelegate {
    func reloadCollectionFavoretes() {
        collectionView.reloadData()
    }

    func hideKeyboardOnTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(SearchViewController.dismissKeyboard))

        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
