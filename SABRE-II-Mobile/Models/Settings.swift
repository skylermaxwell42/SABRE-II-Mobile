//
//  Settings.swift
//  SABRE-II-Mobile
//
//  Created by Skyler Maxwell on 2/26/19.
//  Copyright © 2019 SABRE. All rights reserved.
//

import Foundation

enum MusicApp {case appleMusic, spotify}

struct JukeBoxSettings {
  var jukeBoxName: String
  var numVotesPerUser: Int
  var isPublic: Bool
  var musicApp: MusicApp

  init(jukeBoxName name: String) {
    self.jukeBoxName = name
    self.numVotesPerUser = 20
    self.isPublic = true
    self.musicApp = MusicApp.appleMusic
  }
}
