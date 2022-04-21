//
//  HomeViewController.swift
//  Netflix Clone
//
//  Created by Silviu Nicolae on 20.04.2022.
//

import UIKit

enum Sections: Int {
    case Popular = 0
    case TrendingMovies = 1
    case TrendingTv = 2
    case Upcoming = 3
    case TopRated = 4
}

class HomeViewController: UIViewController {
    
    let sectionTitles: [String] = ["Popular", "Trending Movies", "Trending TV", "Upcoming Movies","Top rated"]
    
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        configureNavBar()
        
        let headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeFeedTable.tableHeaderView = headerView
        
//        getPopularMovies()
//        getTrendingMovies()
//        getTrendingTv()
//        getUpcomingMovies()
//        getTopRatedMovies()
    }
    
    private func configureNavBar() {
        var image = UIImage(named: "NetflixLogo")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.tv"), style: .done, target: self, action: nil)
        ]
        
    navigationController?.navigationBar.tintColor = UIColor(named: "SwitchSystemColor")
    
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
    
//    private func getPopularMovies() {
//        APICaller.shared.getPopularMovies { _ in
////            switch results {
////            case .success(let movies):
////                print(movies)
////            case .failure(let error):
////                print(error)
////            }
//        }
//    }
//
//    private func getTrendingMovies() {
//        APICaller.shared.getTrendingMovies { results in
//            switch results {
//            case .success(let movies):
//                print(movies)
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
//
//    private func getTrendingTv() {
//        APICaller.shared.getTrendingTv { results in
////            switch results {
////            case .success(let movies):
////                print(movies)
////            case .failure(let error):
////                print(error)
////            }
//        }
//    }
//
//    private func getUpcomingMovies() {
//        APICaller.shared.getUpcomingMovies { _ in
////            switch results {
////            case .success(let movies):
////                print(movies)
////            case .failure(let error):
////                print(error)
////            }
//        }
//    }
//
//    private func getTopRatedMovies() {
//        APICaller.shared.getTopRatedMovies { _ in
////            switch results {
////            case .success(let movies):
////                print(movies)
////            case .failure(let error):
////                print(error)
////            }
//        }
//    }
    
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        
        switch indexPath.section {
        case Sections.Popular.rawValue:
            APICaller.shared.getPopularMovies { result in
                switch result {
                case .success(let movies):
                    cell.configure(with: movies)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.TrendingMovies.rawValue:
            APICaller.shared.getTrendingMovies { result in
                switch result {
                case .success(let movies):
                    cell.configure(with: movies)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.TrendingTv.rawValue:
            APICaller.shared.getTrendingTv { result in
                switch result {
                case .success(let movies):
                    cell.configure(with: movies)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.Upcoming.rawValue:
            APICaller.shared.getUpcomingMovies { result in
                switch result {
                case .success(let movies):
                    cell.configure(with: movies)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.TopRated.rawValue:
            APICaller.shared.getTopRatedMovies { result in
                switch result {
                case .success(let movies):
                    cell.configure(with: movies)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        default:
            return UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = UIColor(named: "SwitchSystemColor")
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }

}
