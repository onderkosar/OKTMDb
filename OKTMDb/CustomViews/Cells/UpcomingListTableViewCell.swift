//
//  UpcomingListTableViewCell.swift
//  OKTMDb
//
//  Created by Önder Koşar on 19.06.2022.
//

import UIKit

class UpcomingListTableViewCell: UITableViewCell {
    @IBOutlet weak var imageContentView: UIView!
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        imageContentView.layer.cornerRadius = 15
        imageContentView.clipsToBounds = true
        setupEmptyCell()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setupEmptyCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell(with movie: ListResult?) {
        guard let movie = movie else {
            setupEmptyCell()
            return
        }
        titleLabel.text = movie.title
        descriptionLabel.text = movie.overview
        dateLabel.text = movie.releaseDate.toDate?.formattedDate
        backdropImageView.setImage(with: NetworkingInfo.imageBase500 + movie.backdropPath)
    }
    
    private func setupEmptyCell() {
        titleLabel.text = "Launch Title: N/A"
        descriptionLabel.text = "Launch Description: N/A"
        dateLabel.text = "Launch Date: N/A"
        backdropImageView.image = Images.placeholderImage
    }
}
