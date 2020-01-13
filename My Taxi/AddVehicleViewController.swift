//
//  AddVehicleViewController.swift
//  My Taxi
//
//  Created by mac mini on 06/01/20.
//  Copyright © 2020 mac mini. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

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

//Zubair: Decoding will fail if any of the variables defined insided VehicleInfo is nil, you can have optional variables in this case.
struct VehicleInfo: Decodable {
    let statusCode: Int?
    let msg: String?
    let status: Bool?
    let type: String?
    var data: [vehicle]?
}

struct vehicle: Decodable {
    let type: Int?
    let name: String?
    let typeForGetMakersAndModelsAPi: String?
    let capacity: Int?
}

struct VehicleMakerInfo: Decodable{
    let statusCode: Int?
    let msg: String?
    let status: Bool?
    let type: String?
    var data: [VMaker]?
}

struct VMaker: Decodable {
    let MakeId: Int?
    let MakeName: String?
    let VehicleTypeId: Int?
    let VehicleTypeName: String?
}

struct VehicleModelInfo: Decodable{
    let statusCode: Int?
    let msg: String?
    let status: Bool?
    let type: String?
    var data: [VModel]?
}

struct VModel: Decodable {
    let Make_ID: Int?
    let Make_Name: String?
    let Model_ID: Int?
    let Model_Name: String?
    let VehicleTypeId: Int?
    let VehicleTypeName: String?
}



class AddVehicleViewController: UIViewController {
    
    //Zubair: This is good. Nice to see the proper conventions for naming IBOutlets
    
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
    var vehicleTypeArray: [vehicle]?
    var makerArray: [VMaker]?
    var modelArray: [VModel]?
    
    var selectedVehicleType: vehicle?
    var selectedMaker: VMaker?
    var selectdModel: VModel?
    
    var pickerType:PickerType = .vehicletypePicker
    var CurrentToken: String?
    
    var carColors = ["Red" , "Blue" , "Silver" , "Green" , "Grey" , "White" , "Black" , "Yellow"]
    var carYear = ["1999","2000","2001","2002","2003","2004","2005","2006","2007","2008","2009","2010","2011","2012","2013","2014","2015","2016","2017","2018","2019"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ItemPicker.delegate = self
        ItemPicker.dataSource = self
        // Do any additional setup after loading the view
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDToken(completion: { (token, error) in
            self.CurrentToken = token
            print(token)
            self.fetchData(url: "vehicleTypes", forThis: .vehicletypePicker)
        })
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        showHidePickerView(false)
    }
    
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        switch pickerType {
        case .vehicletypePicker:
            selectedVehicleType = vehicleTypeArray?[ItemPicker.selectedRow(inComponent: 0)]
            txtVehicleType.text = selectedVehicleType?.name
            refreshMakerAndModel()
            if txtVehicleType.text != nil{
                guard  let vehicleType = selectedVehicleType?.typeForGetMakersAndModelsAPi else {return}
                pickerType = .makePicker
                //add fetch data method here
                let url = "vehicleMakers?type=\(vehicleType)"
                fetchData(url: url, forThis: pickerType)
            }
            
        case .makePicker:
            selectedMaker = makerArray?[ItemPicker.selectedRow(inComponent: 0)]
            txtMake.text = selectedMaker?.MakeName
            refreshModel()
            if txtMake.text != nil{
                guard let vehicleType = selectedVehicleType?.typeForGetMakersAndModelsAPi , let vehicleMakeId = selectedMaker?.MakeId else {return}
                pickerType = .modelPicker
                let url = "vehicleModels?type=\(vehicleType)&makeId=\(vehicleMakeId).0"
                fetchData(url: url , forThis: pickerType)
                
            }
            
            
        case .modelPicker:
            selectdModel = modelArray?[ItemPicker.selectedRow(inComponent: 0)]
            txtModel.text = selectdModel?.Model_Name
            
        case .colorPicker:
            txtColor.text = carColors[ItemPicker.selectedRow(inComponent: 0)]
            
        case .yearPicker:
            txtYear.text = carYear[ItemPicker.selectedRow(inComponent: 0)]
            
        default:
            break
        }
        
        showHidePickerView(false)
    }
    
    //MARK: Single Action On all Buttons
    
    @IBAction func openPickerView(_ sender: UIButton) {
        
        
        switch sender.tag {
        case 1:
            
            lblPIckerTitle.text = Names.vehicleType.rawValue
            pickerType = .vehicletypePicker
            showHidePickerView(true)
            
        case 2:
            lblPIckerTitle.text = Names.make.rawValue
            pickerType = .makePicker
            showHidePickerView(true)
            
        case 3:
            lblPIckerTitle.text = Names.model.rawValue
            showHidePickerView(true)
            
        case 4:
            lblPIckerTitle.text = Names.color.rawValue
            pickerType = .colorPicker
            showHidePickerView(true)
            
        case 5:
            lblPIckerTitle.text = Names.year.rawValue
            pickerType = .yearPicker
            showHidePickerView(true)
            
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
    
    
    func fetchData(url: String , forThis: PickerType) {
        let url = URL(string: "http://api.mevron.com/v1/user/\(url)")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        guard let tokenId = CurrentToken else { return }
        request.allHTTPHeaderFields = ["Authorization" : "\(tokenId)"]
        SVProgressHUD.show()
        let task = URLSession.shared.dataTask(with: request){
            (data , response , error) in
            if let error = error {
                self.hideLoader()
                print(error.localizedDescription)
            }
            
            guard let httpResponse = response as? HTTPURLResponse else { return }
            print(httpResponse.statusCode)
            self.hideLoader()
            
            guard let data = data else {
                print(error.debugDescription)
                return
            }
            
            switch forThis{
            case .vehicletypePicker:
                self.decodeVehicleTypedata(data: data)
                
            case .makePicker:
                self.decodeMakerData(data: data)
                
            case .modelPicker:
                self.decodeModelData(data: data)
                
            default:
                print("sorrry")
            }
            
        }
        task.resume()
    }
    
 
    func decodeVehicleTypedata(data: Data){
        do {
            let vehicleInfo = try JSONDecoder().decode(VehicleInfo.self, from: data)
            self.vehicleTypeArray = vehicleInfo.data
        } catch let error {print(error.localizedDescription)}
        DispatchQueue.main.async {
            self.ItemPicker.reloadAllComponents()
        }
    }
    
    func decodeMakerData(data: Data){
        do {
            let makerInfo = try JSONDecoder().decode(VehicleMakerInfo.self, from: data)
            self.makerArray = makerInfo.data
        } catch let error {print(error.localizedDescription)}
        DispatchQueue.main.async {
            self.ItemPicker.reloadAllComponents()
        }
    }
    
    func decodeModelData(data: Data){
        do {
            let modelInfo  = try JSONDecoder().decode(VehicleModelInfo.self, from: data)
            self.modelArray = modelInfo.data
        } catch let error {print(error.localizedDescription)}
        DispatchQueue.main.async {
            self.ItemPicker.reloadAllComponents()
        }
    }
    
    
    //    func fetchSomeData(url : String , completionHandler: @escaping (Result< Data, Error >) -> () ){
    //        let url = URL(string: "http://api.mevron.com/v1/user/\(url)")
    //        var request = URLRequest(url: url!)
    //        request.httpMethod = "GET"
    //        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    //        request.addValue("application/json", forHTTPHeaderField: "Accept")
    //        guard let tokenId = CurrentToken else { return }
    //        request.allHTTPHeaderFields = ["Authorization" : "\(tokenId)"]
    //
    //        let task = URLSession.shared.dataTask(with: request) { (data , response , error) in
    //            if let error = error{
    //                completionHandler(.failure(error))
    //            }
    //
    //            guard let data = data else {return}
    //
    //            completionHandler(.success(data))
    //
    //
    //        }
    //        task.resume()
    //    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "ResidentialAddressViewController") as! ResidentialAddressViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: refresh methods to unload the maker and model
    
    func refreshMakerAndModel(){
        makerArray?.removeAll()
        modelArray?.removeAll()
        txtMake.text = ""
        txtModel.text = ""
        selectedMaker = nil
        selectdModel = nil
    }
    
    func refreshModel() {
        modelArray?.removeAll()
        txtModel.text = ""
        selectdModel = nil
    }
    func hideLoader (){
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
    
    
    func showHidePickerView(_ show: Bool) {
        if show {
            constraintForPickerView.constant = 0
            ItemPicker.selectRow(0, inComponent: 0, animated: true)
            ItemPicker.reloadAllComponents()
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
        else {
            constraintForPickerView.constant = -viewItemPicker.frame.height
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
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
            return vehicleTypeArray?.count ?? 0
        case .makePicker:
            return makerArray?.count ?? 0
        case .modelPicker:
            return modelArray?.count ?? 0
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
            title = vehicleTypeArray?[row].name ?? ""
        case .makePicker:
            title = makerArray?[row].MakeName ?? ""
        case .modelPicker:
            title = modelArray?[row].Model_Name ?? ""
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
