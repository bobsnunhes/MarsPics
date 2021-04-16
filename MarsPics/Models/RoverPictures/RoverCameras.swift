//
//  RoverCameras.swift
//  MarsPics
//
//  Created by roberto fernandes filho on 06/04/2019.
//  Copyright © 2019 Betocorporation. All rights reserved.
//

import Foundation

struct RoverCameras {
    let name, fullName: String
}

extension RoverCameras: Decodable {
    enum ResponseCodingKeys: String, CodingKey {
        case name
        case fullName = "full_name"
    }
    
    init(from decoder: Decoder) throws {
        let roverCamerasContainer = try decoder.container(keyedBy: ResponseCodingKeys.self)
        
        name = try roverCamerasContainer.decode(String.self, forKey: .name)
        fullName = try roverCamerasContainer.decode(String.self, forKey: .name)
    }
}
