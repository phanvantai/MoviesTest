//
//  DiscoveryMoviesUseCase.swift
//  MovieTest
//
//  Created by TaiPV on 4/27/22.
//

import Foundation

protocol DiscoverMoviesUseCase {
    func execute(requestValue: DiscoverMoviesUseCaseRequestValue,
                 completion: @escaping (Result<MoviesPage, Error>) -> Void) -> Cancellable?
}

final class DefaultDiscoverMoviesUseCase: DiscoverMoviesUseCase {

    private let moviesRepository: MoviesRepository

    init(moviesRepository: MoviesRepository) {
        self.moviesRepository = moviesRepository
    }

    func execute(requestValue: DiscoverMoviesUseCaseRequestValue,
                 completion: @escaping (Result<MoviesPage, Error>) -> Void) -> Cancellable? {

        return moviesRepository.fetchMoviesList(page: requestValue.page,
                                                completion: { result in
            completion(result)
        })
    }
}

struct DiscoverMoviesUseCaseRequestValue {
    let page: Int
}
