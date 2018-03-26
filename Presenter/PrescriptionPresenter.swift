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
    fileprivate var doseMedicament : String = ""
    fileprivate var uniteMedicament : String = ""
    
    fileprivate var prescription : PrescriptionDTO? = nil {
        didSet{
            if let prescription = self.prescription {
                if let pmedoc = prescription.medicaments?.nom{
                    self.nomMedicament = pmedoc.capitalized
                }
                else { self.nomMedicament = " - " }
                if let dmedoc = prescription.medicaments?.dose{
                    self.doseMedicament = dmedoc.capitalized
                }
                else { self.doseMedicament = " - " }
                if let umedoc = prescription.medicaments?.unite{
                    self.uniteMedicament = umedoc.capitalized
                }
                else { self.uniteMedicament = " - " }
            }
            else{
                self.nomMedicament = ""
                self.doseMedicament = ""
                self.uniteMedicament = ""
            }
            
        }
    }
    
    func configure(theCell : PrescriptionTableViewCell?, forPrescription: PrescriptionDTO?){
        self.prescription = forPrescription
        guard let cell = theCell else { return }
        cell.nomMedicament.text = self.nomMedicament
        cell.doseMedicament.text = self.doseMedicament
        cell.uniteMedicament.text = self.uniteMedicament

    }
}
