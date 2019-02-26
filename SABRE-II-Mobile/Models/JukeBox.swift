//
//  JukeBox.swift
//  SABRE-II-Mobile
//
//  Created by Skyler Maxwell on 2/26/19.
//  Copyright © 2019 SABRE. All rights reserved.
//

import Foundation
import SwiftyJSON

struct PlayList {
  var playListName: String
  
  init(playListName name: String) {
    self.playListName = name
  }
}

struct Track {
  var trackId: Int
  var artistName: String
  var collectionName: String
  var songName: String
  var artworkUrl: String
  var vote: Int
  
  // Initializes Track structure from JSON object recieved from API call
  init(fromJSON trackJSON: JSON) {
    self.trackId = trackJSON["trackId"].intValue
    self.artistName = trackJSON["artistName"].stringValue
    self.collectionName = trackJSON["collectionName"].stringValue
    self.artworkUrl = trackJSON["artworkUrl100"].stringValue
    self.songName = trackJSON["trackName"].stringValue
    self.vote = trackJSON["vote"].intValue
  }
  
  
  // Returns the track data in JSON object for transfer to server
  func toJSON() -> JSON {
    return JSON(self.toDict())
  }
  
  func toDict() -> Dictionary<String, Any> {
    var trackDict: Dictionary<String, Any> = [:]
    
    trackDict["trackId"] = self.trackId
    trackDict["trackName"] = self.songName
    trackDict["artistName"] = self.artistName
    trackDict["collectionName"] = self.collectionName
    trackDict["artworkUrl100"] = self.artworkUrl
    trackDict["vote"] = self.vote
    
    return trackDict
  }
}

class JukeBox {
  var capacity: Int
  var isSynced: Bool
  var jukeBoxSettings: JukeBoxSettings
  var trackList: Array<Track>

  init(jukeBoxName name: String) {
    self.capacity = 30
    self.isSynced = false
    self.jukeBoxSettings = JukeBoxSettings(jukeBoxName: name)
    self.trackList = []
  }
  
  func fillWith(playList: PlayList) {
    // For future use . . .
    // We will want to be able to pre-populate song list with user defined Apple
    //  Music or Spotify playlist
    return
  }
  
  func addTrack() {
    // add track to local jukebox
    return
  }
  
  func removeTrack() {
    // Remove track from local jukebox
    return
  }
  
  func syncLocalWithRemote() {
    // This should be called on a timer event
    return
  }
  
  func onTrackEnd() {
    // Here we should
    // - grab new track info
    // - update local trackList
    // - update currently playing data
    // - tell the remote jukebox to pop the current track
    return
  }
}
