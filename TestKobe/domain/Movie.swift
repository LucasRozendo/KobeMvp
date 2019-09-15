//
//  Movie.swift
//  TestKobe
//
//  Created by Lucas Rozendo on 14/09/19.
//  Copyright © 2019 Lucas Rozendo. All rights reserved.
//

import Foundation
import EVReflection

class Movie: EVObject {
    var id: Int = 0
    var title:  String = ""
    var poster_path:   String = ""
    var release_date:   String = ""
    var genre_ids: [Int] = []
    var overview:   String = ""
}
