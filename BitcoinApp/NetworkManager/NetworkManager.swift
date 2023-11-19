//
//  NetworkManager.swift
//  BitcoinApp
//
//  Created by Roman on 19.11.23.
//

import Foundation
import Alamofire
import UIKit


let bitcoinUrl = URL(string: "https://api.coindesk.com/v1/bpi/currentprice.json")!
let imageURL = URL(string: "https://cdn.pixabay.com/photo/2018/02/04/17/39/crypto-currency-3130381_1280.jpg")!

final class NetworkManager {
    
   static  let shared = NetworkManager()
    
    private init() {}

    
    func fetchBtcInfo(from url: URL, completion: @escaping(Result<BitcoinData, AFError>)-> Void) {
        AF.request(url)
            .validate()
            .responseJSON { dataResponse in
                switch dataResponse.result {
                    
                case .success(let jsonValue):
                    guard let bitcoinInfo = jsonValue as? [String: Any] else { return print("bolty") }
                    
                    guard
                        let timeDictionary = bitcoinInfo["time"] as? [String: String],
                        let updated = timeDictionary["updated"],
                        let updatedISO = timeDictionary["updatedISO"],
                        let updateduk = timeDictionary["updateduk"],
                        
                        let dislaimer = bitcoinInfo["disclaimer"] as? String,
                        let chartName = bitcoinInfo["chartName"] as? String,
                        let bpiDictionary = bitcoinInfo["bpi"] as? [String: [String: Any]]
                            
                    else {
                        return print("error extracting from JSOn")
                    }
                    
                    let timeObject = Time(
                        updated: updated,
                        updatedISO: updatedISO,
                        updateduk: updateduk
                    )
                    
                    var bpiItems = [String: BpiItem]()
                    
                    for (currencyCode, bpiInfo) in bpiDictionary {
                        if
                            let code = bpiInfo["code"] as? String,
                            let symbol = bpiInfo["symbol"] as? String,
                            let rate = bpiInfo["rate"] as? String,
                            let description = bpiInfo["description"] as? String,
                            let rateFloat = bpiInfo["rate_float"] as? Double
                        {
                            let bpiItem = BpiItem(
                                code: code,
                                symbol: symbol,
                                rate: rate,
                                description: description,
                                rate_float: rateFloat
                            )
                            bpiItems[currencyCode] = bpiItem
                        }
                    }
                    let bitcoinData = BitcoinData(
                        time: timeObject,
                        disclaimer: dislaimer,
                        chartName: chartName,
                        bpi: bpiItems
                    )
                    completion(.success(bitcoinData))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        
    }
    
    
    func fetchImage(from url: URL, completion: @escaping(Result<UIImage, AFError>)-> Void) {
        AF.request(url).responseData { response  in
            switch response.result {
                
            case .success(let data):
                guard let image = UIImage(data: data) else { return }
                completion(.success(image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
    
}
