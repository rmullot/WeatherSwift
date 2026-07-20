//
//  DescriptionViewController.swift
//  WeatherSwift
//
//  Created by Romain Mullot on 02/02/2019.
//  Copyright © 2019 Romain Mullot. All rights reserved.
//

import UIKit

final class DescriptionViewController: BaseViewController<DescriptionViewModel> {

  @IBOutlet weak var humidityLabel: UILabel!
  @IBOutlet weak var weatherLabel: UILabel!
  @IBOutlet weak var snowLabel: UILabel!
  @IBOutlet weak var rainLabel: UILabel!
  @IBOutlet weak var pressureLabel: UILabel!
  @IBOutlet weak var cloudsLabel: UILabel!

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.accessibilityIdentifier = UITestingIdentifiers.descriptionViewController.rawValue
    refreshView()
    // Do any additional setup after loading the view.
  }

  private func refreshView() {
    pressureLabel.text = viewModel.pressure
    rainLabel.text = viewModel.rain
    snowLabel.text = viewModel.snowRisk
    weatherLabel.text = viewModel.weatherType
    cloudsLabel.text = viewModel.clouds
    humidityLabel.text = viewModel.humidity
  }

}
