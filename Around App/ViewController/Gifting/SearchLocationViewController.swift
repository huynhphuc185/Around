//
//  SearchLocationViewController.swift
//  Around
//
//  Created by phuc.huynh on 12/27/16.
//  Copyright © 2016 phuc.huynh. All rights reserved.
//


import UIKit
import GoogleMaps
import GooglePlaces

class SearchLocationViewController: StatusBarWithSearchBarViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var txtSearch: UITextField!
    var resultsArray = [Address]()
    var flagPickupDelivery : Bool?
    let placeClient = GMSPlacesClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtSearch.layer.borderColor = UIColor(hex: colorXam).cgColor
        txtSearch.layer.borderWidth = 1
        txtSearch.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        txtSearch.becomeFirstResponder()
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.leftSearchBarButtonItem = UIBarButtonItem(image: UIImage(named: "back x2"), style: .plain, target: self, action: #selector(self.backAction))
        navigationItem.leftBarButtonItem = leftSearchBarButtonItem
        
        // Do any additional setup after loading the view.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblView.dequeueReusableCell(withIdentifier: "deliveryCell") as! DeliveryTableViewCell
        cell.lblTitle.text = self.resultsArray[(indexPath as NSIndexPath).row].name
        cell.lbldetail.text = self.resultsArray[(indexPath as NSIndexPath).row].street
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showProgressHub()
        txtSearch.resignFirstResponder()
        txtSearch.text = self.resultsArray[(indexPath as NSIndexPath).row].fullAddress
        if flagPickupDelivery == true
        {
            
            for item in (self.navigationController?.viewControllers.enumerated())!
            {
                if let vc = item.element as? CartViewController
                {
                    
                    placeClient.lookUpPlaceID(self.resultsArray[(indexPath as NSIndexPath).row].placeID, callback: { (place, err) -> Void in
                        if let error = err {
                            print("lookup place id query error: \(error.localizedDescription)")
                            return
                        }
                        
                        if let place = place {
                            let placeGifting = GiftingLocation(longitude: place.coordinate.longitude, latitude: place.coordinate.latitude, address: self.resultsArray[(indexPath as NSIndexPath).row].fullAddress , placeid: self.resultsArray[(indexPath as NSIndexPath).row].placeID)
                            if vc.cartObj.locations.count == 0
                            {
                                vc.cartObj.locations.append(placeGifting)
                            }
                            else
                            {
                                vc.cartObj.locations[0] = placeGifting
                            }
                            
                            
                            self.navigationController?.popViewController(animated: true)
                        } else {
                        }
                        
                    })
                    
                    break
                }
                
            }
            
            
        }
        else{
            for item in (self.navigationController?.viewControllers.enumerated())!
            {
                if let vc = item.element as? CartViewController
                {
                    placeClient.lookUpPlaceID(self.resultsArray[(indexPath as NSIndexPath).row].placeID, callback: { (place, err) -> Void in
                        if let error = err {
                            print("lookup place id query error: \(error.localizedDescription)")
                            return
                        }
                        if let place = place {
                            let placeGifting = GiftingLocation(longitude: place.coordinate.longitude, latitude: place.coordinate.latitude, address: self.resultsArray[(indexPath as NSIndexPath).row].fullAddress , placeid: self.resultsArray[(indexPath as NSIndexPath).row].placeID)
                            vc.cartObj.locations[1] = placeGifting
                            self.navigationController?.popViewController(animated: true)
                        } else {
                        }
                        
                    })
                    break
                    
                }
                
            }
            
        }
        
        
    }
    func textFieldDidChange(_ textField: UITextField) {
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        filter.country = "VN"
        let lat = 10.779784
        let long = 106.698995
        let offset = 200.0 / 1000.0;
        let latMax = lat + offset;
        let latMin = lat - offset;
        let lngOffset = offset * cos(lat * .pi / 200.0);
        let lngMax = long + lngOffset;
        let lngMin = long - lngOffset;
        let initialLocation = CLLocationCoordinate2D(latitude: latMax, longitude: lngMax)
        let otherLocation = CLLocationCoordinate2D(latitude: latMin, longitude: lngMin)
        let bounds = GMSCoordinateBounds(coordinate: initialLocation, coordinate: otherLocation)
        placeClient.autocompleteQuery(textField.text!, bounds: bounds, filter: filter) { (results) -> Void in
            self.resultsArray.removeAll()
            if results.0 == nil {
                return
            }
            for result in results.0! {
                let objAddress = Address()
                objAddress.name = result.attributedPrimaryText.string
                objAddress.street = result.attributedSecondaryText!.string
                objAddress.fullAddress = result.attributedFullText.string
                objAddress.placeID = result.placeID!
                self.resultsArray.append(objAddress)
                
            }
            self.tblView.reloadData()
        }
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
