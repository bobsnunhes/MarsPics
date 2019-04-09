//
//  RoverManifest.swift
//  MarsPics
//
//  Created by roberto fernandes filho on 08/04/2019.
//  Copyright © 2019 Betocorporation. All rights reserved.
//

import Foundation


struct RoverManifest {
    let photoManifest: PhotoManifest
}

extension RoverManifest: Decodable {
    enum ResponseCodingKeys: String, CodingKey {
        case photoManifest = "photo_manifest"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ResponseCodingKeys.self)
        
        photoManifest = try container.decode(PhotoManifest.self, forKey: .photoManifest)
    }
}



