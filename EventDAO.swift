//
//  EventDAO.swift
//  Pilalheure
//
//  Created by Vincent HERREROS on 21/03/2018.
//  Copyright © 2018 Vincent HERREROS. All rights reserved.
//

import Foundation
import CoreData
import UIKit
extension EventDTO{
    static let request : NSFetchRequest<EventDTO> = EventDTO.fetchRequest()
    
    static func createDTO() -> EventDTO?{
        let event = EventDTO(context: CoreDataManager.context)
        return event
    }
}
