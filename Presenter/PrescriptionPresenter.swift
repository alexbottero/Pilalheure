//
//  PrescriptionPresenter.swift
//  Pilalheure
//
//  Created by Sheena Maucuer on 19/03/2018.
//  Copyright © 2018 Vincent HERREROS. All rights reserved.
//

import Foundation
class PrescriptionPresenter : NSObject{
    fileprivate var nomMedicament : String = ""
    
    fileprivate var prescription : PrescriptionDAO? = nil {
        didSet{
            if let prescription = self.prescription {
                if let pmedoc = prescription.medicaments?.nom{
                    self.nomMedicament = pmedoc.capitalized
                }
                else { self.nomMedicament = " - " }
            }
            else{
                self.nomMedicament = ""
            }
        }
    }
    
    func configure(theCell : PrescriptionTableViewCell?, forPrescription: PrescriptionDAO?){
        self.prescription = forPrescription
        guard let cell = theCell else { return }
        cell.nomMedicament.text = self.nomMedicament

    }
}
