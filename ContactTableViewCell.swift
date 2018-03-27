//
//  ContactTableViewCell.swift
//  Pilalheure
//
//  Created by Bottero Alexandre  on 19/03/2018.
//  Copyright © 2018 Vincent HERREROS. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    //MARK:-Variables-
    @IBOutlet weak var profContact: UILabel!
    @IBOutlet weak var nomContact: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
