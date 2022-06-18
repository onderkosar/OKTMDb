//
//  RequestError.swift
//  OKTMDb
//
//  Created by Önder Koşar on 18.06.2022.
//

import Foundation

enum RequestError: Error {
    case decode
    case invalidURL
    case noResponse
    case unexpectedStatus(code: Int?)
    case unknown
    
    var customMessage: String {
        switch self {
        case .decode:
            return "Unable to decode JSON"
        case .invalidURL:
            return "Invalid URL"
        case .noResponse:
            return "Unable to get response data"
        case .unexpectedStatus(let code):
            if let statusCode = code {
                return "Status Code: \(statusCode)"
            } else {
                return "Unknown status code"
            }
        default:
            return "Unknown error"
        }
    }
}
