//
//  ViewController.swift
//  Weather
//
//  Created by Alice Krutienko on 20.01.2021.
//

import UIKit
import CoreLocation

class CitiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet var table: UITableView!
    
    private var cities = ["Kyiv", "Dnipro"]
    var models = [WeatherFModel]()
    
    var weatherForecast = WeatherForecast()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        searchTextField.delegate = self
        
//        table.register(WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = UIColor(red: 101/255.0, green: 219/255.0, blue: 226/255.0, alpha: 1.0)
        self.table.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.table.backgroundColor = .clear

        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as! WeatherTableViewCell
         
        let w = models[indexPath.row]
        
        cell.dayLabel.text = self.cities[indexPath.row]
        cell.iconImageView.image = UIImage(named: w.weather.conditionName)
        cell.highTempLabel.text = w.weather.description.capitalized
        cell.lowTempLabel.text = "\(w.weather.temperatureString)°F"
        
        cell.backgroundColor = .clear
        return cell
    }
}
    
extension CitiesViewController: UITextFieldDelegate {

        @IBAction func searchedButton(_ sender: Any) {
             searchTextField.endEditing(true)
             print(searchTextField.text!)
         }
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            searchTextField.endEditing(true)
            print(searchTextField.text!)
            return true
        }
        
        func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
            if textField.text != "" {
                return true
            }
            else {
                textField.placeholder = "Type something"
                return false
            }
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            
            if let addr = searchTextField.text {
                print(addr)
            }
            
            searchTextField.text = ""
        }
    }

extension CitiesViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherForecast.fetchWeather(latitude: lat, longitude: lon)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
    
