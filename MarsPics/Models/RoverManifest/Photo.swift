//
//  Photo.swift
//  MarsPics
//
//  Created by roberto fernandes filho on 08/04/2019.
//  Copyright © 2019 Betocorporation. All rights reserved.
//

import Foundation

struct Photo {
    let sol: Int
    let earthDate: String
    let totalPhotos: Int
    let cameras: [Camera]
}

extension Photo: Decodable {
    enum ResponseCodingKeys: String, CodingKey {
        case sol
        case earthDate = "earth_date"
        case totalPhotos = "total_photos"
        case cameras
    }
    
    enum Camera: String, Codable {
        case chemcam = "CHEMCAM"
        case fhaz = "FHAZ"
        case mahli = "MAHLI"
        case mardi = "MARDI"
        case mast = "MAST"
        case navcam = "NAVCAM"
        case rhaz = "RHAZ"
        case entry = "ENTRY"
        case minites = "MINITES"
        case pancam = "PANCAM"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ResponseCodingKeys.self)
        
        sol = try container.decode(Int.self, forKey: .sol)
        earthDate = try container.decode(String.self, forKey: .earthDate)
        totalPhotos = try container.decode(Int.self, forKey: .totalPhotos)
        cameras = try container.decode([Camera].self, forKey: .cameras)
    }
}

