//
//  Picture.swift
//  MarsPics
//
//  Created by roberto fernandes filho on 06/04/2019.
//  Copyright © 2019 Betocorporation. All rights reserved.
//

import Foundation

struct Picture {
    let id, sol: Int
    let camera: Camera
    let imgSrc: String
    let earthDate: String
    let rover: Rover
}

extension Picture: Decodable {
    enum ResponseCodingKeys: String, CodingKey {
        case id, sol, camera
        case imgSrc = "img_src"
        case earthDate = "earth_date"
        case rover
    }
    
    init(from decoder: Decoder) throws {
        let photoContainer = try decoder.container(keyedBy: ResponseCodingKeys.self)
        
        id = try photoContainer.decode(Int.self, forKey: .id)
        sol = try photoContainer.decode(Int.self, forKey: .sol)
        camera = try photoContainer.decode(Camera.self, forKey: .camera)
        imgSrc = try photoContainer.decode(String.self, forKey: .imgSrc)
        earthDate = try photoContainer.decode(String.self, forKey: .earthDate)
        rover = try photoContainer.decode(Rover.self, forKey: .rover)
    }
}
