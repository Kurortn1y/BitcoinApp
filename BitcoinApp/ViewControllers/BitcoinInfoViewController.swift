//
//  ViewController.swift
//  BitcoinApp
//
//  Created by Roman on 19.11.23.
//

import UIKit


class BitcoinInfoViewController: UIViewController {
    
    @IBOutlet weak var infoLabel: UILabel!
    
    let network = NetworkManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchBtcInfo()
    }
    
    private func fetchBtcInfo() {
        network.fetchBtcInfo(from: bitcoinUrl) { [unowned self] result in
            switch result {
                
            case .success(let bitcoinData):
                self.updateInfoLabel(with: bitcoinData)
            case .failure(let error):
                print(error)
            }
        }
    }
    private func updateInfoLabel(with bitcoinData: BitcoinData) {
            let timeInfo = """
                Updated: \(bitcoinData.time.updated)
                Updated ISO: \(bitcoinData.time.updatedISO)
                Updated UK: \(bitcoinData.time.updateduk)
                """

            var bpiInfo = "BPI:\n"
            for (currencyCode, bpiItem) in bitcoinData.bpi {
                bpiInfo += """
                    Currency Code: \(currencyCode)
                    Symbol: \(bpiItem.symbol)
                    Rate: \(bpiItem.rate)
                    Description: \(bpiItem.description)
                    Rate Float: \(bpiItem.rate_float)
                    ------
                    """
            }

            let infoText = """
                Time Info:
                \(timeInfo)

                Disclaimer: \(bitcoinData.disclaimer)
                Chart Name: \(bitcoinData.chartName)

                \(bpiInfo)
                """

            self.infoLabel.text = infoText
        }
}


