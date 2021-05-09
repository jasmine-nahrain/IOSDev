//
//  AddViewController.swift
//  IOS_Dev
//
//  Created by Jasmine Emanouel on 4/5/21.
//

import Foundation
import Coinpaprika
import UIKit

class AddViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var listPicker: UIPickerView!
    var list:[String] = [String]()
    var chosenCoin:String!
    var amount:String!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.listPicker.delegate = self
        self.listPicker.dataSource = self
        
        Coinpaprika.API.coins().perform { (response) in
            switch response {
            case .success(let coins):
                for c in coins {
                    self.list.append(c.name)
                }
                self.listPicker.reloadAllComponents()
                break
            case .failure(let error):
                print(error)
                break
            }
        }
        listPicker.selectedRow(inComponent: 0)
        amountTextField.addTarget(self, action: #selector(amountDidChanged(_:)), for: .editingChanged)
        submitButton.layer.cornerRadius = 5
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.chosenCoin = list[row]
        return list[row]
    }
    
    @IBAction func amountDidChanged(_ sender: UITextField) {
        self.amount = sender.text
    }
    
    @IBAction func buttonDidPress(sender: UIButton) {
        if self.chosenCoin != nil && self.amount != nil {
            let current = UserDefaults.standard.value(forKey: self.chosenCoin)
            let value = current as! Int + Int(self.amount)!
            UserDefaults.standard.setValue(value, forKey: self.chosenCoin)
            let alert = UIAlertController(title: "Success", message: "You have added \(self.chosenCoin!)", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
}


