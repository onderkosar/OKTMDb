//
//  MainViewModel.swift
//  OKTMDb
//
//  Created by Önder Koşar on 18.06.2022.
//

import Foundation
import Alamofire

class MainViewModel: MainProtocol {
    weak var delegate: MainDelegate?
    
    var nowPlayingMovies: MovieListModel?
    var upcomingMovies: MovieListModel?
    
    func fetchNowPlayingList() {
        APIClient.request(route: .getNowPlayingList) { [weak self] (result: AFResult<MovieListModel>) in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.nowPlayingMovies = data
                self.delegate?.handleViewModelOutput(.loadNowPlayingList)
            case .failure(let error):
                debugPrint(error.localizedDescription)
                self.delegate?.handleViewModelOutput(.showError(title: AlertMessages.errorResult, message: error.localizedDescription))
            }
        }
    }
    
    func fetchUpcomingList() {
        APIClient.request(route: .getUpcomingList) { [weak self] (result: AFResult<MovieListModel>) in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.upcomingMovies = data
                self.delegate?.handleViewModelOutput(.loadUpcomingList)
            case .failure(let error):
                debugPrint(error.localizedDescription)
                self.delegate?.handleViewModelOutput(.showError(title: AlertMessages.errorResult, message: error.localizedDescription))
            }
        }
    }
}
