//
//  MedicamentDTOext.swift
//  Pilalheure
//
//  Created by Vincent HERREROS on 13/03/2018.
//  Copyright © 2018 Vincent HERREROS. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension MedicamentDTO{
    static let request : NSFetchRequest<MedicamentDTO> = MedicamentDTO.fetchRequest()
    
    static func createDTO() -> MedicamentDTO?{
        let medicament = MedicamentDTO(context: CoreDataManager.context)
        return medicament
    }
    
    static func add(medicament: Medicament){
        /*if self.count(medicament: medicament) > 1{
            CoreDataManager.context.delete(medicament.dao)
        }
        else{
            CoreDataManager.save()
        }*/
    }
    
    static func count(medicament: Medicament) -> Int{
        let predicate = NSPredicate(format:"nom == %@ AND dose == %@ AND unite == %@",medicament.nom,medicament.dose,medicament.unite)
        self.request.predicate = predicate
        do{
            return try CoreDataManager.context.count(for: self.request)
        }
        catch{
            fatalError()
        }
    }
    
    static func delete(medicament : MedicamentDTO){
        CoreDataManager.context.delete(medicament)
        CoreDataManager.save()
    }
    
}
