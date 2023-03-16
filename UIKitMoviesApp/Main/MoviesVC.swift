//
//  MoviesVC.swift
//  UIKitMoviesApp
//
//  Created by Rajab on 14/03/23.
//

import UIKit
import SwiftUI

class MoviesVC: UIViewController {
    var presenter: MoviesPresenterProtocol?
    private var listData: [MovieList] = []
    private var genreData: [MovieGenre] = []
    private var currentPage = 1
    private var selectedGenre = 0
    let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var movieList: UITableView!
    @IBOutlet weak var genrePicker: UIPickerView!

    init(presenter: MoviesPresenterProtocol) {
        super.init(nibName: "Main", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        let router = MoviesRouter()
        let interactor = MoviesInteractor()
        let presenter = MoviesPresenter(router,interactor)
        
        self.presenter = presenter
        presenter.view = self
        router.view = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        setUI()
    }
    
    fileprivate func setUI() {
        setupTableView()
        setupPickerView()
//        setRefreshPage()
    }
    
    func setRefreshPage() {
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        movieList.refreshControl = refreshControl
    }
    
    @objc func loadData() {
        // Make network call to fetch data for currentPage
        currentPage = 1
        presenter?.sendPage(pageSent: currentPage)
        refreshControl.endRefreshing()
    }
}

extension MoviesVC: MoviesViewProtocol {
    func updateListData(listResult: [MovieList]) {
        self.listData = listResult
        self.movieList.reloadData()
    }
    
    func updateGenreData(genreResult: [MovieGenre]) {
        self.genreData = genreResult
        self.genrePicker.reloadAllComponents()
    }
    
    func showError() {
        let controller = UIAlertController(title: "ERROR", message: "Data Not Available", preferredStyle: .alert)
        DispatchQueue.main.async {
            self.present(controller, animated: true, completion: nil)
        }
    }
}

//Setup For Table View
extension MoviesVC: UITableViewDataSource, UITableViewDelegate {
    func setupTableView() {
        movieList.delegate = self
        movieList.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieListCell", for: indexPath) as? MovieListTableViewCell
        let movie = listData[indexPath.row]

        cell?.moviePoster.loadFromStringURL(stringUrl: "https://image.tmdb.org/t/p/w500\(movie.poster_path)")
        cell?.movieTitle.text = movie.title
        cell?.movieReleaseDate.text = movie.release_date
        cell?.movieSummary.text = movie.overview
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.showDetails(viewSent: self, movieSent: listData[indexPath.row])
    }
    
//successBlock: (() -> Void)
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        //Bottom Refresh
        if scrollView == movieList, ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)  {
            currentPage += 1
            presenter?.sendPage(pageSent: currentPage)
        }
    }
}

//Setup For Picker View
extension MoviesVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func setupPickerView() {
        genrePicker.delegate = self
        genrePicker.dataSource = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genreData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genreData[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedGenre = genreData[row].id
        presenter?.sendGenreId(idSent: genreData[row].id)
    }
}

extension UIImageView {
    func loadFromStringURL(stringUrl: String) {
        if let url = URL(string: stringUrl) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let imageData = data else { return }
                
                DispatchQueue.main.async {
                    self.image = UIImage(data: imageData)
                }
            }.resume()
        }
    }
}

extension MoviesVC {
    func addReviewDetailView(selectedMovies: MovieList) {
        let circleView = ReviewDetailView(viewModel: selectedMovies)
        let controller = UIHostingController(rootView: circleView)
        addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(controller.view)
        controller.didMove(toParent: self)
        NotificationCenter.default.addObserver(forName: NSNotification.Name("dismissSwiftUI"), object: nil, queue: nil) { (_) in
            controller.dismiss(animated: true, completion: nil)
            controller.view.removeFromSuperview()
        }

        NSLayoutConstraint.activate([
            controller.view.widthAnchor.constraint(equalTo: view.widthAnchor),
            controller.view.heightAnchor.constraint(equalTo: view.heightAnchor),
            controller.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            controller.view.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
