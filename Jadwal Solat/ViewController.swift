//
//  ViewController.swift
//  Jadwal Solat
//
//  Created by Muhammad Utsman on 5/11/19.
//  Copyright © 2019 Muhammad Utsman. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var txCity: UILabel!
    @IBOutlet weak var txSubuh: UILabel!
    @IBOutlet weak var txDzuhur: UILabel!
    @IBOutlet weak var txAsar: UILabel!
    @IBOutlet weak var txMagrib: UILabel!
    @IBOutlet weak var txIsya: UILabel!
    @IBOutlet weak var txDate: UILabel!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    let locationManager = CLLocationManager()
    let apiKeyMuslimSalat = "acec0e71bde4adaafc672805efd66a56"
    var cityName: String = "city and country"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print(location.coordinate)
        }
        
        CLGeocoder().reverseGeocodeLocation(manager.location!) { (placemarks, error) in
            if error != nil {
                print(error?.localizedDescription ?? "error")
            }
            
            if placemarks?.count ?? 0 > 0 {
                let pm = placemarks?[0]
                print(pm?.administrativeArea ?? "noting")
                
                guard let city = pm?.administrativeArea else { return }
                guard let country = pm?.country else { return }
                
                self.cityName = city + ", " + country
                
                let urlResponses = URL(string: "https://muslimsalat.com/" + city + ".json?key=" + self.apiKeyMuslimSalat)
                
                guard let baseUrl = urlResponses else { return }
                self.getApi(url: baseUrl)
            }
            
        }
        
    }
    
    func getApi(url: URL) {
        URLSession.shared.dataTask(with: url) { (data, url, error) in
            print("sukses")
            
            guard let data = data, error == nil, url != nil else {
                print("error")
                return
            }
        
            do {
                let salatResponses = try JSONDecoder().decode(MuslimSolatResponses.self, from: data)
                self.initSolat(solat: salatResponses.solat[0])
                
                
            } catch {
                print("error after network success")
            }
            
            
        }.resume()
    }

    func initSolat(solat: Salat) {
        
        let dateFormatApi = DateFormatter()
        dateFormatApi.dateFormat = "yyyy-MM-dd"
        
        let dateFormatPrint = DateFormatter()
        dateFormatPrint.dateFormat = "EEEE, dd MMM yyyy"
        dateFormatPrint.locale = Locale.init(identifier: "id-ID")
        
        DispatchQueue.main.async {
            self.txCity.text = self.cityName
            self.txSubuh.text = solat.subuh
            self.txDzuhur.text = solat.dzuhur
            self.txAsar.text = solat.ashar
            self.txMagrib.text = solat.magrib
            self.txIsya.text = solat.isya
            
            if let date = dateFormatApi.date(from: solat.date) {
                let datePrint = dateFormatPrint.string(from: date)
                self.txDate.text = datePrint
            } else {
                print("error")
                self.txDate.text = "error from api"
            }
            
            self.indicatorView.isHidden = true
        }
    }
    
    

}

