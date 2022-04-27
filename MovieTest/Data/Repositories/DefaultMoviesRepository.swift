//
//  DefaultMoviesRepository.swift
//  MovieTest
//
//  Created by TaiPV on 4/27/22.
//

import Foundation

final class DefaultMoviesRepository {

    private let dataTransferService: DataTransferService

    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
}

extension DefaultMoviesRepository: MoviesRepository {
    func fetchMoviesList(page: Int, completion: @escaping (Result<MoviesPage, Error>) -> Void) -> Cancellable? {
        
        let request = MoviesRequest(page: page)
        let task = RepositoryTask()
        let endpoint = APIEndpoints.getMovies(with: request)
        task.networkTask = self.dataTransferService.request(with: endpoint) { result in
            switch result {
            case .success(let responseDTO):
                completion(.success(responseDTO.toDomain()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        return task
    }
}
