//
//  NowPlayingListTableViewCell.swift
//  OKTMDb
//
//  Created by Önder Koşar on 19.06.2022.
//

import UIKit

protocol NowPlayingListTableViewCellDelegate {
    func paginate()
    func tapMovie(with id: Int)
}

class NowPlayingListTableViewCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var nowPlayingMovies: [ListResult] = []
    var delegate: NowPlayingListTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCollectionView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    private func configureCollectionView() {
        collectionView.register(UINib(nibName: StoryboardIDs.nowPlayingListCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: StoryboardIDs.nowPlayingListCollectionViewCell)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
    }

    func reloadCollectionView(with movies: [ListResult]) {
        nowPlayingMovies = movies
        collectionView.reloadData()
    }
}

extension NowPlayingListTableViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = contentView.bounds.width
        let cellHeight = cellWidth * 0.70
        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nowPlayingMovies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryboardIDs.nowPlayingListCollectionViewCell, for: indexPath) as! NowPlayingListCollectionViewCell
        cell.setupCell(with: nowPlayingMovies[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movieId = nowPlayingMovies[indexPath.row].id else { return }
        delegate?.tapMovie(with: movieId)
    }
}

extension NowPlayingListTableViewCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            guard collectionView.contentSize.width > 0 else { return }
            let position = scrollView.contentOffset.x
            if position > ((collectionView.contentSize.width) - (scrollView.frame.size.width)) - 100 {
                delegate?.paginate()
            }
        }
    }
}
