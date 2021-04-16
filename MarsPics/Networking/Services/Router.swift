//
//  Router.swift
//  GitRepos
//
//  Created by roberto fernandes filho on 18/12/2018.
//  Copyright © 2018 Betocorporation. All rights reserved.
//

import Foundation

let sessionManager: URLSession = {
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = 30 // segundos
    configuration.timeoutIntervalForResource = 30 // segundos
    return URLSession(configuration: configuration)
}()

var task = URLSessionTask()

//Faz a chamada do request passando o EndPoint criado
class Router<EndPoint: EndPointType>: NetworkRouter {
    
    
    //Cria o resquest a partir da route e com ele cria e inicia uma task.
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) {
        do{
            if let request = try self.buildRequest(from: route) {
                
                task = sessionManager.dataTask(with: request.url!, completionHandler: { (data, response, error) in
                    
                    if let error = error {
                        print(error)
                        completion(nil,nil,error)
                    }
                    
                    if let data = data {
                        completion(data, response, nil)
                    }
                })
            }
        } catch {
            completion(nil, nil, error)
        }
        
        task.resume()
    }

    //Cancela a URLSessionTask
    func cancel() {
        task.cancel()
    }
    
    //Converte o EndPoint para URLRequest que será passado para a sessão
    fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest? {
        var urlComponents = URLComponents(url: route.baseURL, resolvingAgainstBaseURL: false)
        
//        print("Route Path = \(route.path)")
//        print("QueryItems = \(route.queryItens)")
        
        urlComponents?.path = route.path
        urlComponents?.queryItems = route.queryItens
    
        if let url = urlComponents!.url {
            var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
            
            request.httpMethod = route.httpMethod.rawValue
            do {
                switch route.task {
                case .request:
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                case .requestParameter(let bodyParameters, let urlParameters):
                    try self.configureParameters(bodyParameters: bodyParameters, urlParameters: urlParameters, request: &request)
                case .requestParametersAndHeaders(let bodyParameters, let urlParameters, let additionalHeaders):
                    self.addAdditionalHeaders(additionalHeaders, request: &request)
                    try self.configureParameters(bodyParameters: bodyParameters, urlParameters: urlParameters, request: &request)
                }
                
                return request
            } catch {
                throw error
            }
        } else {
            return nil
        }
    }
    
    //Realiza o encoding dos parametros
    fileprivate func configureParameters(bodyParameters: Parameters?, urlParameters: Parameters?, request: inout URLRequest) throws {
        do {
            if let bodyParameters = bodyParameters {
                try JSONParameterEncoder.encode(urlRequest: &request, with: bodyParameters)
            }
            
            if let urlParameters = urlParameters {
                try JSONParameterEncoder.encode(urlRequest: &request, with: urlParameters)
            }
        } catch {
            throw error
        }
    }
    
    //Adiciona todos os additional headers ao request
    fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else {return}
        
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
}
