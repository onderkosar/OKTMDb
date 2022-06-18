//
//  MainViewController.swift
//  OKTMDb
//
//  Created by Önder Koşar on 18.06.2022.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nowPlayingCollectionView: UICollectionView!
    @IBOutlet weak var upcomingTableView: UITableView!
    
    let nowPlayingIndicator = UIActivityIndicatorView(style: .large)
    let upcomingIndicator = UIActivityIndicatorView(style: .large)
    
    lazy var viewModel: MainViewModel = {
        return MainViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        configureScrollView()
        configureCollectionView()
        configureTableView()
        configureActivityIndicators()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nowPlayingIndicator.startAnimating()
        viewModel.fetchNowPlayingList()
        upcomingIndicator.startAnimating()
        viewModel.fetchUpcomingList()
    }
    
    private func configureScrollView() {
        scrollView.delegate = self
        scrollView.bounces = false
    }
    
    private func configureCollectionView() {
        nowPlayingCollectionView.register(UINib(nibName: StoryboardIDs.nowPlayingListCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: StoryboardIDs.nowPlayingListCollectionViewCell)
        nowPlayingCollectionView.delegate = self
        nowPlayingCollectionView.dataSource = self
    }
    
    private func configureTableView() {
        upcomingTableView.delegate = self
        upcomingTableView.dataSource = self
        upcomingTableView.register(UINib(nibName: StoryboardIDs.upcomingListTableViewCell, bundle: nil), forCellReuseIdentifier: StoryboardIDs.upcomingListTableViewCell)
        upcomingTableView.separatorStyle = .none
        upcomingTableView.isScrollEnabled = false
        upcomingTableView.bounces = true
    }
    
    private func configureActivityIndicators() {
        nowPlayingIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nowPlayingIndicator)
        nowPlayingIndicator.centerXAnchor.constraint(equalTo: nowPlayingCollectionView.centerXAnchor).isActive = true
        nowPlayingIndicator.centerYAnchor.constraint(equalTo: nowPlayingCollectionView.centerYAnchor).isActive = true
        upcomingIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(upcomingIndicator)
        upcomingIndicator.centerXAnchor.constraint(equalTo: upcomingTableView.centerXAnchor).isActive = true
        upcomingIndicator.centerYAnchor.constraint(equalTo: upcomingTableView.topAnchor, constant: 200.0).isActive = true
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = view.bounds.width
        let cellHeight = cellWidth * 0.69
        return CGSize(width: cellWidth, height: cellHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.nowPlayingMovies?.results.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryboardIDs.nowPlayingListCollectionViewCell, for: indexPath) as! NowPlayingListCollectionViewCell
        cell.setupCell(with: viewModel.nowPlayingMovies?.results[indexPath.row])
        return cell
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.upcomingMovies?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StoryboardIDs.upcomingListTableViewCell, for: indexPath) as! UpcomingListTableViewCell
        cell.selectionStyle = .none
        cell.setupCell(with: viewModel.upcomingMovies?.results[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 136
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            upcomingTableView.isScrollEnabled = (self.scrollView.contentOffset.y >= nowPlayingCollectionView.bounds.height)
        } else if scrollView == upcomingTableView {
            upcomingTableView.isScrollEnabled = (upcomingTableView.contentOffset.y > 0)
        }
    }
}

extension MainViewController: MainDelegate {
    func handleViewModelOutput(_ output: MainViewModelOutput) {
        switch output {
        case .loadNowPlayingList:
            nowPlayingCollectionView.reloadData()
            nowPlayingIndicator.stopAnimating()
        case .loadUpcomingList:
            upcomingTableView.reloadData()
            upcomingIndicator.stopAnimating()
        case .showError(let title, let message):
            let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let submitAction = UIAlertAction(title: AlertMessages.ok, style: .cancel)
            ac.addAction(submitAction)
            ac.view.tintColor = .purple
            present(ac, animated: true)
        }
    }
}
