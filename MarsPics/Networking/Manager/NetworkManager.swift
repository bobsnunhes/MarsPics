//
//  NetworkManager.swift
//  GitRepos
//
//  Created by roberto fernandes filho on 19/12/2018.
//  Copyright © 2018 Betocorporation. All rights reserved.
//

import Foundation

struct NetworkManager {

    let router = Router<NasaApi>()
    
    private var queue = DispatchQueue.global(qos: .userInteractive) //DispatchQueue(label: "work", qos: .userInteractive, attributes: .concurrent)
    
    init() {}
    
    //Tratamento de erros para o response da API
    enum NetworkResponse: String {
        case success
        case authenticationError = "Erro de autenticação."
        case badRequest = "Erro ao realizar o request."
        case outdated = "A URL utilizada no request está desatualizada."
        case failed = "Falha de rede, verifique sua conexão."
        case noData = "O response não retornou dados."
        case unableToDecode = "Não foi possível realizar o decode no response."
    }

    enum Result<String> {
        case success
        case failure(String)
    }
    
    //MARK: Tratamento de StatusCode
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String> {
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
    
    //MARK: getManifestRoverInfo - Busca informação sobre o manifesto do rover
    func getManifestRoverInfo(roverType: String, completion: @escaping(_ roverManifest: RoverManifest?, _ error: String?) ->()){
        queue.async {
            self.router.request(.manifest(roverType: roverType)) { (data, response, error) in
                
                if error != nil {
                    completion(nil, NetworkResponse.failed.rawValue)
                }
                
                if let response = response as? HTTPURLResponse {
                    let result = self.handleNetworkResponse(response)
                    
                    switch result {
                    case .success:
                        guard let responseData = data else {
                            completion(nil, NetworkResponse.noData.rawValue)
                            return
                        }
                        
                        do {
                            let apiResponse = try JSONDecoder().decode(RoverManifest.self, from: responseData)
                            
                            if apiResponse.photoManifest.name.isEmpty {
                                completion(nil, "Não retornou dados.")
                            } else {
                                completion(apiResponse, nil)
                            }
                            
                        } catch let error {
                            completion(nil, error.localizedDescription)
                        }
                    case.failure(let networkFailureError): completion(nil, networkFailureError)
                    }
                }
            }
        }
    }
    
    //MARK: getNewRoverPicturesInformation - Busca novas imagens (URL)
    func getNewRoverPicturesInformation(roverType: String,date: String, page: Int, completion: @escaping(_ roverPictures: RoverPictures?, _ error: String?) ->()){
        queue.async {
            self.router.request(.earthDate(date: date, page: "\(page)", roverType: roverType)) { (data, response, error) in
        
                if error != nil {
                    completion(nil, NetworkResponse.failed.rawValue)
                }
                
                if let response = response as? HTTPURLResponse {
                    let result = self.handleNetworkResponse(response)
                    
                    switch result {
                    case .success:
                        guard let responseData = data else {
                            completion(nil, NetworkResponse.noData.rawValue)
                            return
                        }
                        
                        do {
                            let apiResponse = try JSONDecoder().decode(RoverPictures.self, from: responseData)
                            
                            if apiResponse.roverPictures.count <= 0 {
                                completion(nil, "Não retornou dados.")
                            } else {
                                completion(apiResponse, nil)
                            }
                            
                        } catch let error {
                            completion(nil, error.localizedDescription)
                        }
                    case.failure(let networkFailureError): completion(nil, networkFailureError)
                    }
                }
            }
        }
    }
}
