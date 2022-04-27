//
//  MoviesRepository.swift
//  MovieTest
//
//  Created by TaiPV on 4/27/22.
//

import Foundation

protocol MoviesRepository {
    @discardableResult
    func fetchMoviesList(page: Int,
                         completion: @escaping (Result<MoviesPage, Error>) -> Void) -> Cancellable?
}
