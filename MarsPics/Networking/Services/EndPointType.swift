//
//  EndPointType.swift
//  GitRepos
//
//  Created by roberto fernandes filho on 18/12/2018.
//  Copyright © 2018 Betocorporation. All rights reserved.
//

import Foundation

//Toda configuração necessaria para o EndPoint(Componentes da URL Request)

protocol EndPointType {
    var baseURL: URL {get}
    var APIKey: String {get}
    var path: String {get}
    var queryItens: [URLQueryItem]? {get}
    var httpMethod: HTTPMethod {get}
    var task: HTTPTask {get}
    var headers: HTTPHeaders? {get}
}
