//
//  Movie.swift
//  MovieNightApp
//
//  Created by Andrew Graves on 12/14/19.
//  Copyright © 2019 Andrew Graves. All rights reserved.
//

import Foundation
import UIKit

enum MovieArtworkState {
    case placeholder
    case downloaded
    case failed
}

class Movie: Decodable {
    let title: String
    let overview: String
    let releaseDate: String
    let id: Int
    let adult: Bool
    let popularity: Double
    let voteCount: Int
    let posterPath: String
    
    var artwork: UIImage? = nil
    var artworkState = MovieArtworkState.placeholder
    
    enum CodingKeys: String, CodingKey {
        case title
        case overview
        case releaseDate
        case id
        case adult
        case popularity
        case voteCount
        case posterPath
    }
    
    init() {
        title = ""
        overview = ""
        releaseDate = ""
        id = 0
        adult = false
        popularity = 0.0
        voteCount = 0
        posterPath = ""
    }
}
