//
//  UpcomingSessionTableViewCell.swift
//  Quessly
//
//  Created by Buğra Ekuklu on 27.04.2020.
//  Copyright © 2020 Quessly. All rights reserved.
//

import UIKit

class UpcomingSessionTableViewCell: UITableViewCell {
  static private let dayDateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    
    dateFormatter.dateFormat = "EEEE"
    
    return dateFormatter
  }()
  
  static private let timeDateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    
    dateFormatter.dateFormat = "HH:mm"
    
    return dateFormatter
  }()
  
  @IBOutlet weak var untouchedIndicatorImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var subtitleLabel: UILabel!
  @IBOutlet weak var dayLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  
  var upcomingSession: UpcomingSession! {
    didSet {
      let dayDateFormatter = UpcomingSessionTableViewCell.dayDateFormatter
      let timeDateFormatter = UpcomingSessionTableViewCell.timeDateFormatter
      
      self.untouchedIndicatorImageView.isHidden = !upcomingSession.untouched
      self.titleLabel.text = upcomingSession.title
      self.subtitleLabel.text = "\(upcomingSession.participantCount) users participating"
      self.dayLabel.text = dayDateFormatter.string(from: upcomingSession.timestamp)
      self.timeLabel.text = timeDateFormatter.string(from: upcomingSession.timestamp)
    }
  }
}
