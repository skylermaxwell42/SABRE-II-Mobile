//
//  JukeBox.swift
//  SABRE-II-Mobile
//
//  Created by Skyler Maxwell on 2/26/19.
//  Copyright © 2019 SABRE. All rights reserved.
//

import Foundation

struct PlayList {
  var playListName: String
  
  init(playListName name: String) {
    self.playListName = name
  }
}

class JukeBox {
  var capacity: Int
  var isSynced: Bool
  var jukeBoxSettings: JukeBoxSettings

  init(jukeBoxName name: String) {
    self.capacity = 30
    self.isSynced = false
    self.jukeBoxSettings = JukeBoxSettings(jukeBoxName: name)
  }
}
