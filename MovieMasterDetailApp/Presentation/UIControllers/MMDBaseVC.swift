//
//  MMDBaseVC.swift
//  MovieMasterDetailApp
//
//  Created by Muhammad Irfan Awan on 19/09/2024.
//

import UIKit
import Foundation

class MMDBaseVC: UIViewController {
    
    @IBOutlet weak var btnSHowTrailer       : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //MARK: - generic functions
    
    func showAlert(withTitle title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - IBActions
    @IBAction func backPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
