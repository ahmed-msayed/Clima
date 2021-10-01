//
//  Constants.swift
//  Clima
//
//  Created by Ahmed Sayed on 24/09/2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

class Constants {
    
    static let API_KEY = "appid=f64e8cc90812d41f85f6d0b47524b466"
    static let API_URL = "https://api.openweathermap.org/data/2.5/weather?"
}


typealias WeatherResponseCompletion = (String) -> Void
