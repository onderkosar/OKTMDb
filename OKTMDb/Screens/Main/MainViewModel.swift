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
    var nowPlayingMovies: [ListResult] = []
    var upcomingMovies: [ListResult] = []
    var isEndOfNowPlayingData: Bool = false
    var isEndOfUpcomingData: Bool = false
    private var nowPlayingPage: Int = 1
    private var nowPlayingTotalPages: Int = 0
    private var isCurrentlyFetchingNowPlayingData: Bool = false
    private var upcomingPge: Int = 1
    private var upcomingTotalPages: Int = 0
    private var isCurrentlyFetchingUpcomingData: Bool = false
    
    private func onNowPlayingDataFetched<T: Codable>(data: T){
        if nowPlayingPage == nowPlayingTotalPages {
            isEndOfNowPlayingData = true
        } else {
            nowPlayingPage += 1
        }
    }
    
    private func onUpcomingDataFetched<T: Codable>(data: T){
        print("\(upcomingPge) - \(upcomingTotalPages)")
        if upcomingPge == upcomingTotalPages {
            isEndOfUpcomingData = true
        } else {
            upcomingPge += 1
        }
    }
    
    func fetchNowPlayingList() {
        if !isCurrentlyFetchingNowPlayingData && !isEndOfNowPlayingData {
            isCurrentlyFetchingNowPlayingData = true
            APIClient.request(route: .getNowPlayingList(page: nowPlayingPage)) { [weak self] (result: AFResult<MovieListModel>) in
                guard let self = self else { return }
                self.isCurrentlyFetchingNowPlayingData = false
                switch result {
                case .success(let data):
                    if let totalPages = data.totalPages {
                        self.nowPlayingTotalPages = totalPages
                    }
                    guard let results = data.results else { return }
                    self.nowPlayingMovies.append(contentsOf: results)
                    self.delegate?.handleViewModelOutput(.loadNowPlayingList)
                    self.onNowPlayingDataFetched(data: data)
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                    self.delegate?.handleViewModelOutput(.showError(title: AlertMessages.errorResult, message: error.localizedDescription))
                }
            }
        }
    }
    
    func fetchUpcomingList() {
        if !isCurrentlyFetchingUpcomingData && !isEndOfUpcomingData {
            isCurrentlyFetchingUpcomingData = true
            APIClient.request(route: .getUpcomingList(page: upcomingPge)) { [weak self] (result: AFResult<MovieListModel>) in
                guard let self = self else { return }
                self.isCurrentlyFetchingUpcomingData = false
                switch result {
                case .success(let data):
                    if let totalPages = data.totalPages {
                        self.upcomingTotalPages = totalPages
                    }
                    guard let results = data.results else { return }
                    self.upcomingMovies.append(contentsOf: results)
                    self.delegate?.handleViewModelOutput(.loadUpcomingList)
                    self.onUpcomingDataFetched(data: data)
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                    self.delegate?.handleViewModelOutput(.showError(title: AlertMessages.errorResult, message: error.localizedDescription))
                }
            }
        }
    }
}
