//
//  ListMovie.swift
//  TestKobe
//
//  Created by Lucas Rozendo on 14/09/19.
//  Copyright © 2019 Lucas Rozendo. All rights reserved.
//

import Foundation
import EVReflection

class ListMovie: EVObject {
    var id: Int = 0
    var page:  Int = 0
    var total_results:  Int = 0
    var results = [Movie]()
}
