//
//  SegmentViewController.swift
//  RickAndMortyApp
//
//  Created by Нагоев Магомед on 13.04.2021.
//

import UIKit
import PureLayout

class SegmentViewController: UIViewController {
    private let searchViewController = SearchViewController()
    private let favouritesViewController = FavoritesViewController()

    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Search", "Favorites"])
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(onSegmentControlChange), for: .valueChanged)

        return control
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.titleView = segmentedControl
        navigationItem.titleView?.autoPinEdge(toSuperviewEdge: .left)
        navigationItem.titleView?.autoPinEdge(toSuperviewEdge: .right)

        segmentedControl.setWidth(view.frame.width/2, forSegmentAt: 0)
        segmentedControl.setWidth(view.frame.width/2, forSegmentAt: 1)

        view.addSubview(searchViewController.view)
        searchViewController.view.autoPinEdgesToSuperviewSafeArea()
    }

    @objc func onSegmentControlChange() {
        if segmentedControl.selectedSegmentIndex == 0 {
            favouritesViewController.view.removeFromSuperview()
            view.addSubview(searchViewController.view)
            searchViewController.view.autoPinEdgesToSuperviewSafeArea()
            searchViewController.reloadData()
        } else {
            searchViewController.view.removeFromSuperview()
            view.addSubview(favouritesViewController.view)
            favouritesViewController.view.autoPinEdgesToSuperviewSafeArea()
            favouritesViewController.reloadData()
        }
    }
}
