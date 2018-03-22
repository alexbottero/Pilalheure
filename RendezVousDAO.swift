//
//  RendezVousDAO.swift
//  Pilalheure
//
//  Created by Bottero Alexandre  on 22/03/2018.
//  Copyright © 2018 Vincent HERREROS. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension RendezVousDTO{
    static let request : NSFetchRequest<RendezVousDTO> = RendezVousDTO.fetchRequest()
    
    static func createDTO() -> RendezVousDTO?{
        let rendezVous = RendezVousDTO(context: CoreDataManager.context)
        return rendezVous
    }
    
    static func add(rendezVous: RendezVous){
        /*if self.count(prescription: prescription) > 1{
         CoreDataManager.context.delete(prescription.dao)
         }
         else{
         CoreDataManager.save()
         }*/
    }
    
    static func count(prescription: RendezVous) -> Int{
        let predicate = NSPredicate(format:"medicament.nom == %@ AND medicament.dose == %@ AND medicament.unite == %@",prescription.medicament.nom!,prescription.medicament.dose!,prescription.medicament.unite!)
        self.request.predicate = predicate
        do{
            return try CoreDataManager.context.count(for: self.request)
        }
        catch{
            fatalError()
        }
    }
    
    static func delete(prescription : PrescriptionDTO){
        CoreDataManager.context.delete(prescription)
        CoreDataManager.save()
    }
    
}
