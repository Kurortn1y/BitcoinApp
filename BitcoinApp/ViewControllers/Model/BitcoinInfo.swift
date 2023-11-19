//
//  BitcoinInfo.swift
//  BitcoinApp
//
//  Created by Roman on 19.11.23.
//

import Foundation
import Alamofire

// Модель данных для объекта "time"
struct Time: Codable {
    let updated: String
    let updatedISO: String
    let updateduk: String
}

// Модель данных для объекта "bpi"
struct BpiItem: Codable {
    let code: String
    let symbol: String
    let rate: String
    let description: String
    let rate_float: Double
}

// Модель данных для основного JSON
struct BitcoinData: Codable {
    let time: Time
    let disclaimer: String
    let chartName: String
    let bpi: [String: BpiItem] // Bpi теперь представлен как словарь с ключами "USD", "GBP", и "EUR"
}
