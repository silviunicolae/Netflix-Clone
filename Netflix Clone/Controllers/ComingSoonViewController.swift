//
//  ComingSoonViewController.swift
//  Netflix Clone
//
//  Created by Silviu Nicolae on 20.04.2022.
//

import UIKit

class ComingSoonViewController: UIViewController {
    
    private var movies: [Movie] = [Movie]()
    
    private let comingSoonTable: UITableView = {
        let table = UITableView()
        table.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Coming Soon"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(comingSoonTable)
        comingSoonTable.delegate = self
        comingSoonTable.dataSource = self
        
        getUpcomingMovies()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        comingSoonTable.frame = view.bounds
    }
    
    private func getUpcomingMovies() {
        APICaller.shared.getUpcomingMovies { [weak self] result in
            switch result {
            case .success(let movies):
                self?.movies = movies
                DispatchQueue.main.async {
                    self?.comingSoonTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension ComingSoonViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        
        let movie = movies[indexPath.row]
        cell.configure(with: MovieViewModel(titleName: movie.original_title ?? "", posterURL: movie.poster_path ?? ""))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let movie = movies[indexPath.row]
        
        guard let movieName = movie.original_title ?? movie.title else { return }
        
        APICaller.shared.getYoutubeMovie(with: movieName) { [weak self] result in
            switch result {
            case .success(let video):
                DispatchQueue.main.async {
                    let vc = MoviePreviewViewController()
                    vc.configure(with: MoviePreviewViewModel(name: movieName, youtubeVideo: video, description: movie.overview ?? ""))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }

}
