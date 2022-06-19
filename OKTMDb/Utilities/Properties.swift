//
//  Properties.swift
//  OKTMDb
//
//  Created by Önder Koşar on 18.06.2022.
//

import UIKit

enum StoryboardIDs {
    static let detailViewController = "DetailViewController"
    static let upcomingListTableViewCell = "UpcomingListTableViewCell"
    static let nowPlayingListTableViewCell = "NowPlayingListTableViewCell"
    static let nowPlayingListCollectionViewCell = "NowPlayingListCollectionViewCell"
}

enum NetworkingInfo {
    static let baseURL = "https://api.themoviedb.org"
    static let apiKey = "43da8c97032923c298eef3cea9674f16"
    static let imageBaseOriginal = "https://image.tmdb.org/t/p/original"
    static let imageBase500 = "https://image.tmdb.org/t/p/w500"
}

enum AlertMessages {
    static let ok = "OK"
    static let errorResult = "Error fetching movie results"
    static let errorDetails = "Error fetching movie details"
    static let pullToRefresh = "Refreshing..."
}

enum Images {
    static let placeholderImage = UIImage(systemName: "photo")
    static let logoImdb = UIImage(named: "logo_imdb")
}

enum Colors {
    static let black = UIColor(red: 43/255.0, green: 45/255.0, blue: 66/255.0, alpha: 1.0)
    static let green = UIColor(red: 173/255.0, green: 181/255.0, blue: 189/255.0, alpha: 1.0)
}
