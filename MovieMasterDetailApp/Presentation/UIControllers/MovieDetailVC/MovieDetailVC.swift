//
//  MovieDetailVC.swift
//  MovieMasterDetailApp
//
//  Created by Muhammad Irfan Awan on 19/09/2024.
//

import UIKit

class MovieDetailVC: MMDBaseVC {
    
    @IBOutlet weak var imgBanner            : UIImageView!
    @IBOutlet weak var lblTitle             : UILabel!
    @IBOutlet weak var tableMovies          : UITableView!
    
    var selectedMovie   : MovieAttributes?
    
    var movieInfoList   : [MovieInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableMovies.register(UINib(nibName: "MovieDetailCell", bundle: nil), forCellReuseIdentifier: "MovieDetailCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadInfo()
    }
    
    func loadInfo() {
        movieInfoList.removeAll()
        
        imgBanner.setImage(with: URL(string: Constants.imageBaseURL+(selectedMovie?.poster_path ?? "")), placeholder: UIImage(named: "placeHolderImage"))
        lblTitle.text = selectedMovie?.title
        
        let releaseDate = selectedMovie?.release_date ?? "N/A"
        movieInfoList.append(MovieInfo(title: "Release Date", description: releaseDate))
        movieInfoList.append(MovieInfo(title:"Popularity", description:"\(selectedMovie?.popularity ?? 0.0)"))
        movieInfoList.append(MovieInfo(title:"Vote Averate", description:"\(selectedMovie?.vote_average ?? 0.0)"))
        movieInfoList.append(MovieInfo(title:"Total Vote", description:"\(selectedMovie?.vote_count ?? 0)"))
        movieInfoList.append(MovieInfo(title:"Overview", description:"\(selectedMovie?.overview ?? "N/A")"))
        tableMovies.reloadData()
    }


    
}


extension MovieDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movieInfoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieDetailCell", for: indexPath) as! MovieDetailCell
        
        let itemToDisplay = movieInfoList[indexPath.row]
        cell.lblTitle.text = itemToDisplay.title
        cell.lblDescription.text = itemToDisplay.description
        
        return cell
    }
    
    
}

