//
//  MoviesListViewController.swift
//  TestKobe
//
//  Created by Lucas Rozendo on 13/09/19.
//  Copyright © 2019 Lucas Rozendo. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

/*
 UIImage Extended to resize image size
 
 @param newWidth - width of the image to be resized
 */
extension UIImage {
    func resizeImage(newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

class MoviesListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate {

    @IBOutlet weak var listMoviesTableView: UITableView!
    @IBOutlet weak var seachMovies: UISearchBar!
    
    private let viewCarrega = ViewControllerUtils()
    private var listGenres:ListGenres = ListGenres()
    private var movies = [Movie]()
    private var selectedRow: Int = -1
    private var selectedPage: Int = 0
    private var selectedList: Int = 0
    
    private var fetchingMore: Bool = false;
    private var searching: Bool = false;
    
    let restClient = RestClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listMoviesTableView.backgroundColor = .clear
        listMoviesTableView.layer.borderWidth = 1
        
        do{
            try getGenres()
        } catch {
             messageAlert(titleAlert: "Alert", messageAlert: "Error fetching genres",actionButtonText: "OK")
        }
        
        do{
            try getMovies(page: selectedPage,listId: selectedList)
        } catch {
             messageAlert(titleAlert: "Alert", messageAlert: "Error fetching movies",actionButtonText: "OK")
        }
        
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MovieView" {
            let navigation = segue.destination as! UINavigationController
            let addEventViewController = navigation.topViewController as! MovieViewController
            
            addEventViewController.movie = self.movies[selectedRow]
            
        }
    }
 
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.movies.count)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRow = indexPath.row
        self.performSegue(withIdentifier: "MovieView", sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("ListMovieTableViewCell", owner: self, options: nil)?.first as! ListMovieTableViewCell
        
        let urlPoster = URL(string: "https://image.tmdb.org/t/p/w500/"+self.movies[indexPath.row].poster_path)
        
        let placeholderImage = UIImage(named: "kobe")!
        let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
            size: CGSize(width: 100.0, height: 100.0),
            radius: 20.0
        )
        
        cell.posterImage.af_setImage(
            withURL: urlPoster!,
            placeholderImage: placeholderImage,
            filter: filter,
            imageTransition: .crossDissolve(0.2)
        )
        
        var genres:String = ""
        for (_, value) in self.movies[indexPath.row].genre_ids.enumerated()
        {
            if let genre = self.listGenres.genres.first(where: {$0.id == value}) {
                genres += genre.name+", "
            }
        }
        
        cell.GenresMovie.text = genres;
        
        cell.titleMovie.text = self.movies[indexPath.row].title
        cell.releaseDate.text = self.movies[indexPath.row].release_date
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if (offsetY > contentHeight - scrollView.frame.height ){
            if !fetchingMore && !searching {
                beginBatchFetch()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 144
    }
    
    // MARK: - SearchBar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != "" {
            do{
                try searchMovie(nameMovie: searchBar.text ?? "")
            } catch {
                messageAlert(titleAlert: "Alert", messageAlert: "Error fetching movies",actionButtonText: "OK")
            }
            
        }else{
            messageAlert(titleAlert: "Alert", messageAlert: "Please enter the name of the movie.",actionButtonText: "OK")
        }
       
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if  searchBar.text != "" {
            selectedPage = 0
            selectedList = 0
            searching = false
            searchBar.text = ""
            movies.removeAll()
            do{
                try getMovies(page: selectedPage,listId: selectedList)
            } catch {
                messageAlert(titleAlert: "Alert", messageAlert: "Error fetching movies",actionButtonText: "OK")
            }
            
        }
       
    }
    
    
    
    // MARK: - InfinitScroll
    func beginBatchFetch(){
        fetchingMore = true
        
        do{
            try  getMovies(page: selectedPage,listId: selectedList)
        } catch {
            messageAlert(titleAlert: "Alert", messageAlert: "Error fetching movies",actionButtonText: "OK")
        }
       
    }
    
    // MARK: - Load Movies
    /*
     Take the movies
     
     @param page - indicates the page to search
     @param listId - indicates the id of list to search
     */
    func getMovies(page: Int,listId: Int) throws{
        
        viewCarrega.showActivityIndicator(uiView: self.view)
        let parametersMovies: Parameters = ["page": String(page+1),"api_key": restClient.apiKey,"sort_by": "release_date.desc","language":"en-US"]
        
        RestClient.execTaskSend(urlString: "/4/list/"+String(listId+1)+"?", param: parametersMovies, method: .get) { (ok, jsonMoviesReturn) in
            
            if (ok == true){
                var listMovie:ListMovie = ListMovie()
                listMovie = (ListMovie)(json: jsonMoviesReturn)
                if(listMovie.results.count > 0){
                    self.movies.append(contentsOf: listMovie.results)
                    self.selectedPage += 1
                }else{
                    self.selectedPage = 0
                    self.selectedList += 1
                }
                
            }
            DispatchQueue.main.async {
                
                self.fetchingMore = false
                self.listMoviesTableView.reloadData()
                self.viewCarrega.hideActivityIndicator(uiView: self.view)
            }
        }
    }
    
    // MARK: - Load Genres
    /*
     Take the genres
     */
    func getGenres() throws {
        viewCarrega.showActivityIndicator(uiView: self.view)
        let parametersGenres: Parameters = ["api_key": restClient.apiKey,"language":"en-US"]
        RestClient.execTaskSend(urlString: "/3/genre/movie/list?", param: parametersGenres, method: .get) { (boolReturnDados, jsonGenresReturn) in
            
            if (boolReturnDados == true){
                self.listGenres = (ListGenres)(json: jsonGenresReturn)
            }
            DispatchQueue.main.async {
                self.viewCarrega.hideActivityIndicator(uiView: self.view)
            }
        }
    }
    
    // MARK: - Seach Movies
    /*
     Search for a video by name
     
     @param nameMovie - name to be searched
     */
    func searchMovie(nameMovie: String) throws{
        viewCarrega.showActivityIndicator(uiView: self.view)
        searching = true
        movies.removeAll()
        
        let parametersMovies: Parameters = ["api_key": restClient.apiKey,"query": nameMovie,"language":"en-US"]
        RestClient.execTaskSend(urlString: "/3/search/movie?", param: parametersMovies, method: .get) { (boolReturnDados, jsonMoviesReturn) in
            
            if (boolReturnDados == true){
                var listMovie:ListMovie = ListMovie()
                listMovie = (ListMovie)(json: jsonMoviesReturn)
                if(listMovie.results.count > 0){
                    self.movies.append(contentsOf: listMovie.results)
                }else{
                    self.messageAlert(titleAlert: "Alert", messageAlert: "No movies found",actionButtonText: "OK")
                }
                
            }
            DispatchQueue.main.async {
                self.listMoviesTableView.reloadData()
                self.viewCarrega.hideActivityIndicator(uiView: self.view)
            }
        }
    }
    
    /*
     Set view alerts
     @param titleAlert - define alert title
     @param messageAlert - define alert message
     @param actionButtonText - define text alert button
     */
    func messageAlert(titleAlert: String, messageAlert: String, actionButtonText: String) {
        let alertController = UIAlertController(title: titleAlert, message: messageAlert, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: actionButtonText, style: .default)
        {
            (action:UIAlertAction!) in
            print("you have pressed OK button");
        }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
        
    }

}
