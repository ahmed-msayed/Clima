//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, UITextFieldDelegate, WeatherApiDelegate {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTxtField: UITextField!
    
    let weatherAPI = WeatherAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherAPI.delegate = self
        searchTxtField.delegate = self  //making the VC as the delegate
    }
    
    @IBAction func searchBtnPressed(_ sender: UIButton) {
        print(searchTxtField.text!)
        searchTxtField.endEditing(true) //dismiss keyboard
    }
    
    //triggered when pressing the return "go" key in the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(searchTxtField.text!)
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
            weatherAPI.performRequest(with: city)
        }
        searchTxtField.text = ""
    }
    
    
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

