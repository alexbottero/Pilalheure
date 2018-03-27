//
//  RendezVousTableViewCell.swift
//  Pilalheure
//
//  Created by Bottero Alexandre  on 22/03/2018.
//  Copyright © 2018 Vincent HERREROS. All rights reserved.
//

import UIKit

class RendezVousTableViewCell: UITableViewCell {

    //MARK: - Variables-
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var RDV: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
