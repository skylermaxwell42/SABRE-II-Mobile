//
//  JukeBoxViewController.swift
//  SABRE-II-Mobile
//
//  Created by Skyler Maxwell on 2/23/19.
//  Copyright © 2019 SABRE. All rights reserved.
//

import UIKit
import StoreKit
import MediaPlayer

class JukeBoxViewController: UIViewController {
  
  let systemMusicPlayer = MPMusicPlayerController.systemMusicPlayer
  @IBOutlet weak var currentSongAlbumArt: UIImageView!
  
  @IBAction func addSongToJukeBox(_ sender: UIButton) {
    
  }
  
  @IBAction func playPauseMusicButton(_ sender: UIButton) {
    
  }
  
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
  
  // Request permission from the user to access the Apple Music library
  func appleMusicRequestPermission() {
    
    switch SKCloudServiceController.authorizationStatus() {
      
    case .authorized:
      print("The user's already authorized - we don't need to do anything more here, so we'll exit early.")
      return
    case .denied:
      print("The user has selected 'Don't Allow' in the past - so we're going to show them a different dialog to push them through to their Settings page and change their mind, and exit the function early.")
      return
    case .notDetermined:
      print("The user hasn't decided yet - so we'll break out of the switch and ask them.")
      break
    case .restricted:
      print("User may be restricted; for example, if the device is in Education mode, it limits external Apple Music usage. This is similar behaviour to Denied.")
      return
    }
    
    SKCloudServiceController.requestAuthorization { (status:SKCloudServiceAuthorizationStatus) in
      
      switch status {
        
      case .authorized:
        print("All good - the user tapped 'OK', so you're clear to move forward and start playing.")
      case .denied:
        print("The user tapped 'Don't allow'. Read on about that below...")
      case .notDetermined:
        print("The user hasn't decided or it's not clear whether they've confirmed or denied.")
      default: break
      }
    }
  }
  
  // 2. Playback a track!
  func appleMusicPlayTrackId(ids:[String]) {
    
    systemMusicPlayer.setQueue(with: ids)
    systemMusicPlayer.play()
    
  }
  

}
