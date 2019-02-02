//
//  DescriptionViewController.swift
//  WeatherSwift
//
//  Created by Romain Mullot on 02/02/2019.
//  Copyright © 2019 Romain Mullot. All rights reserved.
//

import UIKit

final class DescriptionViewController: BaseViewController<DescriptionViewModel> {

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

}
