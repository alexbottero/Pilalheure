//
//  QuestionnaireRendezVousTableViewCell.swift
//  Pilalheure
//
//  Created by Vincent HERREROS on 26/03/2018.
//  Copyright © 2018 Vincent HERREROS. All rights reserved.
//

import UIKit

class QuestionnaireRendezVousTableViewCell: UITableViewCell {

    @IBOutlet weak var nomDocteur: UILabel!
    @IBOutlet weak var dateRendezVous: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
