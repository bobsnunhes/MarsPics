//
//  NetworkRouter.swift
//  GitRepos
//
//  Created by roberto fernandes filho on 18/12/2018.
//  Copyright © 2018 Betocorporation. All rights reserved.
//

import Foundation

public typealias NetworkRouterCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> ()

//Realiza o request passando o EndPoint criado
protocol NetworkRouter: class {
    associatedtype EndPoint: EndPointType
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion)
    func cancel()
}
