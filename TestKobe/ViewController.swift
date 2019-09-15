//
//  ViewController.swift
//  TestKobe
//
//  Created by Lucas Rozendo on 13/09/19.
//  Copyright © 2019 Lucas Rozendo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func entryMoviesList(_ sender: Any) {
        self.performSegue(withIdentifier: "ListMoviesLink", sender: self)
    }
    
}

