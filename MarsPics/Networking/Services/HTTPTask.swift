//
//  HTTPTask.swift
//  GitRepos
//
//  Created by roberto fernandes filho on 18/12/2018.
//  Copyright © 2018 Betocorporation. All rights reserved.
//

import Foundation

//typealias criado para utilizar como dicionario
public typealias HTTPHeaders = [String:String]


//Configura os parametros para um determinado EndPoint
public enum HTTPTask {
    
    case request
    
    case requestParameter(bodyParameters: Parameters?, urlParameters: Parameters?)
    
    case requestParametersAndHeaders(bodyParameters: Parameters?, urlParameters: Parameters?, additionalHeaders: HTTPHeaders?)
}
