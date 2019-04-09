//
//  Camera.swift
//  MarsPics
//
//  Created by roberto fernandes filho on 06/04/2019.
//  Copyright © 2019 Betocorporation. All rights reserved.
//

import Foundation

struct Camera {
    let id: Int
    let name: String
    let roverID: Int
    let fullName: String
}

extension Camera : Decodable {
    enum ResponseCodingKeys: String, CodingKey {
        case id, name
        case roverID = "rover_id"
        case fullName = "full_name"
    }
    
    init(from decoder: Decoder) throws {
        let cameraContainer = try decoder.container(keyedBy: ResponseCodingKeys.self)
        
        id = try cameraContainer.decode(Int.self, forKey: .id)
        name = try cameraContainer.decode(String.self, forKey: .name)
        roverID = try cameraContainer.decode(Int.self, forKey: .roverID)
        fullName = try cameraContainer.decode(String.self, forKey: .fullName)
    }
}
