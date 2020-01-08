//
//  AddVehicleViewController.swift
//  My Taxi
//
//  Created by mac mini on 06/01/20.
//  Copyright © 2020 mac mini. All rights reserved.
//

import UIKit
import Firebase


enum Names: String {
    case vehicleType = "Vehicle Type"
    case make = "Make"
    case model = "Model"
    case color = "Color"
    case year = "Year"
}

enum PickerType{
    case vehicletypePicker
    case makePicker
    case modelPicker
    case colorPicker
    case yearPicker
    case state
    case city
}

struct VehicleInfo: Decodable {
    let statusCode: Int?
    let msg: String?
    let status: Bool?
    let type: String?
    var data: [vehicle]
}

struct vehicle: Decodable {
    let type: Int?
    let name: String?
    let typeForGetMakersAndModelAPi: String?
    let capacity: Int?
}

class AddVehicleViewController: UIViewController {
    
    
    @IBOutlet weak var txtVehicleType: myTaxiBasicTextfield!
    @IBOutlet weak var txtMake: myTaxiBasicTextfield!
    @IBOutlet weak var txtModel: myTaxiBasicTextfield!
    @IBOutlet weak var txtColor: myTaxiBasicTextfield!
    @IBOutlet weak var txtYear: myTaxiBasicTextfield!
    
    @IBOutlet weak var btnVehicleType: UIButton!
    @IBOutlet weak var btnMake: UIButton!
    @IBOutlet weak var btnModel: UIButton!
    @IBOutlet weak var btnColor: UIButton!
    @IBOutlet weak var btnYear: UIButton!
    
    
    
    @IBOutlet weak var viewItemPicker: UIView!
    @IBOutlet weak var lblPIckerTitle: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var ItemPicker: UIPickerView!
    
    @IBOutlet weak var constraintForPickerView: NSLayoutConstraint!
    
    
    var tempArray: [[String : Any]]?
    var vehicleInfo: VehicleInfo?
    var pickerType:PickerType = .vehicletypePicker
    var CurrentToken: String?
    
    var carColors = ["Red" , "Blue" , "Silver" , "Green" , "Grey" , "White" , "Black" , "Yellow"]
    var carYear = ["1999","2000","2001","2002","2003","2004","2005","2006","2007","2008","2009","2010","2011","2012","2013","2014","2015","2016","2017","2018","2019"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ItemPicker.delegate = self
        ItemPicker.dataSource = self
        
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        constraintForPickerView.constant = -500
        UIView.animate(withDuration: 0.4, delay: 0 , options: .curveEaseOut , animations: {self.view.layoutIfNeeded()} , completion: nil)
    }
    
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        
        //txtVehicleType.text = vehicleInfo?.data[ItemPicker.selectedRow(inComponent: 0)].name
        
        
        switch lblPIckerTitle.text {
        
        case Names.vehicleType.rawValue:
            txtVehicleType.text = vehicleInfo?.data[ItemPicker.selectedRow(inComponent: 0)].name
        
        case Names.make.rawValue:
            txtMake.text = "demo text"
            
        case Names.model.rawValue:
            txtModel.text = "demo text"
            
        case Names.color.rawValue:
            txtColor.text = carColors[ItemPicker.selectedRow(inComponent: 0)]
         
        case Names.year.rawValue:
            txtYear.text = carYear[ItemPicker.selectedRow(inComponent: 0)]
            
            
        default:
            break
        }
        
        
        constraintForPickerView.constant = -500
        UIView.animate(withDuration: 0.4, delay: 0 , options: .curveEaseOut , animations: {self.view.layoutIfNeeded()} , completion: nil)
    }
    
    
    //MARK: Single Action On all Buttons
    
    @IBAction func openPickerView(_ sender: UIButton) {
        
        switch sender {
        case btnVehicleType:
            lblPIckerTitle.text = Names.vehicleType.rawValue
            pickerType = .vehicletypePicker
            self.fetchData(url: "vehicleTypes" , button: sender)
            constraintForPickerView.constant = 0
            UIView.animate(withDuration: 0.4, delay: 0 , options: .curveEaseOut , animations: {self.view.layoutIfNeeded()} , completion: nil)
            
        case btnMake:
            lblPIckerTitle.text = Names.make.rawValue
            pickerType = .makePicker
            //add fetch data method here
            ItemPicker.reloadAllComponents()
            constraintForPickerView.constant = 0
            UIView.animate(withDuration: 0.4, delay: 0 , options: .curveEaseOut , animations: {self.view.layoutIfNeeded()} , completion: nil)
            
        case btnModel:
            
            lblPIckerTitle.text = Names.model.rawValue
            pickerType = .modelPicker
            ItemPicker.reloadAllComponents()
            // add fetch data method here
            constraintForPickerView.constant = 0
            UIView.animate(withDuration: 0.4, delay: 0 , options: .curveEaseOut , animations: {self.view.layoutIfNeeded()} , completion: nil)
            
        case btnColor:
            lblPIckerTitle.text = Names.color.rawValue
            pickerType = .colorPicker
            ItemPicker.reloadAllComponents()
            constraintForPickerView.constant = 0
            UIView.animate(withDuration: 0.4, delay: 0 , options: .curveEaseOut , animations: {self.view.layoutIfNeeded()} , completion: nil)
            
        case btnYear:
            lblPIckerTitle.text = Names.year.rawValue
            pickerType = .yearPicker
            ItemPicker.reloadAllComponents()
            constraintForPickerView.constant = 0
            UIView.animate(withDuration: 0.4, delay: 0 , options: .curveEaseOut , animations: {self.view.layoutIfNeeded()} , completion: nil)
            
        default:
            break
        }
        
    }

    
    //MARK: Method To get Token
    
    func getToken(){
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDToken(completion: { (token, error) in
            self.CurrentToken = token
            print(token)
        })
    }
    
    //MARK: Method To fetch Data from api
    
    func fetchData(url: String , button: UIButton) {
        getToken()
        let url = URL(string: "http://api.mevron.com/v1/user/\(url)")
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
            print(httpResponse.statusCode)
            
            guard let data = data else {
                print(error.debugDescription)
                return
            }
            
            switch button {
            case self.btnVehicleType:
                do {
                    self.vehicleInfo = try JSONDecoder().decode(VehicleInfo.self, from: data)
                    //print(self.vehicleInfo)
                } catch let error {print(error.localizedDescription)}
               
                DispatchQueue.main.async {
                    self.ItemPicker.reloadAllComponents()
                }
                
            case self.btnMake:
                do {
                    self.vehicleInfo?.data.removeAll()
                    self.vehicleInfo = try JSONDecoder().decode(VehicleInfo.self, from: data)
                     
                } catch let error {print(error.localizedDescription)}
                
                
                
                DispatchQueue.main.async {
                    self.ItemPicker.reloadAllComponents()
                }
                
            case self.btnModel:
                do {
                    self.vehicleInfo = try JSONDecoder().decode(VehicleInfo.self, from: data)
                   
                } catch let error {print(error.localizedDescription)}
                
                
                
                DispatchQueue.main.async {
                    self.ItemPicker.reloadAllComponents()
                }
            default:
                break
                
            }
        }
        task.resume()
    }
    
    
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "ResidentialAddressViewController") as! ResidentialAddressViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension AddVehicleViewController: UIPickerViewDelegate{
    
}

extension AddVehicleViewController: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch pickerType {
            
        case .vehicletypePicker:
            return vehicleInfo?.data.count ?? 0
        case .makePicker:
            return 1
        case .modelPicker:
            return 1
        case .colorPicker:
            return carColors.count
        case .yearPicker:
            return carYear.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var title = ""
        
        switch pickerType {
            
        case .vehicletypePicker:
            title = vehicleInfo?.data[row].name ?? ""
        case .makePicker:
            title = "data not found"
        case .modelPicker:
            title = "data not found"
        case .colorPicker:
            title = carColors[row]
        case .yearPicker:
            title = carYear[row]
        default:
            return title
        }
        return title
    }
}
