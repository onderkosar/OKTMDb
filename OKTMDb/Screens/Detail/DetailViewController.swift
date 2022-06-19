//
//  DetailViewController.swift
//  OKTMDb
//
//  Created by Önder Koşar on 18.06.2022.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var backButtonImageView: UIImageView!
    @IBOutlet weak var pageTitleLabel: UILabel!
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var imdbImageView: UIImageView!
    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    
    let indicator = UIActivityIndicatorView(style: .large)
    var movieId: Int?
    private var movieURL: String?
    
    lazy var viewModel: DetailViewModel = {
        return DetailViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        configureElements()
        configureGestureRecognizers()
        configureActivityIndicators()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    private func configureElements() {
        descriptionTextView.textContainer.lineFragmentPadding = 0
        descriptionTextView.textContainerInset = .zero
    }
    
    private func configureGestureRecognizers() {
        backButtonImageView?.isUserInteractionEnabled = true
        let dismissGesture = UITapGestureRecognizer(target: self, action: #selector(backButtonIsTapped))
        backButtonImageView?.addGestureRecognizer(dismissGesture)
        
        imdbImageView?.isUserInteractionEnabled = true
        let redirectionGesture = UITapGestureRecognizer(target: self, action: #selector(imdbButtonIsTapped))
        imdbImageView?.addGestureRecognizer(redirectionGesture)
    }
    
    private func configureActivityIndicators() {
        indicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(indicator)
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func updateUI() {
        indicator.startAnimating()
        guard let id = movieId else { return }
        viewModel.getMovie(with: id)
    }
    
    @objc func backButtonIsTapped(sender: UITapGestureRecognizer) {
        dismiss(animated: true)
    }
    
    @objc func imdbButtonIsTapped(sender: UITapGestureRecognizer) {
        if let urlString = movieURL, let url = URL(string: "https://www.imdb.com/title/\(urlString)/") {
            UIApplication.shared.open(url)
        }
    }
}

extension DetailViewController: DetailDelegate {
    func handleViewModelOutput(_ output: DetailViewModelOutput) {
        switch output {
        case .reloadUI(let movie):
            movieURL = movie.imdbID
            pageTitleLabel.text = movie.title
            if let movieImage = movie.backdropPath {
                backdropImageView.setImage(with: NetworkingInfo.imageBase500 + movieImage)
            }
            voteAverageLabel.setAttributedText(primaryString: "\(movie.voteAverage ?? 0)", secondaryString: "/10")
            titleLabel.text = movie.title
            descriptionTextView.text = movie.overview
            dateLabel.text = movie.releaseDate?.toDate?.formattedDate
            indicator.stopAnimating()
        case .showError(let title, let message):
            if indicator.isAnimating {
                indicator.stopAnimating()
            }
            let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let submitAction = UIAlertAction(title: AlertMessages.ok, style: .cancel)
            ac.addAction(submitAction)
            ac.view.tintColor = .purple
            present(ac, animated: true)
        }
    }
}
