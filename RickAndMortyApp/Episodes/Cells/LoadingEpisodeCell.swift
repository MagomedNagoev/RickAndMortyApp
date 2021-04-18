//
//  LoadingCell.swift
//  RickAndMortyApp
//
//  Created by Нагоев Магомед on 17.04.2021.
//

import UIKit
import PureLayout

class LoadingEpisodeCell: UITableViewCell {

    static let identifier = "LoadingCell"

    private var loading: UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView()
        loading.tintColor = .gray
        loading.tag = -123456
        return loading
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: LoadingEpisodeCell.identifier)
        addSubview(loading)
        loading.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0))

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func startAnimating() {
        loading.startAnimating()
    }
}
