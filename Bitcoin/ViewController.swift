//
//  ViewController.swift
//  Bitcoin
//
//  Created by Jesus Andres Bernal Lopez on 12/8/18.
//  Copyright © 2018 Jesus Andres Bernal Lopez. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD", "PLN", "RON", "RUB","SEK","SGD","USD","ZAR"]
    let currentSymbol = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var index = 0
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    var finalURL = ""

    lazy var currencyPicker: UIPickerView = {
        let p = UIPickerView()
        p.translatesAutoresizingMaskIntoConstraints = false
        p.dataSource = self
        p.delegate = self
        return p
    }()
    
    private let iconImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = images.icon
        return iv
    }()
    
    private let priceLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = #colorLiteral(red: 1, green: 0.7895410821, blue: 0.2385146334, alpha: 1)
        l.textAlignment = .center
        l.font = UIFont.boldSystemFont(ofSize: 90)
        l.adjustsFontSizeToFitWidth = true
        l.minimumScaleFactor = 0.5
        return l
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    func getBitcoinPrice(url: String){
        Alamofire.request(url).responseJSON { (response) in
            if response.result.isSuccess{
                let bitcoinResult = JSON(response.result.value!)
                self.updateBitcoin(json: bitcoinResult)
            }else{
                self.priceLabel.text = "Network issue"
            }
        }
    }
    
    func updateBitcoin(json: JSON){
        let bitcoin = json["averages"]["day"].doubleValue
        self.priceLabel.text = currentSymbol[index] + String(bitcoin)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        finalURL = baseURL + currencyArray[row]
        self.index = row
        self.getBitcoinPrice(url: finalURL)
    }
    
    fileprivate func setUp(){
        view.addSubview(iconImage)
        iconImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        iconImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        iconImage.heightAnchor.constraint(equalToConstant: 200).isActive = true
        iconImage.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        view.addSubview(currencyPicker)
        currencyPicker.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
        currencyPicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        currencyPicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        currencyPicker.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5).isActive = true
        
        view.addSubview(priceLabel)
        priceLabel.topAnchor.constraint(equalTo: iconImage.bottomAnchor, constant: 8).isActive = true
        priceLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        priceLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        priceLabel.bottomAnchor.constraint(equalTo: currencyPicker.topAnchor).isActive = true
    }

}


enum images {
    static let icon = UIImage(named: "Icon")
}
