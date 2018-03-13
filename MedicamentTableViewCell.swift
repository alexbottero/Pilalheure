//
//  MedicamentTableViewCell.swift
//  Pilalheure
//
//  Created by Vincent HERREROS on 13/03/2018.
//  Copyright © 2018 Vincent HERREROS. All rights reserved.
//

import UIKit

class MedicamentTableViewCell: UITableViewCell {

    @IBOutlet weak var nom: UILabel!
    @IBOutlet weak var unite: UILabel!
    @IBOutlet weak var dose: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
