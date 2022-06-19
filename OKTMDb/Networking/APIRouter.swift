//
//  APIRouter.swift
//  OKTMDb
//
//  Created by Önder Koşar on 18.06.2022.
//

import Foundation
import Alamofire

enum APIRouter: URLRequestConvertible {
    case getNowPlayingList(page: Int)
    case getUpcomingList(page: Int)
    case getMovieDetails(id: String)
    
    private var method: HTTPMethod {
        switch self {
        case .getNowPlayingList, .getUpcomingList, .getMovieDetails:
            return .get
        }
    }
    
    private var path: String {
        switch self {
        case .getNowPlayingList:
            return "/now_playing"
        case .getUpcomingList:
            return "/upcoming"
        case .getMovieDetails(id: let id):
            return "/\(id)"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let endpoint: String = {
            switch self {
            case .getNowPlayingList, .getUpcomingList, .getMovieDetails:
                return NetworkingInfo.baseURL + "/3/movie"
            }
        }()
        let url = try endpoint.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        let parametersResult: Parameters = {
            switch self {
            case .getNowPlayingList(page: let page):
                return ["api_key": NetworkingInfo.apiKey, "page": page]
            case .getUpcomingList(let page):
                return ["api_key": NetworkingInfo.apiKey, "page": page]
            case .getMovieDetails:
                return ["api_key": NetworkingInfo.apiKey]
            }
        }()
        if (method == .post || method == .patch) {
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parametersResult)
        } else {
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parametersResult)
        }
        debugPrint("------------ REQUEST -----------")
        debugPrint (urlRequest)
        if let data = urlRequest.httpBody {
            debugPrint("parameters: \(String(decoding: data, as: UTF8.self))")
        }
        return urlRequest
    }
}
