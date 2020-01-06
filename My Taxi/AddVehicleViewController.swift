//
//  AddVehicleViewController.swift
//  My Taxi
//
//  Created by mac mini on 06/01/20.
//  Copyright © 2020 mac mini. All rights reserved.
//

import UIKit
import Firebase

class AddVehicleViewController: UIViewController {
    
    
    @IBOutlet weak var txtVehicleType: myTaxiBasicTextfield!
    
    @IBOutlet weak var txtMake: myTaxiBasicTextfield!
    
    
    @IBOutlet weak var txtModel: myTaxiBasicTextfield!
    
    @IBOutlet weak var txtColor: myTaxiBasicTextfield!
    
    @IBOutlet weak var txtYear: myTaxiBasicTextfield!
    
    
    @IBOutlet weak var viewItemPicker: UIView!
    
    @IBOutlet weak var lblPIckerTitle: UILabel!
    
    @IBOutlet weak var btnCancel: UIButton!
    
    var CurrentToken: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func getToken(){
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDToken(completion: { (token, error) in
            self.CurrentToken = token
            print(token)
            self.fetchVehicletype()
        })
    }
    
    
    func fetchVehicletype() {
        let url = URL(string: "http://api.mevron.com/v1/user/vehicleTypes")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        guard let tokenId = CurrentToken else { return }
        request.allHTTPHeaderFields = ["Authorization" : "\(tokenId)"]
        
        let task = URLSession.shared.dataTask(with: request){
            (data , response , error) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let httpResponse = response as? HTTPURLResponse else { return }
            
            guard let data = data else {
                print(error.debugDescription)
                return
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data) as! [String : Any] {
                //print(json)
                //print(json["data"])
                
                let vehicleTypeArray = json["data"]
                print(vehicleTypeArray)
                
            }
        }
        task.resume()
    }
    
}
