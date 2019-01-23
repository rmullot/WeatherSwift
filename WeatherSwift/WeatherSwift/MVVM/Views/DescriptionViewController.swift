//
//  DescriptionViewController.swift
//  WeatherSwift
//
//  Created by Romain Mullot on 22/01/2019.
//  Copyright © 2019 Romain Mullot. All rights reserved.
//

import UIKit

class DescriptionViewController: UIViewController {

   @IBOutlet weak var snowLabel: UILabel!
   @IBOutlet weak var rainLabel: UILabel!
   @IBOutlet weak var pressureLabel: UILabel!
  
    override func viewDidLoad() {
      super.viewDidLoad()
      self.view.accessibilityIdentifier = UITestingIdentifiers.descriptionViewController.rawValue
      pressureLabel.text = viewModel.pressure
      rainLabel.text = viewModel.rain
      snowLabel.text = viewModel.snowRisk
        // Do any additional setup after loading the view.
    }
  
  var viewModel: DescriptionViewModel! 

}
