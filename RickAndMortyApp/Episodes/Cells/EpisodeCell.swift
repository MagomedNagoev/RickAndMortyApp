//
//  EpisodeCell.swift
//  RickAndMortyApp
//
//  Created by Нагоев Магомед on 10.04.2021.
//

import UIKit
import PureLayout

class EpisodeCell: UITableViewCell {

    static let identifier = "EpisodeCell"

    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .black
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.numberOfLines = 2

        return titleLabel
    }()

    private let episodeImage: UIImageView = {
        let folderImage = UIImageView()
        let configuration = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold, scale: .large)
        folderImage.image = UIImage(systemName: "play.rectangle", withConfiguration: configuration)

        return folderImage
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear

        addSubview(episodeImage)
        episodeImage.autoAlignAxis(toSuperviewAxis: .horizontal)
        episodeImage.autoPinEdge(toSuperviewEdge: .leading, withInset: 15)

        addSubview(titleLabel)
        titleLabel.autoAlignAxis(toSuperviewAxis: .horizontal)
        titleLabel.autoPinEdge(.left, to: .right, of: episodeImage, withOffset: 15)
        titleLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: 0)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(title: String) {
        titleLabel.text = title
    }
}
