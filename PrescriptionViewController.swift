//
//  PrescriptionViewController.swift
//  Pilalheure
//
//  Created by Vincent Herreros on 13/03/2018.
//  Copyright © 2018 Vincent HERREROS. All rights reserved.
//

import UIKit

class PrescriptionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var prescriptionTable: UITableView!
    var prescriptions : [PrescriptionDAO] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = self.prescriptionTable.dequeueReusableCell(withIdentifier: "prescriptionCell", for: indexPath) as! PrescriptionTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.prescriptions.count
    }
    
    //MARK: - Medicaments data management -
    
    
    func save(){
        if let error=CoreDataManager.save(){
            DialogBoxHelper.alert(view: self, error: error)
        }
    }
    
    func saveNewPrescription(withMedoc medoc : MedicamentDAO, withDateDeb dateDeb : NSDate, withDateFin dateFin : NSDate, withHeureDeb heureDeb : NSDate, withHeureFin heureFin : NSDate, withIntervalle intervalle : UITextField){
        let context = CoreDataManager.context
        let prescri = PrescriptionDAO(context: context)
        prescri.medicaments = medoc
        prescri.dateDebut = dateDeb
        prescri.dateFin = dateFin
        prescri.heureDebut = heureDeb
        prescri.heureFin = heureFin
        do{
            try context.save()
            self.prescriptions.append(prescri)
            
        }
        catch let error as NSError{
            DialogBoxHelper.alert(view: self, error: error)
            return
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func unwindToPrescriptionListAfterSavingNewPrescription(segue: UIStoryboardSegue){
        let newPrescriptionController = segue.source as! AddPrescriptionViewController
        if(newPrescriptionController.intervalleContainerView.alpha == 1){
            let addIntervalleController = newPrescriptionController.childViewControllers[0] as! IntervalleAddPrescriptionViewController
            print(addIntervalleController.dateDebutPicker.date)
            //self.saveNewPrescription()
        }
        else{
            let addPrecisController = newPrescriptionController.childViewControllers[1] as! PrecisAddPrescriptionViewController
            //self.saveNewPrescription()
        }
        
        self.prescriptionTable.reloadData()
    }

}
