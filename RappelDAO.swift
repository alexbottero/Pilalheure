//
//  RappelDAO.swift
//  Pilalheure
//
//  Created by Vincent HERREROS on 21/03/2018.
//  Copyright © 2018 Vincent HERREROS. All rights reserved.
//

import Foundation
import CoreData
import UIKit
extension RappelDTO{
    static let request : NSFetchRequest<RappelDTO> = RappelDTO.fetchRequest()
    
    /// Création d'un DTO Rappel
    ///
    /// - Returns: Return un RappelDTO
    static func createDTO() -> RappelDTO?{
        let rappel = RappelDTO(context: CoreDataManager.context)
        return rappel
    }
}
