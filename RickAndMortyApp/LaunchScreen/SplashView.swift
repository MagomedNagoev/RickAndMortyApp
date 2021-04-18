//
//  SplashViewController.swift
//  RickAndMortyApp
//
//  Created by Нагоев Магомед on 16.04.2021.
//

import UIKit
import PureLayout

class SplashView: UIView {

    private let rickAndMortyImage = UIImageView(image: UIImage(named: "rick-and-morty")!)
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        rickAndMortyImage.contentMode = .scaleAspectFit
        addSubview(rickAndMortyImage)
        rickAndMortyImage.autoCenterInSuperview()
        rickAndMortyImage.autoSetDimensions(to: CGSize(width: 374, height: 64))

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func scaleDownAnimation() {
        UIView.animate(withDuration: 0.5, animations: {
            self.rickAndMortyImage.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }) { (_) in
            self.scaleUpAnimation()

        }
    }

    func scaleUpAnimation() {
        UIView.animate(withDuration: 0.35, delay: 0.1, options: .curveEaseIn) {
            self.rickAndMortyImage.transform = CGAffineTransform(scaleX: 5, y: 5)
        } completion: { (_) in
            self.removeSplashScreen()
        }

    }
    func removeSplashScreen() {
        self.removeFromSuperview()
    }
}
