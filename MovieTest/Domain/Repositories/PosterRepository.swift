//
//  PosterRepository.swift
//  MovieTest
//
//  Created by TaiPV on 4/27/22.
//

import Foundation

protocol PosterRepository {
    @discardableResult
    func fetchImage(with imagePath: String, completion: @escaping (Result<Data, Error>) -> Void) -> Cancellable?
}
