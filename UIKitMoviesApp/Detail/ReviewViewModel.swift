//
//  ReviewViewModel.swift
//  UIKitMoviesApp
//
//  Created by Rajab on 16/03/23.
//

import Foundation

class ReviewViewModel: ObservableObject {
    @Published var moviesReviewList = [MovieReview]()
    private var currentPage = 1
    private var movieReviewUrl = "https://api.themoviedb.org/3/movie/"
    
    func getMovieReviews(movieId: String, page: String) {
        movieReviewUrl = movieReviewUrl + movieId + "/reviews?api_key=1d7d9a8ddce6212c0d9ab76119aa9893&language=en-US&page=" + "\(currentPage)"
        let sess = URLSession(configuration: .default)
        guard let reviewUrl = URL(string: movieReviewUrl) else { return }
        
        sess.dataTask(with: reviewUrl)
        { (data, _, _) in
            guard let fetchedData = data else { return }
            do {
                let fetch = try JSONDecoder().decode(ReviewType.self, from: fetchedData)
                DispatchQueue.main.async {
                    guard let result = fetch.results else { return }
                    
                    if self.moviesReviewList.isEmpty {
                        self.moviesReviewList = result
                    } else if self.moviesReviewList.last?.id != result.last?.id {
                        self.moviesReviewList.append(contentsOf: result)
                    }
                }
            } catch {
                print("ISI ERROR MOVIE REVIEW =", error)
            }
        }.resume()
    }
}
