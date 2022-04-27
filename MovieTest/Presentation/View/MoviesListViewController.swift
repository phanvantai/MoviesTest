//
//  MoviesListViewController.swift
//  MovieTest
//
//  Created by TaiPV on 4/27/22.
//

import UIKit

class MoviesListViewController: UIViewController {
    
    // MARK: - Properties
    var viewModel: MoviesListViewModel = defaultMoviesListVM
    
    // MARK: - Views
    /// Just for demo, this collection view is not optimized yet
    var myCollectionView: UICollectionView?
    private let refreshControl = UIRefreshControl()
    
    lazy var label: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Popular list"
        view.textColor = .black
        view.font = UIFont.boldSystemFont(ofSize: 18)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupCollectionViews()
        bind(to: viewModel)
        viewModel.viewDidLoad {
            // current do nothing here
        }
    }
    
    func setupViews() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            label.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 20)
        ])
    }
    
    func setupCollectionViews() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        let size = CGSize(width:(self.view.bounds.width-60)/2, height: 220)
        layout.itemSize = size
        
        myCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        myCollectionView?.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "MovieCollectionViewCell")
        myCollectionView?.refreshControl = refreshControl
        myCollectionView?.dataSource = self
        myCollectionView?.delegate = self
        myCollectionView?.backgroundColor = .white
        myCollectionView?.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(myCollectionView!)
        
        /// For the demo, just pure code for auto constraints
        NSLayoutConstraint.activate([
            myCollectionView!.topAnchor.constraint(equalTo: self.label.bottomAnchor),
            myCollectionView!.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            myCollectionView!.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            //myCollectionView!.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            myCollectionView!.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
        
        // refresh control
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
    }
    
    @objc private func refresh(_ sender: Any) {
        viewModel.didPullToRefesh { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }
    
    private func bind(to viewModel: MoviesListViewModel) {
        viewModel.items.observe(on: self) { [weak self] _ in self?.reload() }
        viewModel.error.observe(on: self) { [weak self] in self?.showError($0) }
    }
    
    func reload() {
        myCollectionView?.reloadData()
    }
    
    private func showError(_ error: String) {
        guard !error.isEmpty else { return }
        showAlert(message: error)
    }
    
    func showAlert(title: String = "", message: String, preferredStyle: UIAlertController.Style = .alert, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: completion)
    }
}

extension MoviesListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.items.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as? MovieCollectionViewCell {
            
            cell.fill(with: viewModel.items.value[indexPath.row])
            
            //
            if indexPath.row == viewModel.items.value.count - 1 {
                viewModel.didLoadNextPage {
                    // current do nothing here
                }
            }
            return cell
        }
        fatalError("Unable to dequeue subclassed cell")
    }
}

extension MoviesListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("User tapped on item \(indexPath.row)")
    }
}
