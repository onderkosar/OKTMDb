//
//  MainContracts.swift
//  OKTMDb
//
//  Created by Önder Koşar on 18.06.2022.
//

import Foundation

protocol MainProtocol {
    func fetchNowPlayingList()
    func fetchUpcomingList()
}

enum MainViewModelOutput {
    case loadNowPlayingList
    case loadUpcomingList
    case showError(title: String, message: String)
}

protocol MainDelegate: AnyObject {
    func handleViewModelOutput(_ output: MainViewModelOutput)
}
