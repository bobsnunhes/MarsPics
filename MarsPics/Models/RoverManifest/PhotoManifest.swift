//
//  PhotoManifest.swift
//  MarsPics
//
//  Created by roberto fernandes filho on 08/04/2019.
//  Copyright © 2019 Betocorporation. All rights reserved.
//

import Foundation

struct PhotoManifest {
    let name, landingDate, launchDate, status: String
    let maxSol: Int
    let maxDate: String
    let totalPhotos: Int
    let photos: [Photo]
}

extension PhotoManifest: Decodable {
    enum ResponseCodingKeys: String, CodingKey {
        case name
        case landingDate = "landing_date"
        case launchDate = "launch_date"
        case status
        case maxSol = "max_sol"
        case maxDate = "max_date"
        case totalPhotos = "total_photos"
        case photos
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ResponseCodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        landingDate = try container.decode(String.self, forKey: .landingDate)
        launchDate = try container.decode(String.self, forKey: .launchDate)
        status = try container.decode(String.self, forKey: .status)
        maxSol = try container.decode(Int.self, forKey: .maxSol)
        maxDate = try container.decode(String.self, forKey: .maxDate)
        totalPhotos = try container.decode(Int.self, forKey: .totalPhotos)
        photos = try container.decode([Photo].self, forKey: .photos)
    }
}


