//
//  NasaApi.swift
//  MarsPics
//
//  Created by roberto fernandes filho on 06/04/2019.
//  Copyright © 2019 Betocorporation. All rights reserved.
//

import Foundation

public enum NasaApi: EndPointType {
    
    case earthDate(date: String, page: String, roverType: String)
    case manifest(roverType: String)
    
    var queryItens: [URLQueryItem]? {
        switch self {
        case .earthDate(let date, let page, _):
            return [
                URLQueryItem(name: "earth_date", value: date),
                URLQueryItem(name: "page", value: page),
                URLQueryItem(name: "api_key", value: APIKey)
            ]
        case .manifest(_):
            return [URLQueryItem(name: "api_key", value: APIKey)]
        }
    }
    
    var enviromentBaseURL: String {
        return "https://api.nasa.gov/"
    }
    
    var baseURL: URL {
        guard let url = URL(string: enviromentBaseURL) else { fatalError("baseURL could not be generated")}
        return url
    }
    
    var APIKey: String {
        return "InhfRSZGDiIc1ZkLJJ4INyqgWsr6oI9Q3Ukzu9kW"
    }
    
    var path: String {
        switch self {
        case .earthDate(_, _,let roverType):
            return "/mars-photos/api/v1/rovers/\(roverType)/photos"
        case .manifest(let roverType):
            return "/mars-photos/api/v1/manifests/\(roverType)"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        return .request
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
