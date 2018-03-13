//
//  MedicamentDAOext.swift
//  Pilalheure
//
//  Created by Vincent HERREROS on 13/03/2018.
//  Copyright © 2018 Vincent HERREROS. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension MedicamentDAO{
    static func getNewMedicament() -> MedicamentDAO?{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return nil
        }
        let moc = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "MedicamentDAO", in: moc) else{
            return nil
        }
        let medicament = MedicamentDAO(entity: entity, insertInto: moc)
        return medicament
    }
    
}
