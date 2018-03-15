//
//  MedicamentPresenter.swift
//  Pilalheure
//
//  Created by Vincent HERREROS on 14/03/2018.
//  Copyright © 2018 Vincent HERREROS. All rights reserved.
//

import Foundation
class MedicamentPresenter : NSObject{
    fileprivate var nomMedicament : String = ""
    fileprivate var doseMedicament : String = ""
    fileprivate var uniteMedicament : String = ""
    
    fileprivate var medicament : MedicamentDAO? = nil {
        didSet{
            if let medicament = self.medicament {
                if let mname = medicament.nom{
                    self.nomMedicament = mname.capitalized
                }
                else { self.nomMedicament = " - " }
                if let mdose = medicament.dose{
                    self.doseMedicament = mdose.capitalized
                }
                else { self.doseMedicament = " - " }
                if let munite = medicament.unite{
                    self.uniteMedicament = munite.capitalized
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
    
    func configure(theCell : MedicamentTableViewCell?, forMedicament: MedicamentDAO?){
        self.medicament = forMedicament
        guard let cell = theCell else { return }
        cell.nom.text = self.nomMedicament
        cell.dose.text = self.doseMedicament
        cell.unite.text = self.uniteMedicament
    }
}
