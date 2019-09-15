//
//  ListMovieTableViewCell.swift
//  TestKobe
//
//  Created by Lucas Rozendo on 14/09/19.
//  Copyright © 2019 Lucas Rozendo. All rights reserved.
//

import UIKit

class ListMovieTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var posterImage: UIImageView!
    
    @IBOutlet weak var titleMovie: UILabel!
    
    @IBOutlet weak var releaseDate: UILabel!
   
    @IBOutlet weak var GenresMovie: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
