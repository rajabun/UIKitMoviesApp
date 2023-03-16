//
//  MoviesRouter.swift
//  UIKitMoviesApp
//
//  Created by Rajab on 14/03/23.
//

import UIKit

final class MoviesRouter: MoviesRouterProtocol {
    var view: MoviesViewProtocol?
    
    static func createModule() -> MoviesVC {
        let router = MoviesRouter()
        let interactor = MoviesInteractor()
        let presenter = MoviesPresenter(router,interactor)
        let destinationVC = MoviesVC(presenter: presenter)
        
        presenter.view = destinationVC
        router.view = destinationVC
        return destinationVC
    }
    
    func navigateToReviewScreen(view: MoviesVC, selectedMovie: MovieList) {
        view.addReviewDetailView(selectedMovies: selectedMovie)
    }
}
