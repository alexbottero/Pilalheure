//
//  Contact.swift
//  Pilalheure
//
//  Created by Bottero Alexandre  on 20/03/2018.
//  Copyright © 2018 Vincent HERREROS. All rights reserved.
//

import Foundation

class Contact {
    internal let dao : ContactDTO
    var nom   : String{
        return self.dao.nom!
    }
    var prof : String{
        return self.dao.profession!
    }
    var mail : String{
        return self.dao.email!
    }
    var adresse : String{
        return self.dao.adresse!
    }
    var tel : String{
        return self.dao.telephone!
    }
    
    
    init(nom: String, prof: String, mail: String, adresse: String, tel:String){
        guard let dao = ContactDTO.createDTO() else{
            fatalError("unuable to get dao for ExercicePhysique")
        }
        self.dao = dao
        self.dao.nom = nom
        self.dao.profession = prof
        self.dao.email = mail
        self.dao.adresse = adresse
        self.dao.telephone = tel
    }
}
