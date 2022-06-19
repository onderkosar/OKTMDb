//
//  DetailContracts.swift
//  OKTMDb
//
//  Created by Önder Koşar on 19.06.2022.
//

import Foundation

protocol DetailProtocol {
    func getMovie(with id: Int)
}


enum DetailViewModelOutput {
    case reloadUI(movie: MovieDetailModel)
    case showError(title: String, message: String)
}

protocol DetailDelegate: AnyObject {
    func handleViewModelOutput(_ output: DetailViewModelOutput)
}
