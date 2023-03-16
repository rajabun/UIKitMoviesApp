//
//  MoviesContracts.swift
//  UIKitMoviesApp
//
//  Created by Rajab on 14/03/23.
//

//PRESENTER
protocol MoviesPresenterProtocol: AnyObject  {
    var view: MoviesViewProtocol? { get set }
    var interactor: MoviesInteractorInputProtocol? { get set }
    var router: MoviesRouterProtocol? { get set }
    
    // VIEW -> PRESENTER
    func viewDidLoad()
    func showDetails(viewSent: MoviesVC, movieSent: MovieList)
    func sendPage(pageSent: Int)
    func sendGenreId(idSent: Int)
}

enum MoviesPresenterOutputs {
    case showError(String)
    case showData
}

/*------------------------*/
//INTERACTOR
protocol MoviesInteractorInputProtocol: AnyObject {
    var presenter: MoviesInteractorOutputProtocol? { get set }
    // PRESENTER -> INTERACTOR
    func getMovieList(page: Int)
    func filterResults(genreId: Int)
}

protocol MoviesInteractorOutputProtocol: AnyObject  {
    // INTERACTOR -> PRESENTER
    func loadMovieListFinished(_ listResult: [MovieList])
    func loadMovieGenreFinished(_ genreResult: [MovieGenre])
    func loadOnError()
}

/*------------------------*/
//ROUTER
protocol MoviesRouterProtocol: AnyObject {
    var view: MoviesViewProtocol? { get set }
    
    static func createModule() -> MoviesVC
    
    // PRESENTER -> Router
    func navigateToReviewScreen(view: MoviesVC, selectedMovie: MovieList)
}

/*------------------------*/
//VIEW

protocol MoviesViewProtocol: AnyObject {
    var presenter: MoviesPresenterProtocol? { get set }
    
    // PRESENTER -> VIEW
    func updateListData(listResult: [MovieList])
    func updateGenreData(genreResult: [MovieGenre])
    func showError()
}
