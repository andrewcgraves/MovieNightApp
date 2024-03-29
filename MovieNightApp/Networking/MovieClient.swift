//
//  MovieClient.swift
//  MovieNightApp
//
//  Created by Andrew Graves on 12/14/19.
//  Copyright © 2019 Andrew Graves. All rights reserved.
//
//  Purpose: To create a client to call the tMDB Api

import Foundation

class MovieClient: APIClient {
    
    var session: URLSession
    private let APIKey = "931adb8f0fa9034f0eee754567a87c7f"
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    
    func discover(withGenre genre: Int, duringYear year: String, sortedBy sortBy: MovieEndpoints.MovieSortType, completion: @escaping (Result<[Movie], APIError>) -> Void) {

        let endpoint = MovieEndpoints.discoverWithGenre(genre: genre, year: year, sortBy: sortBy, apiKey: APIKey)

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let request = endpoint.request

        fetch(with: request, completion: completion) { data -> [Movie] in

            // if there are results...
            // Decode the results
            let results = try decoder.decode(PagedResponse<Movie>.self, from: data).results

            for movie in results {
                movie.configureDate()
            }

            return results
        }
    }
    
    
    func getGenres(completion: @escaping (Result<[Genre], APIError>) -> Void) {
        let endpoint = MovieEndpoints.getGenres(apiKey: APIKey)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let request = endpoint.request
        
        fetch(with: request, completion: completion) { data -> [Genre] in
            
            // Decode the results
            let response = try decoder.decode(GenreResponse.self, from: data)
            return response.genres
            
        }
    }
}
