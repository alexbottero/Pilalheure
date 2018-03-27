//
//  PrescriptionDAO.swift
//  Pilalheure
//
//  Created by Sheena Maucuer on 20/03/2018.
//  Copyright © 2018 Vincent HERREROS. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension PrescriptionDTO{
    static let request : NSFetchRequest<PrescriptionDTO> = PrescriptionDTO.fetchRequest()
    
    /// Création d'un DTO Prescription
    ///
    /// - Returns: retourne un PrescriptionDTO
    static func createDTO() -> PrescriptionDTO?{
        let prescription = PrescriptionDTO(context: CoreDataManager.context)
        return prescription
    }
    
    /// Fonction de sauvegarde d'une prescription, sauvegarde le context
    ///
    /// - Parameter prescription: Prescription
    static func add(prescription: Prescription){
        /*if self.count(prescription: prescription) > 10000{
            CoreDataManager.context.delete(prescription.daoPrescription)
        }
        else{*/
            CoreDataManager.save()
        //}
    }
    
    /*static func count(prescription: Prescription) -> Int{
        let predicate = NSPredicate(format:"medicaments.nom == %@", prescription.medicament.nom!)
        self.request.predicate = predicate
        do{
            return try CoreDataManager.context.count(for: self.request)
        }
        catch{
            fatalError()
        }
    }*/

    
    /// Fonction de suppression, delete le prescriptionDTO passé en paramètre
    ///
    /// - Parameter prescription: PrescriptionDTO
    static func delete(prescription : PrescriptionDTO){
        CoreDataManager.context.delete(prescription)
        CoreDataManager.save()
    }
    
}
