//
//  JukeBoxTableViewCell.swift
//  SABRE-II-Mobile
//
//  Created by Skyler Maxwell on 2/23/19.
//  Copyright © 2019 SABRE. All rights reserved.
//

import UIKit

class JukeBoxTableViewCell: UITableViewCell {

  @IBOutlet weak var songName: UILabel!
  @IBOutlet weak var artistName: UILabel!
  @IBOutlet weak var albumName: UILabel!
  @IBOutlet weak var albumCoverView: UIImageView!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

  @IBAction func upVoteSong(_ sender: UIButton) {
    
  }
  
  
  
  override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
