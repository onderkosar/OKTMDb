//
//  Properties.swift
//  OKTMDb
//
//  Created by Önder Koşar on 18.06.2022.
//

import Foundation

enum NetworkingInfo {
    static let baseURL = "https://api.themoviedb.org"
    static let apiKey = "43da8c97032923c298eef3cea9674f16"
}

enum AlertMessages {
    static let ok = "OK"
    static let errorResult = "Error fetching movie results"
    static let errorDetails = "Error fetching movie details"
}
