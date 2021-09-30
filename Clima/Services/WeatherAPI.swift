//
//  WeatherAPI.swift
//  Clima
//
//  Created by Ahmed Sayed on 25/09/2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import Alamofire

class WeatherAPI {
    
    var delegate: WeatherApiDelegate?
    
    func performRequest(with cityName: String) {    //cool ext. parameter
        let urlString = "https://api.openweathermap.org/data/2.5/weather?appid=\(Constants.API_KEY)&units=metric&q=\(cityName)"
        
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { data, response, error in
            
            guard error == nil else {
                //debugPrint(error.debugDescription)
                self.delegate?.didFailWithError(error: error!)
                return
            }
            
            guard let data = data else { return }
            DispatchQueue.main.async {
                if let weather = self.parseJSON(data) {
                    self.delegate?.didUpdateWeather(weather: weather)
                }
            }
            
        }
        task.resume()
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let id = decodedData.weather[0].id
            let name = decodedData.name
            let temp = decodedData.main.temp
            
            let weather = WeatherModel(conditionId: id, cityName: name, temprature: temp)

            return weather
        } catch {
            //print(error)
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
    
    
}
