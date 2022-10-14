//
//  QRCodeViewController.swift
//  QRCodeApp
//
//  Created by Mallesha Holeyache 14/10/2020.
//

import UIKit

class QRCodeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - Navigation
    
    @IBAction func unwindToHomeScreen(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
}
