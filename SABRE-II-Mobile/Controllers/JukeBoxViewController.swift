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
import Alamofire
import SwiftyJSON

struct Song {
  var trackId = 0
  var artistName = ""
  var collectionName = ""
  var songName = ""
  var artworkUrl = ""
  var vote = 0
}

class JukeBoxViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  let systemMusicPlayer = MPMusicPlayerController.systemMusicPlayer
  @IBOutlet weak var currentSongAlbumArt: UIImageView!
  @IBOutlet weak var playPauseMusicButton: UIButton!
  @IBOutlet weak var jukeBoxTableView: UITableView!
  @IBOutlet weak var searchTabBarItem: UITabBarItem!
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  var mediaTimer = Timer()
  
  
  
  var jukeBox: [Song] = []
  
  @IBAction func syncRemoteJukeBox(_ sender: UIButton) {
    updateRemoteJukeBox()
  }
  @IBAction func addSongToJukeBox(_ sender: UIButton) {
    print("Updating Juke")
    
    let alert = UIAlertController(title: "Add Track to Juke Box",
                                  message: "",
                                  preferredStyle: .alert)
    
    // Add 2 textFields and customize them
    alert.addTextField { (textField: UITextField) in
      textField.keyboardAppearance = .dark
      textField.keyboardType = .default
      textField.autocorrectionType = .default
      textField.placeholder = "Enter track name"
      textField.clearButtonMode = .whileEditing
    }
    alert.addTextField { (textField: UITextField) in
      textField.keyboardAppearance = .dark
      textField.keyboardType = .default
      textField.autocorrectionType = .default
      textField.placeholder = "Enter track name"
      textField.clearButtonMode = .whileEditing
    }
    
    // Submit button
    let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { (action) -> Void in
      // Get 1st TextField's text
      let trackSearch = (alert.textFields![0].text)! // Force unwrapping because we know it exists.
      self.searchItunes(trackName: trackSearch)
      
      
      DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
        print("done")
        self.updateRemoteJukeBox()
        self.jukeBoxTableView.reloadData()
      })
      
      
    })
    // Cancel button
    let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
    // Add action buttons and present the Alert
    alert.addAction(submitAction)
    alert.addAction(cancel)
    present(alert, animated: true, completion: nil)
  }
  
  @IBAction func playPauseMusic(_ sender: UIButton) {
    var songQueue: Array<String> = []
    
    if (systemMusicPlayer.playbackState == MPMusicPlaybackState.playing) {
      systemMusicPlayer.pause()
    }
    else if (systemMusicPlayer.playbackState == MPMusicPlaybackState.paused) {
      systemMusicPlayer.play()
      appleMusicPlayTrackId(ids: [String(jukeBox[0].trackId)])
      jukeBox.remove(at: 0)
    }
    updateRemoteJukeBox()
    jukeBoxTableView.reloadData()
  }
  
  func searchItunes(trackName: String) {
    var urlString: String
    print(trackName.replacingOccurrences(of: " ", with: "+"))
    urlString = "https://itunes.apple.com/search?country=us&limit=1&term=" + trackName.replacingOccurrences(of: " ", with: "+")
    print(urlString)
    Alamofire.request(urlString, method: .get, encoding: JSONEncoding.default).responseJSON { response in
      if let result = response.result.value {
        let json = JSON(result)
        let recievedTrack = json["results"][0]
        let songStruct = self.createSongStruct(songJSON: recievedTrack)
        self.jukeBox.append(songStruct)
        print(self.jukeBox)
      }
      else {
        print("Couldnt Complete Request")
      }
    }
  }
  
  @objc func timerFired() {
    if let currentTrack = systemMusicPlayer.nowPlayingItem {
      let trackName = currentTrack.title
      let trackArtist = currentTrack.artist
      let cgsize = CGSize(width: 100, height: 100)
      let albumArtUrl = currentTrack.assetURL

      let trackDuration = currentTrack.playbackDuration
      let trackElapsed = systemMusicPlayer.currentPlaybackTime
      let trackDurationMinutes = Int(trackDuration) / 60
      let trackDurationSeconds = Int(trackDuration) % 60
      
      func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
          guard let data = data, error == nil else { return }
          print(response?.suggestedFilename ?? url.lastPathComponent)
          print("Download Finished")
          DispatchQueue.main.async() {
            self.currentSongAlbumArt.image = UIImage(data: data)
          }
        }
      }
      
      if ((trackDuration - trackElapsed) < 5) {
        if (trackName == jukeBox[0].songName) {
          //systemMusicPlayer.append(String(jukeBox[0].trackId))
        }
      }
    }
  }
  
  @objc func updateNowPlayingInfo() {
    self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.timerFired), userInfo: nil, repeats: true)
    self.timer.tolerance = 0.1
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    systemMusicPlayer.prepareToPlay()
    //self.mediaTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.timerFired), userInfo: nil, repeats: true)
    systemMusicPlayer.beginGeneratingPlaybackNotifications()
    
    NotificationCenter.default.addObserver(self, selector:#selector(self.updateNowPlayingInfo), name: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange, object: nil)
    self.timer.tolerance = 0.1
    self.jukeBoxTableView.delegate = self
    self.jukeBoxTableView.dataSource = self
    //scheduledTimerWithTimeInterval()
    print("Begin of code")
  }
  
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
  }
  
  func getRemoteJukeBoxUrl() {
    return
  }
  
  @objc func updateRemoteJukeBox() {
    var jukeBoxDict: Dictionary<String, Array<Dictionary<String, Any>>> = [:]
    var songList: Array<Dictionary<String, Any>> = []
    
    for songStruct in jukeBox {
      print(songStruct)
      songList.append(createSongDict(songStruct: songStruct))
    }
    
    jukeBoxDict["jukeBox"] = songList
    print(JSON(jukeBoxDict))
    //let json = try? JSONSerialization.jsonObject(with: jukeBoxDict, options: [])
    //print("HELLLLLOOOOOOO      "+String(json))
    Alamofire.request("https://sabre-ii-backend.herokuapp.com/updateRemoteJukeBox", method: .post, parameters: jukeBoxDict, encoding: JSONEncoding.default).responseJSON { response in
      if let result = response.result.value {
        let json = JSON(result)
        self.jukeBox = []
        self.fillJukeBox(songArray: json["jukeBox"].arrayValue)
        self.jukeBoxTableView.reloadData()
      }
      else {
        print("Couldnt Complete Request")
      }
    }
    return
  }
  
  func fillJukeBox(songArray: Array<JSON>) {
    for song in songArray {
      jukeBox.append(createSongStruct(songJSON: song))
      print(song)
    }
  }
  
  func createSongStruct(songJSON: JSON) -> Song{
    var song = Song()
    song.trackId = songJSON["trackId"].intValue
    song.artistName = songJSON["artistName"].stringValue
    song.collectionName = songJSON["collectionName"].stringValue
    song.artworkUrl = songJSON["artworkUrl100"].stringValue
    song.songName = songJSON["trackName"].stringValue
    song.vote = songJSON["vote"].intValue
    return song
  }
  
  func createSongDict(songStruct: Song) -> Dictionary<String, Any> {
    var songDict: Dictionary<String, Any> = [:]
    
    songDict["trackId"] = songStruct.trackId
    songDict["trackName"] = songStruct.songName
    songDict["artistName"] = songStruct.artistName
    songDict["collectionName"] = songStruct.collectionName
    songDict["artworkUrl100"] = songStruct.artworkUrl
    songDict["vote"] = songStruct.vote
    return songDict
  }
  
  //func createSongJSON(songDict: Dictionary<String, JSON>) -> JSON {
    //return JSON(createSongStruct(songJSON: songDict))
  //}
  
  func updateCurrentAlbumArt() {
    return
  }
  
  func updateLocalJukeBox() {
    
    return
  }
  
  func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
    URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
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
  
  func appleMusicPlayTrackId(ids:[String]) {
    
    systemMusicPlayer.setQueue(with: ids)
    systemMusicPlayer.play()
    
  }
  
  func numberOfSections(in jukeBoxTableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ jukeBoxTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.jukeBox.count
  }
  
  func tableView(_ jukeBoxTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    print("Loading data into table")
    // Table view cells are reused and should be dequeued using a cell identifier.
    let cellIdentifier = "JukeBoxTableViewCell"
    
    guard let cell = jukeBoxTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? JukeBoxTableViewCell  else {
      fatalError("The dequeued cell is not an instance of MealTableViewCell.")
    }
    
    // Fetches the appropriate meal for the data source layout.
    let song = self.jukeBox[indexPath.row]
    
    cell.artistName.text = song.artistName
    cell.songName.text = song.songName
    cell.albumName.text = song.collectionName
    print(song.artworkUrl)
    func downloadImage(from url: URL) {
      print("Download Started")
      getData(from: url) { data, response, error in
        guard let data = data, error == nil else { return }
        print(response?.suggestedFilename ?? url.lastPathComponent)
        print("Download Finished")
        DispatchQueue.main.async() {
          cell.albumCoverView.image = UIImage(data: data)
        }
      }
    }
    if let url = URL(string: song.artworkUrl) {
      cell.albumCoverView.contentMode = .scaleAspectFit
      downloadImage(from: url)
    }
    
    return cell
  }
  
  var timer = Timer()
  
  func scheduledTimerWithTimeInterval(){
    //Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
    let currentTrack = systemMusicPlayer.nowPlayingItem
    let trackName = currentTrack?.title
    let trackDuration = currentTrack?.playbackDuration
    let trackElapsed = systemMusicPlayer.currentPlaybackTime
    
    timer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(self.updateRemoteJukeBox), userInfo: nil, repeats: true)
  }

}
