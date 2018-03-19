//
//  AddPrescriptionViewController.swift
//  Pilalheure
//
//  Created by Vincent Herreros on 13/03/2018.
//  Copyright © 2018 Vincent HERREROS. All rights reserved.
//

import UIKit

class AddPrescriptionViewController: UIViewController {
    
    @IBOutlet weak var precisContainerView: UIView!
    @IBOutlet weak var intervalleContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        guard let embedIntervalleAddViewController = self.childViewControllers[0] as? IntervalleAddPrescriptionViewController
            else {return}
        let medoc : String = embedIntervalleAddViewController.medicamentPickerText.text ?? ""
        guard (medoc != "") else {return}
        let prescription = PrescriptionDAO(context: CoreDataManager.context)
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func showComponents(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.intervalleContainerView.alpha = 1
                self.precisContainerView.alpha = 0
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.intervalleContainerView.alpha = 0
                self.precisContainerView.alpha = 1
            })
        }
    }
    
}
