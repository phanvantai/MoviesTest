//
//  RepositoryTask.swift
//  MovieTest
//
//  Created by TaiPV on 4/27/22.
//

import Foundation

class RepositoryTask: Cancellable {
    var networkTask: NetworkCancellable?
    var isCancelled: Bool = false
    
    func cancel() {
        networkTask?.cancel()
        isCancelled = true
    }
}
