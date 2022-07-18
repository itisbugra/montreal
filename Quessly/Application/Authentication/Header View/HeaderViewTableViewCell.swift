//
//  HeaderViewTableViewCell.swift
//  Quessly
//
//  Created by Ersin Yildirim on 18.07.2022.
//  Copyright © 2022 Quessly. All rights reserved.
//

import UIKit

class HeaderViewTableViewCell: UITableViewCell {

  @IBOutlet weak var phoneNumberHeaderView: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
