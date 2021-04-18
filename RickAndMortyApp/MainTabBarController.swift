//
//  MainTabBarController.swift
//  RickAndMortyApp
//
//  Created by Нагоев Магомед on 09.04.2021.
//

import UIKit

class MainTabBarController: UITabBarController {
    private var splashView = SplashView()
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTabBar()
        configureViewControllers()
    }
        override func viewDidAppear(_ animated: Bool) {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                self.splashView.scaleDownAnimation()
            }
        }
    func configureTabBar() {
        view.addSubview(splashView)
        splashView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        tabBar.isTranslucent = false
    }

    func configureViewControllers() {
        let charactersViewController  = CharactersViewController(urls: [String](), title: "All characters")
        let charNav = templateNavigationController(image: UIImage(systemName: "person.3")!,
                                                    tabBarItemTitle: "All characters",
                                                    rootViewController: charactersViewController)

        let episodesViewController = EpisodesViewController()
        let epNav = templateNavigationController(image: UIImage(systemName: "play.rectangle")!,
                                                       tabBarItemTitle: "All episodes",
                                                       rootViewController: episodesViewController)
        let searchViewController = SegmentViewController()
        let searchNav = templateNavigationController(image: UIImage(systemName: "magnifyingglass")!,
                                                       tabBarItemTitle: "Search character",
                                                       rootViewController: searchViewController)

        viewControllers = [charNav,
                           epNav,
                           searchNav]
    }

    func templateNavigationController(image: UIImage,
                                      tabBarItemTitle: String,
                                      rootViewController: UIViewController) -> UINavigationController {
        let navCtrl = UINavigationController(rootViewController: rootViewController)
        navCtrl.tabBarItem.image = image
        navCtrl.navigationBar.barTintColor = .white
        navCtrl.tabBarItem.title = tabBarItemTitle
        navCtrl.navigationBar.prefersLargeTitles = true
        return navCtrl
    }

}
