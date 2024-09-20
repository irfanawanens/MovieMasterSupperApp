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
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
