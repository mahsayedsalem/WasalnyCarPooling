//
//  TableViewCell.swift
//  UberRidder
//
//  Created by MSA on 12/06/2017.
//  Copyright © 2017 MSA. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var DriverM: UILabel!
    @IBOutlet weak var PlaceM: UILabel!
    @IBOutlet weak var TimeM: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
