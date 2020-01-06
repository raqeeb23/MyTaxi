//
//  ViewController.swift
//  My Taxi
//
//  Created by mac mini on 02/01/20.
//  Copyright © 2020 mac mini. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func becomeADriverPressed(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "EnterPhoneView") as! EnterPhoneViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func gotoRiderApp(_ sender: UIButton) {
    }
    
    
}

