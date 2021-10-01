//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTxtField: UITextField!
    
    let weatherAPI = WeatherAPI()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherAPI.delegate = self
        searchTxtField.delegate = self  //making the VC as the delegate
        locationManager.delegate = self
        
        locationManager.requestAlwaysAuthorization()    //ask user for permission
        //info.plist -> Information Property -> add "Privacy - location when in use"
        //and add "Privacy - Location Always and When In Use Usage Description"
        locationManager.requestLocation()
    }
}


//MARK: - UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchBtnPressed(_ sender: UIButton) {
        searchTxtField.endEditing(true) //dismiss keyboard
    }
    
    //triggered when pressing the return "go" key in the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTxtField.endEditing(true) //dismiss keyboard
        return true
    }
    
    //checks if empty don't dismiss keyboard and warn, if not, call "EndEditing()"
    //we can replace "searchTxtField" with "textField" to deal with it like "sender"
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchTxtField.text != "" {
            return true
        } else {
            searchTxtField.placeholder = "Type Something!"
            return false
        }
    }
    
    //triggered when "endEditing()" is called
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTxtField.text {
            weatherAPI.fetchWeather(with: city)
        }
        searchTxtField.text = ""
    }
}


//MARK: - WeatherApiDelegate
extension WeatherViewController: WeatherApiDelegate {
    
    func didUpdateWeather(weather: WeatherModel) {
        //        DispatchQueue.main.async {
        conditionImageView.image = UIImage(systemName: weather.conditionName)
        temperatureLabel.text = weather.tempratureString
        cityLabel.text = weather.cityName
        //        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    
    @IBAction func locationBtnPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()  //to stop fetching current location again
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherAPI.fetchWeather(longitude: lon, latitude: lat)
        }
        //Product -> Scheme -> Edit Scheme -> Options -> Allow Location Simulation must be checked and try providing a default location, don't leave it set to "none"
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
