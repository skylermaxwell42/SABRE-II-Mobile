//
//  ViewController.swift
//  SABRE-II-Mobile
//
//  Created by Skyler Maxwell on 2/23/19.
//  Copyright © 2019 SABRE. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
  
  // Properties
  @IBOutlet weak var jukeBoxUILabel: UILabel!
  @IBOutlet weak var jukeBoxCreateButton: UIButton!
  @IBOutlet weak var jukeBoxCreateTextField: UITextField!
  @IBOutlet weak var jukeBoxCreateView: UIStackView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Handle the text field’s user input through delegate callbacks.
    jukeBoxCreateTextField.delegate = self
  }

  @IBAction func jukeBoxCreateButton(_ sender: UIButton) {
    return;
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    // Hide the keyboard.
    textField.resignFirstResponder()
    return true
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    jukeBoxUILabel.text!.append(jukeBoxCreateTextField.text!)
    jukeBoxCreateTextField.text = ""
    jukeBoxCreateTextField.placeholder = "Enter song name"
    jukeBoxCreateButton.setTitle("Add Song", for: UIControl.State.normal)
    
    connectToServer()
    performSegue(withIdentifier: "createRoomSegueue", sender: textField)
  }
  
  func connectToServer() {
    print("Connecting to sevrer")
  }
  
}

