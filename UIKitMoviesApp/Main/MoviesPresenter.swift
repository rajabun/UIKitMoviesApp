//
//  MoviesPresenter.swift
//  UIKitMoviesApp
//
//  Created by Rajab on 14/03/23.
//

final class MoviesPresenter: MoviesPresenterProtocol {
    
    weak var view: MoviesViewProtocol?
    internal var interactor: MoviesInteractorInputProtocol?
    internal var router: MoviesRouterProtocol?
    
    init(_ router: MoviesRouterProtocol, _ interactor: MoviesInteractorInputProtocol) {
        self.router = router
        self.interactor = interactor
        
        interactor.presenter = self
    }
    
    func viewDidLoad() {
        interactor?.getMovieList(page: 1)
    }
    
    func showDetails(viewSent: MoviesVC, movieSent: MovieList) {
        router?.navigateToReviewScreen(view: viewSent, selectedMovie: movieSent)
    }
    
    func sendPage(pageSent: Int) {
        interactor?.getMovieList(page: pageSent)
    }
    
    func sendGenreId(idSent: Int) {
        interactor?.filterResults(genreId: idSent)
    }
}

extension MoviesPresenter: MoviesInteractorOutputProtocol {
    func loadMovieListFinished(_ listResult: [MovieList]) {
        view?.updateListData(listResult: listResult)
    }
    
    func loadMovieGenreFinished(_ genreResult: [MovieGenre]) {
        view?.updateGenreData(genreResult: genreResult)
    }
    
    func loadOnError() {
        view?.showError()
    }
}
