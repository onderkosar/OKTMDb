//
//  DetailViewModel.swift
//  OKTMDb
//
//  Created by Önder Koşar on 19.06.2022.
//

import Foundation
import Alamofire

class DetailViewModel: DetailProtocol {
    weak var delegate: DetailDelegate?
    
    var movie: MovieDetailModel?
    
    func getMovie(with id: Int) {
        APIClient.request(route: .getMovieDetails(id: "\(id)")) { [weak self] (result: AFResult<MovieDetailModel>) in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.delegate?.handleViewModelOutput(.reloadUI(movie: data))
            case .failure(let error):
                debugPrint(error.localizedDescription)
                self.delegate?.handleViewModelOutput(.showError(title: AlertMessages.errorDetails, message: error.localizedDescription))
            }
        }
    }
}
