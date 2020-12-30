//
//  MovieDetailsViewController.swift
//  WamaTechnologySampleTask
//
//  Created by Mallikarjuna on 30/12/20.
//  Copyright © 2020 Mallikarjuna. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    var perticularMovieDetails:ResultsStruct!
    @IBOutlet weak var moviePosterImageview: UIImageView!
    @IBOutlet weak var movieTitleLbl: UILabel!
    @IBOutlet weak var movieReleaseLbl: UILabel!
    @IBOutlet weak var movieAverageCount: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        movieTitleLbl.text = "\(perticularMovieDetails.title!)"
        movieReleaseLbl.text = "\(perticularMovieDetails.release_date!)"
        movieAverageCount.text = "\(perticularMovieDetails.vote_average! * 10)%"
        
        if let imageString = perticularMovieDetails.poster_path,
            let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500" + imageString) {
                URLSession.shared.dataTask(with: imageUrl) { (data, connection, error) in
                    DispatchQueue.main.async {
                        if let imageData = data {
                            self.moviePosterImageview.image = UIImage(data: imageData)
                        }
                    }
                }.resume()
            }
    }
}
