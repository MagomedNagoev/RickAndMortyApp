//
//  ViewController.swift
//  RickAndMortyApp
//
//  Created by Нагоев Магомед on 09.04.2021.
//

import UIKit
import PureLayout

class CharactersViewController: UIViewController {
    private var collectionView: UICollectionView!
    private var characterInfo: CharacterInfoModel?
    private var characters = [Character]()
    private var characterNumber: Int = 0
    private var countCharacters: Int = 0
    private var urls = [String]()

    init(urls: [String], title: String) {
        self.urls = urls
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        getInfo(url: "https://rickandmortyapi.com/api/character")
        NetworkManager.getRequest(url: "https://rickandmortyapi.com/api/character/?name=jerry")
    }

    func getInfo(url: String) {
        NetworkManager.fetchData(url: url, model: characterInfo) { [weak self](charInfo1) in
            guard let count = charInfo1?.info.count else {return}
            self?.countCharacters = count
            self?.getUrls()
            self?.getChars(times: 10)
        }

    }

    func getCharsFromUrls(urls: [String]) -> String {
        var numChars = [Int]()
        var newUrl = "https://rickandmortyapi.com/api/character/"
        for url in urls {
            let index = url.lastIndex(of: "/")

            if let index = index {
                let numChar = url[url.index(after: index)...]
                numChars.append(Int(numChar) ?? 0)
                newUrl += "\(numChar),"
            }

        }
        return newUrl
    }

    func getUrls() {
        if urls.isEmpty {
            let url = "https://rickandmortyapi.com/api/character/"
            for numChar in 1...countCharacters {
                let newUrl = url + "\(numChar)"
                urls.append(newUrl)
            }
        } else {
            print("Не пустой")
            countCharacters = urls.count
        }
    }
    func getChars(times: Int) {
        var newUrl = ""
        if times < urls.count - characterNumber {
            let newUrls = Array(urls[characterNumber...characterNumber+times-1])
            characterNumber += times
            newUrl = getCharsFromUrls(urls: newUrls)
        } else {
            let newUrls = Array(urls[characterNumber...urls.count - 1])
            newUrl = getCharsFromUrls(urls: newUrls)
            characterNumber += urls.count
        }

        NetworkManager.fetchData(url: newUrl, model: characters) {[weak self] (chars) in
            self?.characters += chars
            DispatchQueue.main.async {
                self?.collectionViewReloadData()
            }
        }
    }

    func collectionViewReloadData() {
        collectionView.performBatchUpdates(nil, completion: nil)
        collectionView.reloadData()

    }

    func configureUI() {

        view.backgroundColor = .white
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        

        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.register(CharacterCell.self, forCellWithReuseIdentifier: CharacterCell.identifier)
        collectionView.register(LoadingCell.self, forCellWithReuseIdentifier: LoadingCell.identifier)

        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        collectionView.autoPinEdge(toSuperviewSafeArea: .top)
        collectionView.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
        collectionView.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
        collectionView.autoPinEdge(toSuperviewSafeArea: .bottom)

    }

}
// MARK: - UICollectionView
extension CharactersViewController: UICollectionViewDelegate,
                                    UICollectionViewDataSource,
                                    UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        characters.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let character = characters[indexPath.item]

        if characterNumber < countCharacters && indexPath.row == characters.count - 1 {
            let cellEpisode = collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCell.identifier,
                                                                 for: indexPath) as? LoadingCell
            guard let cell = cellEpisode else {
                return UICollectionViewCell()
            }
            cell.set()
            cell.designMyCell()
            return cell
        } else {
            let charCell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCell.identifier,
                                                              for: indexPath) as? CharacterCell
            guard let cell = charCell else {
                return UICollectionViewCell()
            }

            guard let name = character.name, let id = character.id, let urlString = character.image else {
                return UICollectionViewCell()
            }
            cell.set(title: name, id: id, favoriteCharacter: false, urlString: urlString)
            cell.downloadedImage()
            cell.designMyCell()
            return cell

        }

    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.size.width - 10) / 2
        return CGSize(width: size, height: size)
    }

    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if characterNumber < countCharacters && indexPath.row == characters.count - 1 {

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.getChars(times: 10)
            }

        }
    }

}
