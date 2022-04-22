//
//  MovieTableViewCell.swift
//  Netflix Clone
//
//  Created by Silviu Nicolae on 21.04.2022.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    static let identifier = "MovieTableViewCell"
    
    private let moviePosterUIImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let movieLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let playMovieButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor(named: "SwitchSystemColor")
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(moviePosterUIImageView)
        contentView.addSubview(movieLabel)
        contentView.addSubview(playMovieButton)
        
        applyConstrains()
    }
    
    private func applyConstrains() {
        let moviePosterUIImageViewConstrains = [
            moviePosterUIImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            moviePosterUIImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            moviePosterUIImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            moviePosterUIImageView.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        let movieLabelConstrains = [
            movieLabel.leadingAnchor.constraint(equalTo: moviePosterUIImageView.trailingAnchor, constant: 10),
            movieLabel.widthAnchor.constraint(equalToConstant:  UIScreen.main.bounds.width - 160),
            movieLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        let playMovieButtonConstrains = [
            playMovieButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            playMovieButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(moviePosterUIImageViewConstrains)
        NSLayoutConstraint.activate(movieLabelConstrains)
        NSLayoutConstraint.activate(playMovieButtonConstrains)
    }
    
    public func configure(with model: MovieViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(model.posterURL)") else { return }
        moviePosterUIImageView.sd_setImage(with: url, completed: nil)
        movieLabel.text = model.titleName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
