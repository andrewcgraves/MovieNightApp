//
//  ResultsController.swift
//  MovieNightApp
//
//  Created by Andrew Graves on 12/14/19.
//  Copyright © 2019 Andrew Graves. All rights reserved.
//

import UIKit

class ResultsController: UITableViewController {

    var watcher1Genres: [Genre] = []
    var watcher2Genres: [Genre] = []
    
//    var movies: [Movie] = []
    
    var movies: [Movie] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    let client = MovieClient()
    let pendingOperations = PendingOperations()
    
//    var numberOfGenresReturned: Int = 0 {
//        didSet {
//            if numberOfGenresReturned >= numberOfGenresToReturn {
//                setUpTableView(withMovies: )
//
//            }
//
//        }
//    }
//    var numberOfGenresToReturn: Int = 0
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 138
        getMovies()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return movies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieCell
        
        let currentMovie = movies[indexPath.row]
        // Configure the cell...
        cell.movieTitle.text = currentMovie.title
        cell.movieImage.image = currentMovie.artwork
        
        if currentMovie.formattedReleaseDate != nil {
            cell.releaseYear.text = currentMovie.formattedReleaseDate

        } else {
            cell.releaseYear.text = currentMovie.releaseDate
        }
//        cell.releaseYear.text = currentMovie.releaseDate

        if currentMovie.artworkState == .placeholder {
            downloadArtworkForMovies(currentMovie, atIndexPath: indexPath)
        }
        
        return cell
    }

    // MARK: Helper Functions
    
    func setUpTableView(withMovies movies: [Movie]) {
        self.movies = movies
    }
    
    func prepareGenres() -> [Genre] {
        
        // getting the genres that the user selected together
        var relatedGenres = watcher1Genres.filter(watcher2Genres.contains)
        
        //printing it for clarity
        print("\n\nThere are \(relatedGenres.count) related genres")
        for genre in relatedGenres {
            print(genre.name)
        }
        
        if relatedGenres.isEmpty {
            relatedGenres.append(watcher1Genres.randomElement()!)
            relatedGenres.append(watcher2Genres.randomElement()!)
        }
        
        return relatedGenres
    }
    
    func getMovies() {
        
        let genres = prepareGenres()
        
        var genreIDs: [Int] = []
        for genre in genres {
            genreIDs.append(genre.id)
        }

        client.discover(withGenres: genreIDs, duringYear: "2019", sortedBy: .popularity) { result in
            switch result {
            case .success(let movies):
                self.setUpTableView(withMovies: movies)
            case .failure(let error):
                print("Error getting genres in Results Controller: \(error)")

            }
        }
    }
    
    func downloadArtworkForMovies(_ movie: Movie, atIndexPath indexPath: IndexPath) {
//        print("Downloading Movie Artwork... ")
        if let _ = pendingOperations.downloadsInProgress[indexPath] {
            return
        }
        
        let downloader = ArtworkDownloader(movie: movie)
        
        downloader.completionBlock = {
            if downloader.isCancelled {
                return
            }
            
            DispatchQueue.main.async {
//                print("Artwork download finished!")
                self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        
        pendingOperations.downloadsInProgress[indexPath] = downloader
        pendingOperations.downloadQueue.addOperation(downloader)
    }
    
    @IBAction func donePressed(_ sender: Any) {
        
    }
}
