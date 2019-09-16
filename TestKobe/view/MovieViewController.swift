//
//  MovieViewController.swift
//  TestKobe
//
//  Created by Lucas Rozendo on 14/09/19.
//  Copyright © 2019 Lucas Rozendo. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage



class MovieViewController: UIViewController {

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var overView: UILabel!
    
    var movie: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let urlPoster = URL(string: "https://image.tmdb.org/t/p/w500/"+movie.poster_path)
        
        let placeholderImage = UIImage(named: "kobe")!
        let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
            size: CGSize(width: 100.0, height: 100.0),
            radius: 20.0
        )
        
        posterImage.af_setImage(
            withURL: urlPoster!,
            placeholderImage: placeholderImage,
            filter: filter,
            imageTransition: .crossDissolve(0.2)
        )
        
        movieTitle.text = movie.title
        releaseDate.text = movie.release_date
        overView.text = movie.overview
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
