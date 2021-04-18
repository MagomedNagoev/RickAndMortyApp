//
//  CharacterCell.swift
//  RickAndMortyApp
//
//  Created by Нагоев Магомед on 09.04.2021.
//

import UIKit
import PureLayout
import Kingfisher
class CharacterCell: UICollectionViewCell {
    var favoriteDelegate: FavoriteDelegate?
    static let identifier = "CharacterCell"
    private var id = 0
    var favoriteCharacter: Bool = false
    private var urlImage: URL?
    var image: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "network")

        return image
    }()
    var favButton: UIButton = {
        let favButton = UIButton()
        favButton.isHidden = true
        return favButton
    }()

    private var darkenImage: UIImageView = {
        let darkenImage = UIImageView()
        darkenImage.backgroundColor = .black
        darkenImage.layer.opacity = 0.15
        return darkenImage
    }()
    private var charLabel: UILabel = {
        let charLabel = UILabel()
        //        charLabel.textAlignment = .center
        charLabel.numberOfLines = 2
        charLabel.textColor = .white
        charLabel.textAlignment = .center
        charLabel.font = UIFont(name: "Helvetica-Bold", size: 15)

        return charLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(image)
        image.autoPinEdgesToSuperviewSafeArea()
        addSubview(darkenImage)
        darkenImage.autoPinEdgesToSuperviewSafeArea()
        addSubview(charLabel)
        charLabel.autoAlignAxis(toSuperviewAxis: .vertical)
        charLabel.autoPinEdge(.leading, to: .leading, of: image, withOffset: 0)
        charLabel.autoPinEdge(.top, to: .bottom, of: image, withOffset: -35)
        charLabel.autoPinEdge(.bottom, to: .bottom, of: image, withOffset: 0)
        addSubview(favButton)
        favButton.autoPinEdge(.trailing, to: .trailing, of: image, withOffset: -5)
        favButton.autoPinEdge(.top, to: .top, of: image, withOffset: 0)
        favButton.autoSetDimensions(to: CGSize(width: 30, height: 30))

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(title: String, id: Int, favoriteCharacter: Bool, urlString: String) {
        charLabel.text = title
        self.id = id
        self.favoriteCharacter = favoriteCharacter
        guard let url = URL(string: urlString) else { return }
        self.urlImage = url
    }

    func downloadedImage() {
        image.kf.setImage(with: urlImage)
    }

    @objc func addFavChar() {
        print("Постер в фаворите\(id)")
        StorageManager.saveObject(charName: charLabel.text!, image: image.image!, id: id)
        favoriteDelegate?.reloadCollectionFavoretes()
        favoriteCharacter = true
    }
    @objc func deleteFavChar() {
        print("Удалить\(id)")
        StorageManager.deleteObject(id: id)
        favoriteDelegate?.reloadCollectionFavoretes()
        favoriteCharacter = false
    }

}
