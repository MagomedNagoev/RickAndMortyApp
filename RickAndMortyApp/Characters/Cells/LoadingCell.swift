//
//  LoadingCell.swift
//  RickAndMortyApp
//
//  Created by Нагоев Магомед on 10.04.2021.
//
import UIKit
import PureLayout
class LoadingCell: UICollectionViewCell {
    static let identifier = "LoadingCell"

    private var loading: UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView()
        loading.tintColor = .gray
        loading.tag = -123456
        return loading
    }()

    private var charLabel: UILabel = {
        let charLabel = UILabel()
        charLabel.textAlignment = .center
        charLabel.text = "Loading..."
        return charLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(loading)
        loading.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0))

        addSubview(charLabel)
        charLabel.autoAlignAxis(toSuperviewAxis: .vertical)
        charLabel.autoPinEdge(.leading, to: .leading, of: loading, withOffset: 0)
        charLabel.autoPinEdge(.top, to: .bottom, of: loading, withOffset: 0)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set() {
        loading.startAnimating()
    }

}
