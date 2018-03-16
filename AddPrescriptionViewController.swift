//
//  AddPrescriptionViewController.swift
//  Pilalheure
//
//  Created by Vincent Herreros on 13/03/2018.
//  Copyright © 2018 Vincent HERREROS. All rights reserved.
//

import UIKit

class AddPrescriptionViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    private lazy var intervalleViewController: IntervalleAddPrescriptionViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "IntervalleAddPrescriptionViewController") as! IntervalleAddPrescriptionViewController
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private lazy var precisViewController: PrecisAddPrescriptionViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "PrecisAddPrescriptionViewController") as! PrecisAddPrescriptionViewController
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChildViewController(viewController)
        
        // Add Child View as Subview
        view.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParentViewController: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParentViewController: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParentViewController()
    }
    
    private func updateView() {
        if segmentedControl.selectedSegmentIndex == 0 {
            remove(asChildViewController: self.intervalleViewController)
            add(asChildViewController: self.precisViewController)
        } else {
            remove(asChildViewController: self.precisViewController)
            add(asChildViewController: self.intervalleViewController)
        }
    }
    
    func setupView(){
        setupSegmentedControl()
        
        updateView()
    }
    
    func setupSegmentedControl(){
        // Configure Segmented Control
        self.segmentedControl.removeAllSegments()
        self.segmentedControl.insertSegment(withTitle: "Intervalle", at: 0, animated: false)
        self.segmentedControl.insertSegment(withTitle: "Heure précise", at: 1, animated: false)
        self.segmentedControl.addTarget(self, action: #selector(selectionDidChange(_:)), for: .valueChanged)
        
        // Select First Segment
        self.segmentedControl.selectedSegmentIndex = 0
    }
    
    func selectionDidChange(_ sender: UISegmentedControl) {
        updateView()
    }

}
