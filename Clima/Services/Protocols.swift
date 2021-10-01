//
//  Protocols.swift
//  Clima
//
//  Created by Ahmed Sayed on 29/09/2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

protocol WeatherApiDelegate {
    func didUpdateWeather(weather: WeatherModel)
    func didFailWithError(error: Error)
}
