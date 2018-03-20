//
//  Medicament.swift
//  Pilalheure
//
//  Created by Vincent HERREROS on 13/03/2018.
//  Copyright © 2018 Vincent HERREROS. All rights reserved.
//

import Foundation
class Medicament {
    
    
    internal let dao : MedicamentDTO
    var nom   : String{
        return self.dao.nom!
    }
    var unite : String{
        return self.dao.unite!
    }
    var dose  : String{
        return self.dao.dose!
    }
    var desc  : String{
        return self.dao.descript!
    }
    
    init(nom: String, dose: String, unite: String, desc: String){
        guard let dao = MedicamentDTO.createDTO() else{
            fatalError("unuable to get dao for medicament")
        }
        self.dao = dao
        self.dao.nom = nom
        self.dao.unite = unite
        self.dao.dose = dose
        self.dao.descript = desc
    }
    
}
