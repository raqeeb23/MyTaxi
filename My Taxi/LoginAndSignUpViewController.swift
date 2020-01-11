//
//  ViewController.swift
//  My Taxi
//
//  Created by mac mini on 02/01/20.
//  Copyright © 2020 mac mini. All rights reserved.
//

import UIKit

<<<<<<< HEAD:My Taxi/LoginAndSignUpViewController.swift
class LoginAndSignUpViewController: UIViewController {
=======
//Zubair: Make sure the the class is named according to the function it performs.
class ViewController: UIViewController {
>>>>>>> 74736164fc25f5ad436a55d57e201f7c06065286:My Taxi/ViewController.swift

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

