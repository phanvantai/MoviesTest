//
//  APIEnpoints.swift
//  MovieTest
//
//  Created by TaiPV on 4/27/22.
//

import Foundation

struct APIEndpoints {
    
    static func getMovies(with moviesRequest: MoviesRequest) -> Endpoint<MoviesResponse> {

        return Endpoint(path: "3/discover/movie",
                        method: .get,
                        queryParametersEncodable: moviesRequest)
    }

    static func getMoviePoster(path: String) -> Endpoint<Data> {
        return Endpoint(path: "t/p/w500\(path)",
                        method: .get,
                        responseDecoder: RawDataResponseDecoder())
    }
}
