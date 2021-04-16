//
//  Rover.swift
//  MarsPics
//
//  Created by roberto fernandes filho on 06/04/2019.
//  Copyright © 2019 Betocorporation. All rights reserved.
//

import Foundation

struct Rover {
    let id: Int
    let name, landingDate, launchDate, status: String
    let maxSol: Int
    let maxDate: String
    let totalPhotos: Int
    let cameras: [RoverCameras]
}

extension Rover: Decodable {
    enum ResponseCodingKeys: String, CodingKey {
        case id, name
        case landingDate = "landing_date"
        case launchDate = "launch_date"
        case status
        case maxSol = "max_sol"
        case maxDate = "max_date"
        case totalPhotos = "total_photos"
        case cameras
    }
    
    init(from decoder: Decoder) throws {
        let roverContainer = try decoder.container(keyedBy: ResponseCodingKeys.self)
        
        id = try roverContainer.decode(Int.self, forKey: .id)
        name = try roverContainer.decode(String.self, forKey: .name)
        landingDate = try roverContainer.decode(String.self, forKey: .landingDate)
        launchDate = try roverContainer.decode(String.self, forKey: .launchDate)
        status = try roverContainer.decode(String.self, forKey: .status)
        maxSol = try roverContainer.decode(Int.self, forKey: .maxSol)
        maxDate = try roverContainer.decode(String.self, forKey: .maxDate)
        totalPhotos = try roverContainer.decode(Int.self, forKey: .totalPhotos)
        cameras = try roverContainer.decode([RoverCameras].self, forKey: .cameras)
    }
    
}





//    init(from decoder: Decoder) throws {
//        let roverCamerasContainer = try decoder.container(keyedBy: ResponseCodingKeys.self)
//
//        name = try roverCamerasContainer.decode(String.self, forKey: .name)
//        fullName = try roverCamerasContainer.decode(String.self, forKey: .name)
//    }
