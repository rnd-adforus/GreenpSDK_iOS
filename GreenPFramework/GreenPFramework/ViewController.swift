//
//  ViewController.swift
//  GreenPFramework
//
//  Created by 심현지 on 2023/11/14.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
    var greenP: GreenPSettings?
    var builder: GreenPBuilder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc private func handleTap(_ tap: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func didTapRegistBtn(_ sender: Any) {
        initializeOW()
    }
    
    private func initializeOW() {
        let userID = idTextField.text!
        
        greenP = GreenPSettings(appCode: "B8PcNMrpS7",
                                userID: userID,
                                completion: {  [weak self] (result, message, builder) in
            DispatchQueue.main.async {
                self?.resultLabel.text = message
            }
            if result == true {
                self?.builder = builder
            }
        })
    }
    
    @IBAction func show(_ sender: Any) {
        builder?.initilize(on: self)
    }
    
}

