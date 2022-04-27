//
//  MoviesListItemViewModel.swift
//  MovieTest
//
//  Created by TaiPV on 4/27/22.
//

import Foundation

class MoviesListItemViewModel {
    let title: String
    let releaseDate: String
    let posterImagePath: String?
    let score: Double?
    var data: Data?
    
    let fetchPosterUseCase: FetchPosterUseCase = DefaultFetchPosterUseCase(posterRepository: DefaultPosterRepository(dataTransferService: imageDataTransferService))
    
    init(movie: Movie) {
        self.title = movie.title?.uppercased() ?? ""
        self.posterImagePath = movie.posterPath
        self.score = movie.voteAverage
        if let releaseDate = movie.releaseDate {
            self.releaseDate = dateFormatter.string(from: releaseDate)
        } else {
            self.releaseDate = ""
        }
    }
    
    func fetchPoster(completion: @escaping (Data) -> Void) {
        if self.data != nil { return }
        guard let posterImagePath = posterImagePath else { return }
        
        _ = fetchPosterUseCase.execute(requestValue: FetchPosterUseCaseRequestValue(path: posterImagePath)) { [weak self] response in
            guard let self = self else { return }
            if case let .success(data) = response {
                self.data = data
                completion(data)
            }
        }
    }
}

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy"
    return dateFormatter
}()
