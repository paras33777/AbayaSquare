//
//  AddAddressVC.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/25/21.
//

import UIKit
import GoogleMaps
import IQKeyboardManagerSwift

protocol AddAddressDelegate {
    func didAddAddress(addressType: Int)
}

class AddAddressVC: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var mobileTF: UITextField!
    @IBOutlet var addressTypeButtons: [TapButton]!
    @IBOutlet weak var fullAddressTV: IQTextView!
    @IBOutlet weak var prifixLB: UILabel!
    @IBOutlet weak var cityButton: RightAlignedIconButton!
    
    let viewModel = AddAddressViewModel()
    var request = AddAddressModel.Request()
    let locationManager = CLLocationManager()
    var prifix = ""
    var internalAddressOrExternal = 0
    var delegate: AddAddressDelegate?
    var totalAmount = ""
    var productId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        title = "Add Address".localized
        getCities()
        setupMap()
        setupDetails()
        
    }
    
    @IBAction func didTapChangePrifix(_ sender: UIButton) {
        view.endEditing(true)
        let dropDown = showDropDownMenu(button: sender)
        dropDown.dataSource = UserDefaultsManager.config?.data?.countriesPhoneList ?? [""]
        dropDown.show()
        dropDown.selectionAction = { [self] index, item in
            prifixLB.text = item
            prifix = item
        }
    }
    
    @IBAction func didTapSelectArea(_ sender: RightAlignedIconButton) {
        view.endEditing(true)
        let dropDown = showDropDownMenu(button: sender)
        dropDown.dataSource = viewModel.govs.map { $0.name.emptyIfNull}
        dropDown.show()
        dropDown.selectionAction = { [self] index, item in
            viewModel.selectedGov = viewModel.govs[index]
            sender.setTitle(item, for: .normal)
            sender.setTitleColor(UIColor("333333"), for: .normal)
            sender.setup()
            UserDefaultsManager.isCashEnabled = 0
            cityButton.setTitle("Select City".localized, for: .normal)
            cityButton.setup()
        }
    }
    
    @IBAction func didTapSelectCity(_ sender: RightAlignedIconButton) {
        view.endEditing(true)
        guard let cities = viewModel.selectedGov?.cities else {
            MainHelper.shared.showNoticeMessage(message: "Select Area First".localized)
            return
        }
        
        let dropDown = showDropDownMenu(button: sender)
        dropDown.dataSource = cities.map {$0.name.emptyIfNull}
        dropDown.show()
        dropDown.selectionAction = { [self] index, item in
            viewModel.selectedCity = cities[index]
            sender.setTitleColor(UIColor("333333"), for: .normal)
            sender.setTitle(item, for: .normal)
            UserDefaultsManager.isCashEnabled = cities[index].isCash.zeroIfNull
            sender.setup()
        }
    }
    
    @IBAction func didTapHome(_ sender: TapButton) {
        request.type = "home"
    }
    
    @IBAction func didTapWork(_ sender: TapButton) {
        request.type = "office"
    }
    
    @IBAction func didTap(_ sender: TapButton) {
        sender.didTap()
        addressTypeButtons.forEach { $0 == sender ? $0.select() : $0.deselect() }
    }
    
    @IBAction func didTapSave(_ sender: UIButton) {
        request.name = nameTF.text.emptyIfNull
        request.mobile = "\(prifix)\(mobileTF.text.emptyIfNull)"
        request.address = fullAddressTV.text.emptyIfNull
        request.areaId = viewModel.selectedCity?.id.zeroIfNull
        request.cityId = viewModel.selectedGov?.id.zeroIfNull
        
        guard request.isValid else {
            MainHelper.shared.showErrorMessage(errors: request.errorRules)
            return
        }
        
        sender.showSpinner(spinnerColor: .black)
        print("request: \(request)")
        
        viewModel.addAddress(request: request) {result in
            switch result {
            case .success(let response): self.onSuccess(response)
            case .failure(let error): self.onFailure(error)
            }
        }
    }
}

extension AddAddressVC {
    
    func setupDetails(){
        fullAddressTV.placeholder = "Complete Address".localized
        addressTypeButtons[0].select()
        prifixLB.text = UserDefaultsManager.config?.data?.countriesPhoneList?.first
        prifix = UserDefaultsManager.config?.data?.countriesPhoneList?.first ?? ""
        guard let user = User.currentUser else {return}
        nameTF.text = user.name
        let prifix = String(user.mobile?.prefix(3) ?? "")
        let mobile = String(user.mobile?.suffix(9) ?? "")
        mobileTF.text = mobile
        prifixLB.text = prifix
    }
    
    func getCities(){
        view.showSpinner(spinnerColor: .black)
        viewModel.getCities() {result in
            switch result {
            case .success(let response): self.onSuccess(response)
            case .failure(let error): self.onFailure(error)
            }
        }
    }
    
    func onSuccess(_ reponse: CityModel.Response) {
        viewModel.govs = reponse.govs ?? []
        removeSpinner()
    }
    
    func setupMap(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        mapView.isMyLocationEnabled = true
        mapView.settings.consumesGesturesInView = true
        mapView.settings.scrollGestures = true
        mapView.settings.myLocationButton = true
        mapView.delegate = self
        mapView.settings.myLocationButton = false
        let topPadding = navigationController?.navigationBar.bounds.height ?? .zero
        mapView.padding = UIEdgeInsets(top: 12 + topPadding, left: 0, bottom: 12, right: 0)
        guard let location = locationManager.location else { return }
        mapView.animate(to: GMSCameraPosition(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 17))
    }
    
    func onSuccess(_ reponse: AddAddressModel.Response){
        removeSpinner()
        
        if let error = reponse.errors {
            MainHelper.shared.showErrorMessage(errors: error)
            return
        }
        
        if let user = reponse.customer {
            User.currentUser = user
            MainHelper.shared.showSuccessMessage(responseMessage: "Address has been added".localized)
            delegate?.didAddAddress(addressType: internalAddressOrExternal)
            navigationController?.popViewController(animated: true)
            return
        }
        MainHelper.shared.showErrorMessage(responseMessage: reponse.responseMessage.emptyIfNull)
    }
}

//MARK: - GMSMapViewDelegate:
extension AddAddressVC: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        let coordinate = mapView.projection.coordinate(for: mapView.center)
        
        request.lat = coordinate.latitude.clean
        request.lng = coordinate.longitude.clean
        
        GMSAddress.shared.getAddress(latitude: coordinate.latitude, longitude: coordinate.longitude) { [self] address in
            guard let address = address else {return}
            if let area = address.get(.areaLevel1) {
                if area == "منطقة الرياض" {
                    internalAddressOrExternal = 1
                    request.isInternal = 1
                } else {
                    internalAddressOrExternal = 0
                    request.isInternal = 0
                }
            }
            
            var addressString = ""
            
            if let locality = address.get(.locality), !locality.isEmpty {
                addressString += locality
            }
            
            if let political = address.get(.political), !political.isEmpty {
                addressString += " - " + political
            }
            
            if let sublocalityLevel1 = address.get(.sublocalityLevel1), !sublocalityLevel1.isEmpty {
                addressString += " - " + sublocalityLevel1
            }
            
            if let block = address.get(.block), !block.isEmpty {
                addressString += " - " + block
            }
            
            if let streetName = address.get(.streetName), !streetName.isEmpty {
                addressString += " - " + streetName
            }
            
            fullAddressTV.text = addressString
        }
    }
}

//MARK: - CLLocationManagerDelegate:
extension AddAddressVC: CLLocationManagerDelegate {
    @available(iOS 14.0, *)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        guard status == .authorizedAlways || status == .authorizedWhenInUse else { return }
        guard let location = locationManager.location else { return }
        mapView?.animate(to: GMSCameraPosition(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 17))
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedAlways || status == .authorizedWhenInUse else { return }
        guard let location = locationManager.location else { return }
        mapView?.animate(to: GMSCameraPosition(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 17))
    }
}
