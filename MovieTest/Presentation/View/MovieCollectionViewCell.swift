//
//  MovieCollectionViewCell.swift
//  MovieTest
//
//  Created by TaiPV on 4/27/22.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    private var viewModel: MoviesListItemViewModel!
    
    lazy var backgroundImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        return iv
    }()
    
    lazy var year: UILabel = {
        let year = UILabel()
        year.translatesAutoresizingMaskIntoConstraints = false
        year.text = "2022"
        year.textColor = .white
        year.font = UIFont.systemFont(ofSize: 14)
        return year
    }()
    
    lazy var title: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.numberOfLines = 2
        title.text = "Default Tittle"
        title.textColor = .white
        title.font = UIFont.boldSystemFont(ofSize: 14)
        return title
    }()
    
    lazy var score: UILabel = {
        let score = UILabel()
        score.translatesAutoresizingMaskIntoConstraints = false
        score.text = "9.9"
        score.textColor = .white
        return score
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.backgroundColor = .clear
        contentView.addSubview(backgroundImage)
        contentView.addSubview(year)
        contentView.addSubview(title)
        contentView.addSubview(score)
        
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundImage.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            backgroundImage.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            title.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            title.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
            title.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8),
        ])
        
        NSLayoutConstraint.activate([
            year.bottomAnchor.constraint(equalTo: title.topAnchor),
            year.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
        ])
        
        NSLayoutConstraint.activate([
            score.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            score.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8),
        ])
        
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = false
        contentView.layer.shadowRadius = 8
        contentView.layer.shadowOffset = CGSize(width: 0, height: 10)
        contentView.layer.shadowOpacity = 0.5
        contentView.layer.shadowColor = UIColor.black.cgColor
        //contentView.layer.shadowPath = UIBezierPath(rect: contentView.bounds).cgPath
    }
    
    func fill(with viewModel: MoviesListItemViewModel) {
        self.viewModel = viewModel

        title.text = viewModel.title
        year.text = viewModel.releaseDate
        //score.text = "\(viewModel.score ?? 0)"
        if let score = viewModel.score {
            let scoreView = ScoreView(frame: .zero, score: score)
            scoreView.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(scoreView)
            NSLayoutConstraint.activate([
                scoreView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                scoreView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8),
            ])
        }
        
        /// Just for demo, this line will run when every movie cell being show
        /// In real project, we will use cached image with Kingfisher,..
        updatePosterImage()
    }
    
    private func updatePosterImage() {
        if let data = self.viewModel.data {
            self.backgroundImage.image = UIImage(data: data)
        } else {
            backgroundImage.image = nil
            viewModel.fetchPoster { [weak self] data in
                self?.backgroundImage.image = UIImage(data: data)
            }
        }
    }
}

class ScoreView: UIView {
    var score: Double = 0
    
    lazy var circular: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 24).isActive = true
        view.heightAnchor.constraint(equalToConstant: 24).isActive = true
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    lazy var scoreLabel: UILabel = {
        let score = UILabel()
        score.translatesAutoresizingMaskIntoConstraints = false
        score.textColor = .white
        score.font = UIFont.boldSystemFont(ofSize: 10)
        return score
    }()
    
    convenience init(frame: CGRect, score: Double) {
        self.init(frame: frame)
        
        self.addSubview(circular)
        circular.backgroundColor = .orange
        NSLayoutConstraint.activate([
            circular.topAnchor.constraint(equalTo: self.topAnchor),
            circular.leftAnchor.constraint(equalTo: self.leftAnchor),
            circular.rightAnchor.constraint(equalTo: self.rightAnchor),
            circular.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        
        self.addSubview(scoreLabel)
        NSLayoutConstraint.activate([
            scoreLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            scoreLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        scoreLabel.text = "\(score)"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
