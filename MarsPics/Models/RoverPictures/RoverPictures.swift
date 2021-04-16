//
//  RoverPictures.swift
//  MarsPics
//
//  Created by roberto fernandes filho on 06/04/2019.
//  Copyright © 2019 Betocorporation. All rights reserved.
//

import Foundation

struct RoverPictures {
    var total: Int = 0
    var roverPictures = [Picture]()
}

extension RoverPictures: Decodable {
    enum ResponseCodingKeys: String, CodingKey {
        case roverPictures = "photos"
    }
    
    init(from decoder: Decoder) throws {
        let roverPicturesContainer = try decoder.container(keyedBy: ResponseCodingKeys.self)
        
        roverPictures = try roverPicturesContainer.decode([Picture].self, forKey: .roverPictures)
    }
}
