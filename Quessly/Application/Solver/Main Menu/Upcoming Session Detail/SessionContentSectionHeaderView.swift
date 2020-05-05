//
//  SessionContentSectionHeaderView.swift
//  Quessly
//
//  Created by Buğra Ekuklu on 27.04.2020.
//  Copyright © 2020 Quessly. All rights reserved.
//

import UIKit

final class SessionContentSectionHeaderView: UITableViewHeaderFooterView {
  static let reuseIdentifier = String(describing: self)
  
  static var nib: UINib {
    return UINib(nibName: String(describing: self), bundle: nil)
  }
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var actionButton: UIButton!
  @IBOutlet override var textLabel: UILabel? {
    get { return _textLabel }
    set { _textLabel = newValue }
  }
  private var _textLabel: UILabel?
  
  
  @IBAction func actionButtonTouchUpInside(_ sender: UIButton, forEvent event: UIEvent) {
    
  }
}
