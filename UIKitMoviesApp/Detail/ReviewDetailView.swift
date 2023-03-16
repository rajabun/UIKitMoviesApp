//
//  ContentView.swift
//  SwiftUIMoviesApp
//
//  Created by Rajab on 08/03/23.
//

import SwiftUI

struct ReviewDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewDetailView()
    }
}

struct ReviewDetailView: View {
    @StateObject var obs = ReviewViewModel()
    var viewModel: MovieList?
    var dismissAction: (() -> Void) = {
        NotificationCenter.default.post(name: NSNotification.Name("dismissSwiftUI"), object: nil)
    }
    
    var body: some View {
        if let vm = viewModel {
            ScrollView(.vertical)
            {
                Button(action: dismissAction ) {
                    Text("Done")
                }
                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(vm.backdrop_path)"))
                { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFit()
                        // Displays the loaded image.
                    } else {
                        ProgressView()
                        // Acts as a placeholder.
                    }
                }
                Text(vm.title).fontWeight(.heavy)
                HStack {
                    Text(vm.release_date)
                    Image(systemName: "star")
                        .foregroundColor(Color.yellow)
                    Text(String(format: "%.1f", vm.vote_average))
                }
                Spacer()
                Text(viewModel?.overview ?? "No overview yet")
                Spacer()
                if obs.moviesReviewList.isEmpty {
                    Text("There are no reviews for this film yet")
                } else {
                    Text("Review").fontWeight(.heavy)
                        .padding(.top, 16.0)
                }
                ForEach(obs.moviesReviewList)
                { review in
                    HStack {
                        AsyncImage(url: URL(string: "\(review.author_details.avatar_path?.dropFirst() ?? "")"))
                        { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                // Displays the loaded image.
                            } else {
                                Image(systemName: "star")
                                // Acts as a placeholder.
                            }
                        }
                        Text(review.author_details.username ?? "-")
                    }
//                    Spacer()
                    Text(review.content)
                }
                .padding(.all)
            }
            .padding(.all)
            .navigationBarTitle("Review")
            .onAppear { //Router
                obs.getMovieReviews(movieId: "\(vm.id)", page: "1")
            }
        }
    }
}
