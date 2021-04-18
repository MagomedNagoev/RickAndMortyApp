//
//  File.swift
//  RickAndMortyApp
//
//  Created by Нагоев Магомед on 09.04.2021.
//

import UIKit
import PureLayout

class EpisodesViewController: UIViewController {
    private var episodesInfo: EpisodeInfoModel?
    private var episodes = [Episode]()
    private var episode: Int = 0
    private var countEpisodes: Int = 0
    private var url = "https://rickandmortyapi.com/api/episode/"
    private let tableView: UITableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        getInfo(url: "https://rickandmortyapi.com/api/episode")
    }

    func getInfo(url: String) {
        NetworkManager.fetchData(url: url, model: episodesInfo) { (episodesInfo1) in
            guard let count = episodesInfo1?.info.count else {return}
            self.countEpisodes = count
            self.getEpisodes(times: 10)
        }

    }
    func getEpisodes(times: Int) {
        print(countEpisodes)
        var newUrl = url
        if times < countEpisodes {

            for _ in 1...times {
                episode += 1
                newUrl += "\(episode),"
            }
        } else {
            for _ in 1...countEpisodes {
                episode += 1
                newUrl += "\(episode),"
            }
        }
        print(newUrl)
        NetworkManager.fetchData(url: newUrl, model: episodes) {[weak self] (episodes) in
            self?.episodes += episodes
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    func configureUI() {
        title = "All episodes"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white

        view.addSubview(tableView)
        tableView.autoPinEdgesToSuperviewSafeArea()
        tableView.dataSource = self
        tableView.register(EpisodeCell.self, forCellReuseIdentifier: EpisodeCell.identifier)
        tableView.register(LoadingEpisodeCell.self, forCellReuseIdentifier: LoadingEpisodeCell.identifier)
        tableView.delegate = self
    }

}

// MARK: - UITableView
extension EpisodesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if episode < countEpisodes && indexPath.row == episodes.count - 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LoadingEpisodeCell.identifier) as? LoadingEpisodeCell else { return UITableViewCell() }
            cell.startAnimating()
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EpisodeCell.identifier) as? EpisodeCell
            else {
                return UITableViewCell()
            }
            let episode = episodes[indexPath.row]
            guard let name = episode.name else {return UITableViewCell()}
            guard let nameEpisode = episode.episode else {return UITableViewCell()}
            cell.set(title: "\(nameEpisode): \(name)")

            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print(episode, countEpisodes, indexPath.row, episodes.count)
        if episode < countEpisodes && indexPath.row == episodes.count-1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.getEpisodes(times: 10)
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let characters = episodes[indexPath.row].characters else {return}
        let vc1 = CharactersViewController(urls: characters)
        self.definesPresentationContext = true
        navigationController?.pushViewController(vc1, animated: true)
    }
}
