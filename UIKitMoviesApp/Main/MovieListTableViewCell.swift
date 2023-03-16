//
//  MovieListTableViewCell.swift
//  UIKitMoviesApp
//
//  Created by Rajab on 16/03/23.
//

import UIKit

class MovieListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieReleaseDate: UILabel!
    @IBOutlet weak var movieSummary: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }
}
