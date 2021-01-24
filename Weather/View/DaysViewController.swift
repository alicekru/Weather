//
//  DaysController.swift
//  Weather
//
//  Created by Alice Krutienko on 24.01.2021.
//
import Foundation
import UIKit
import CoreLocation

class DaysViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var table: UITableView!
    
    let locationManager = CLLocationManager()
    var models = [WeatherFModel]()
    
    var weatherForecast = WeatherForecast()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        weatherForecast.delegate = self
        searchTextField.delegate = self
        
//        table.register(WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = UIColor(red: 101/255.0, green: 219/255.0, blue: 226/255.0, alpha: 1.0)
        self.table.reloadData()
        
    }
    
    func getDateTime(timestamp: Int) -> String {
        var strDate = "undefined"
            

        let date = Date(timeIntervalSince1970: Double(timestamp))
        let dateFormatter = DateFormatter()
        let timezone = TimeZone.current.abbreviation() ?? "CET"  // get current TimeZone abbreviation or set to CET
        dateFormatter.timeZone = TimeZone(abbreviation: timezone) //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "MM/dd" //Specify your format that you want
        strDate = dateFormatter.string(from: date)
            
        return strDate
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.table.backgroundColor = .clear

        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as! WeatherTableViewCell
        
        let w = models[indexPath.row]
        
        cell.dayLabel.text = self.getDateTime(timestamp: w.dateTime)
        cell.iconImageView.image = UIImage(named: w.weather.conditionName)
        cell.highTempLabel.text = w.weather.description.capitalized
        cell.lowTempLabel.text = "\(w.weather.temperatureString)°F"
        
        cell.backgroundColor = .clear
        return cell
    }
}
    

extension DaysViewController: UITextFieldDelegate {

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
                weatherForecast.fetchWeather(addr: addr)
                //print(city)
            }
            
            searchTextField.text = ""
        }
    }


extension DaysViewController: WeatherForecastDelegate {

    func didUpdateWeather(_ weatherForecast: WeatherForecast, weathers: [WeatherFModel]) {
        self.models = weathers
        DispatchQueue.main.async {
            self.table.reloadData()
            self.cityName.text = weathers[0].cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }

}

extension DaysViewController: CLLocationManagerDelegate {
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
