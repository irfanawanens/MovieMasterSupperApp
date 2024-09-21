//
//  MoviesListingVC.swift
//  MovieMasterDetailApp
//
//  Created by Muhammad Irfan Awan on 19/09/2024.
//

import UIKit

class MoviesListingVC: MMDBaseVC {
    
    @IBOutlet weak var tableMovies        : UITableView!
    
    var listMovies:[MovieAttributes]?
    
    let viewModel = MoviesDIContainer().movieLitingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableMovies.register(UINib(nibName: "MovieListingCell", bundle: nil), forCellReuseIdentifier: "MovieListingCell")
        tableMovies.register(UINib(nibName: "NoVideoCell", bundle: nil), forCellReuseIdentifier: "NoVideoCell")
        
        
        bind(to: viewModel)
        viewModel.getPopularMovies()
    }
    
    private func bind(to viewModel: MovieLitingViewModel) {
//        self.hideAnimatedActivityIndicatorView()
        viewModel.responseData.observe = { [weak self] response in
            self?.updatedResponse(response: response)
        }
        viewModel.errorMessage.observe =  { [weak self] error in
            self?.showAlert(withTitle: "Alert", message: error?.description ?? "no data found")
            print(error as Any)
        }
    }
    private func updatedResponse(response: MoviesListResponse){
//        self.hideAnimatedActivityIndicatorView()
        print(response)
        listMovies = response.results
        tableMovies.reloadData()
    }
}


extension MoviesListingVC: UITableViewDelegate, UITableViewDataSource {

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listMovies?.count ?? 0
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        if listMovies?.isEmpty == true {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoVideoCell", for: indexPath) as! NoVideoCell
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MovieListingCell", for: indexPath) as! MovieListingCell
            let itemToDisplay = listMovies?[indexPath.row]
            cell.lblTitle.text = itemToDisplay?.title
            cell.lblReleaseDate.text = "Release Date:\(itemToDisplay?.release_date ?? "N/A")"
            cell.imgBanner.setImage(with: URL(string: Constants.imageBaseURL+(itemToDisplay?.poster_path ?? "")), placeholder: UIImage(named: "placeHolderImage"))
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if listMovies?.isEmpty == false {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let movieDetailVC = storyboard.instantiateViewController(withIdentifier: "MovieDetailVC") as? MovieDetailVC {
                movieDetailVC.selectedMovie = listMovies?[indexPath.row]
                tableView.deselectRow(at: indexPath, animated: true)
                self.navigationController?.pushViewController(movieDetailVC, animated: true)
            }
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
