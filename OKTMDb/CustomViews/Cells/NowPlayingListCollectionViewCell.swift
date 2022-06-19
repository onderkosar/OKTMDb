//
//  NowPlayingListCollectionViewCell.swift
//  OKTMDb
//
//  Created by Önder Koşar on 19.06.2022.
//

import UIKit
import Kingfisher

class NowPlayingListCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setupEmptyCell()
    }
    
    func setupCell(with movie: ListResult?) {
        guard let movie = movie else {
            setupEmptyCell()
            return
        }
        titleLabel.text = movie.title
        descriptionLabel.text = movie.overview
        if let movieImage = movie.backdropPath {
            backdropImageView.setImage(with: NetworkingInfo.imageBase500 + movieImage)
        }
    }
    
    private func setupEmptyCell() {
        titleLabel.text = "Launch Title: N/A"
        backdropImageView.image = Images.placeholderImage
    }
}
