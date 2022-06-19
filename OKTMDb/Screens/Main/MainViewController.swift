//
//  MainViewController.swift
//  OKTMDb
//
//  Created by Önder Koşar on 18.06.2022.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var upcomingTableView: UITableView!
    
    let refreshControl = UIRefreshControl()
    let nowPlayingIndicator = UIActivityIndicatorView(style: .large)
    let upcomingIndicator = UIActivityIndicatorView(style: .large)
    
    lazy var viewModel: MainViewModel = {
        return MainViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        configureTableView()
        configureActivityIndicators()
        configureRefreshControl()
    }
    
    @objc func refresh(_ sender: AnyObject) {
        viewModel.nowPlayingPage = 1
        viewModel.upcomingPage = 1
        fetchAllData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAllData()
    }
    
    private func configureTableView() {
        upcomingTableView.delegate = self
        upcomingTableView.dataSource = self
        upcomingTableView.register(UINib(nibName: StoryboardIDs.nowPlayingListTableViewCell, bundle: nil), forCellReuseIdentifier: StoryboardIDs.nowPlayingListTableViewCell)
        upcomingTableView.register(UINib(nibName: StoryboardIDs.upcomingListTableViewCell, bundle: nil), forCellReuseIdentifier: StoryboardIDs.upcomingListTableViewCell)
        upcomingTableView.separatorStyle = .none
        upcomingTableView.bounces = true
    }
    
    private func configureActivityIndicators() {
        nowPlayingIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nowPlayingIndicator)
        nowPlayingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nowPlayingIndicator.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
        upcomingIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(upcomingIndicator)
        upcomingIndicator.centerXAnchor.constraint(equalTo: upcomingTableView.centerXAnchor).isActive = true
        upcomingIndicator.centerYAnchor.constraint(equalTo: upcomingTableView.centerYAnchor, constant: 100.0).isActive = true
    }
    
    private func configureRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: AlertMessages.pullToRefresh)
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        refreshControl.bounds = CGRect(x: refreshControl.bounds.minX, y: -(view.bounds.height / 2), width: refreshControl.bounds.width, height: refreshControl.bounds.height)
        upcomingTableView.addSubview(refreshControl)
    }
    
    private func fetchAllData() {
        nowPlayingIndicator.startAnimating()
        viewModel.fetchNowPlayingList()
        upcomingIndicator.startAnimating()
        viewModel.fetchUpcomingList()
    }
    
    private func presentDetail(id: Int) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: StoryboardIDs.detailViewController) as? DetailViewController else { return }
        vc.movieId = id
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return viewModel.upcomingMovies.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: StoryboardIDs.nowPlayingListTableViewCell, for: indexPath) as! NowPlayingListTableViewCell
            cell.selectionStyle = .none
            cell.reloadCollectionView(with: viewModel.nowPlayingMovies)
            cell.delegate = self
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: StoryboardIDs.upcomingListTableViewCell, for: indexPath) as! UpcomingListTableViewCell
            cell.selectionStyle = .none
            cell.setupCell(with: viewModel.upcomingMovies[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return view.bounds.width * 0.69
        default:
            return 136
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let movieId = viewModel.upcomingMovies[indexPath.row].id else { return }
        presentDetail(id: movieId)
    }
}

extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard upcomingTableView.contentSize.height > 0, !viewModel.isEndOfUpcomingData else { return }
        let position = scrollView.contentOffset.y
        if position > ((upcomingTableView.contentSize.height) - (scrollView.frame.size.height)) - 100 {
            viewModel.fetchUpcomingList()
        }
    }
}

extension MainViewController: MainDelegate {
    func handleViewModelOutput(_ output: MainViewModelOutput) {
        switch output {
        case .loadNowPlayingList:
            upcomingTableView.reloadSections(IndexSet(integersIn: 0...0), with: .none)
            nowPlayingIndicator.stopAnimating()
        case .loadUpcomingList:
            upcomingTableView.reloadData()
            upcomingIndicator.stopAnimating()
        case .showError(let title, let message):
            for indicator in [nowPlayingIndicator, upcomingIndicator] {
                if indicator.isAnimating {
                    indicator.stopAnimating()
                }
            }
            let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let submitAction = UIAlertAction(title: AlertMessages.ok, style: .cancel)
            ac.addAction(submitAction)
            ac.view.tintColor = .purple
            present(ac, animated: true)
        }
        
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }
}

extension MainViewController: NowPlayingListTableViewCellDelegate {
    func tapMovie(with id: Int) {
        presentDetail(id: id)
    }
    
    func paginate() {
        viewModel.fetchNowPlayingList()
    }
}
