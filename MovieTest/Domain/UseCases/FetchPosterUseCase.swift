//
//  FetchPosterUseCase.swift
//  MovieTest
//
//  Created by TaiPV on 4/27/22.
//

import Foundation

protocol FetchPosterUseCase {
    func execute(requestValue: FetchPosterUseCaseRequestValue, completion: @escaping (Result<Data, Error>) -> Void) -> Cancellable?
}

class DefaultFetchPosterUseCase: FetchPosterUseCase {
    private let posterRepository: PosterRepository
    
    init(posterRepository: PosterRepository) {
        self.posterRepository = posterRepository
    }
    
    func execute(requestValue: FetchPosterUseCaseRequestValue, completion: @escaping (Result<Data, Error>) -> Void) -> Cancellable? {
        return posterRepository.fetchImage(with: requestValue.path) { result in
            completion(result)
        }
    }
    
    
}

struct FetchPosterUseCaseRequestValue {
    let path: String
}
