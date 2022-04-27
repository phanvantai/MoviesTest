//
//  MoviesListViewModel.swift
//  MovieTest
//
//  Created by TaiPV on 4/27/22.
//

import Foundation

protocol MoviesListViewModelInput {
    func viewDidLoad(completion: @escaping () -> Void)
    func didLoadNextPage(completion: @escaping () -> Void)
    func didPullToRefesh(completion: @escaping () -> Void)
}

protocol MoviesListViewModelOutput {
    var items: Observable<[MoviesListItemViewModel]> { get }
    var error: Observable<String> { get }
}

protocol MoviesListViewModel: MoviesListViewModelInput, MoviesListViewModelOutput {}

final class DefaultMoviesListViewModel: MoviesListViewModel {
    
    private let discoverMoviesUseCase: DiscoverMoviesUseCase
    var currentPage: Int = 0
    var totalPageCount: Int = 1
    var hasMorePages: Bool { currentPage < totalPageCount }
    var nextPage: Int { hasMorePages ? currentPage + 1 : currentPage }

    private var pages: [MoviesPage] = []
    private var moviesLoadTask: Cancellable? { willSet { moviesLoadTask?.cancel() } }

    // MARK: - OUTPUT

    let items: Observable<[MoviesListItemViewModel]> = Observable([])
    let error: Observable<String> = Observable("")
    
    // MARK: - Init
    init(discoverMoviesUseCase: DiscoverMoviesUseCase) {
        self.discoverMoviesUseCase = discoverMoviesUseCase
    }

    private func appendPage(_ moviesPage: MoviesPage) {
        currentPage = moviesPage.page
        totalPageCount = moviesPage.totalPages

        pages = pages
            .filter { $0.page != moviesPage.page }
            + [moviesPage]

        items.value = pages.movies.map(MoviesListItemViewModel.init)
    }
    
    private func resetPages() {
        currentPage = 0
        totalPageCount = 1
        pages.removeAll()
        items.value.removeAll()
    }
    
    private func load(completion: @escaping () -> Void) {
        moviesLoadTask = discoverMoviesUseCase.execute(
            requestValue: .init(page: nextPage),
            completion: { result in
                switch result {
                case .success(let page):
                    self.appendPage(page)
                case .failure(let error):
                    self.handle(error: error)
                }
                completion()
        })
    }
    
    private func handle(error: Error) {
        self.error.value = error.localizedDescription
    }
}

extension DefaultMoviesListViewModel {

    func viewDidLoad(completion: @escaping () -> Void) {
        load(completion: completion)
    }

    func didLoadNextPage(completion: @escaping () -> Void) {
        guard hasMorePages else { return }
        load(completion: completion)
    }
    
    func didPullToRefesh(completion: @escaping () -> Void) {
        resetPages()
        load(completion: completion)
    }
}

// MARK: - Private

private extension Array where Element == MoviesPage {
    var movies: [Movie] { flatMap { $0.movies } }
}
