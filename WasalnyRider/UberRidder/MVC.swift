//
//  MVC.swift
//  UberRidder
//
//  Created by MSA on 12/06/2017.
//  Copyright © 2017 MSA. All rights reserved.
//

import UIKit

class MVC: UITableViewCell {

    @IBOutlet weak var TimeX: UILabel!
    @IBOutlet weak var LocationX: UILabel!
    @IBOutlet weak var DriverX: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
