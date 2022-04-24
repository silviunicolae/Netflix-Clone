//
//  DownloadsViewController.swift
//  Netflix Clone
//
//  Created by Silviu Nicolae on 20.04.2022.
//

import UIKit

class DownloadsViewController: UIViewController {
    
    private var movies: [MovieItem] = [MovieItem]()
    
    private let downloadsTable: UITableView = {
        let table = UITableView()
        table.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        return table
    }()


    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(downloadsTable)
        downloadsTable.delegate = self
        downloadsTable.dataSource = self
        fetchLocalStorage()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil) { _ in
            self.fetchLocalStorage()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadsTable.frame = view.bounds
    }
    
    private func fetchLocalStorage() {
        DataPersistenceManager.shared.fetchMovieFromDB { [weak self] result in
            switch result {
            case .success(let movies):
                DispatchQueue.main.async {
                    self?.movies = movies
                    self?.downloadsTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

extension DownloadsViewController: UITableViewDelegate, UITableViewDataSource {
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            DataPersistenceManager.shared.deleteMovie(model: movies[indexPath.row]) { [weak self] result in
                switch result {
                case .success():
                    print("deleted from DB")
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self?.movies.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        default:
            break
        }
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
