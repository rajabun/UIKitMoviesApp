//
//  MoviesInteractor.swift
//  UIKitMoviesApp
//
//  Created by Rajab on 14/03/23.
//

import Foundation

final class MoviesInteractor: MoviesInteractorInputProtocol {
    var presenter: MoviesInteractorOutputProtocol?
    
    var filteredMoviesList = [MovieList]()
    var originalMoviesList = [MovieList]()
    var moviesList = [MovieList]()
    var moviesGenreList = [MovieGenre]()
    
    var isLoadingPage = false
    private var canLoadMorePages = true
//    private var currentPage = 1
    
    private var movieUrl = "https://api.themoviedb.org/3/movie/now_playing?api_key=1d7d9a8ddce6212c0d9ab76119aa9893&language=en-US&page="
    private var movieGenreUrl = "https://api.themoviedb.org/3/genre/movie/list?api_key=1d7d9a8ddce6212c0d9ab76119aa9893&language=en-US"
    
    func getMovieGenre() {        
        let sess = URLSession(configuration: .default)
        guard let listUrl = URL(string: movieGenreUrl) else { return }
        sess.dataTask(with: listUrl)
        { (data, _, _) in
            guard let fetchedData = data else { return }
            do {
                let fetch = try JSONDecoder().decode(GenreType.self, from: fetchedData)
                DispatchQueue.main.async {
                    self.moviesGenreList = fetch.genres
                    self.moviesGenreList.insert(MovieGenre(id: 0, name: "All"), at: 0)
                    self.presenter?.loadMovieGenreFinished(self.moviesGenreList)
                }
            } catch {
                self.presenter?.loadOnError()
            }
        }.resume()
    }
    
    func getMovieList(page: Int) {
        if page > 1 {
            movieUrl.removeLast()
        }
        movieUrl = movieUrl + "\(page)"
        let sess = URLSession(configuration: .default)
        guard let listUrl = URL(string: movieUrl) else { return }
        sess.dataTask(with: listUrl)
        { (data, _, _) in
            guard let fetchedData = data else { return }
            do {
                let fetch = try JSONDecoder().decode(MovieType.self, from: fetchedData)
                DispatchQueue.main.async
                {
                    guard let result = fetch.results else { return }
                    
                    if self.moviesList.isEmpty {
                        self.moviesList = result
                        self.originalMoviesList = result
                    } else if self.moviesList.last?.id != result.last?.id {
                        self.moviesList.append(contentsOf: result)
                        self.originalMoviesList.append(contentsOf: result)
                    }
                    self.presenter?.loadMovieListFinished(self.moviesList)
                    if page == 1 {
                        self.getMovieGenre()
                    }
                }
            } catch {
                self.presenter?.loadOnError()
            }
        }.resume()
    }
    
    func filterResults(genreId: Int) {
        filteredMoviesList.removeAll()
        for movie in originalMoviesList {
            for genre in movie.genre_ids {
                if genreId == genre {
                    filteredMoviesList.append(movie)
                }
            }
        }
        if filteredMoviesList.isEmpty {
            let emptyData = MovieList(id: 0, poster_path: "", title: "No Movie Available For This Genre", release_date: "", overview: "", backdrop_path: "", popularity: 0, vote_average: 0, vote_count: 0, genre_ids: [])
            filteredMoviesList.append(emptyData)
        }
        moviesList = filteredMoviesList
        if genreId == 0 {
            moviesList = originalMoviesList
        }
        self.presenter?.loadMovieListFinished(self.moviesList)
    }
}
