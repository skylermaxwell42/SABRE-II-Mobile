//
//  JukeBoxViewController.swift
//  SABRE-II-Mobile
//
//  Created by Skyler Maxwell on 2/23/19.
//  Copyright © 2019 SABRE. All rights reserved.
//

import UIKit

class JukeBoxViewController: UIViewController {

  @IBOutlet weak var currentSongAlbumArt: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
  }
  
  func getRemoteJukeBoxUrl() {
    return
  }
  
  func updateRemoteJukeBox() {
    return
  }
  
  func updateCurrentAlbumArt() {
    return
  }
  
  func updateLocalJukeBox() {
    return
  }

}
