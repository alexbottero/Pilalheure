//
//  ExercicePhysiqueTableViewCell.swift
//  Pilalheure
//
//  Created by Bottero Alexandre  on 14/03/2018.
//  Copyright © 2018 Vincent HERREROS. All rights reserved.
//

import UIKit

class ExercicePhysiqueTableViewCell: UITableViewCell {

    //Mark: - Variables -
    @IBOutlet weak var nomExercicePhysique: UILabel!
    @IBOutlet weak var dateExercicePhysique: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
