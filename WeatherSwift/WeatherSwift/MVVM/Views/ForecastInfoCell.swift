//
//  ForecastInfoCell.swift
//  WeatherSwift
//
//  Created by Romain Mullot on 02/02/2019.
//  Copyright © 2019 Romain Mullot. All rights reserved.
//

import UIKit

final class ForecastInfoCell: UICollectionViewCell {

  @IBOutlet weak var weatherIcon: UIImageView!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var temperatureLabel: UILabel!

  weak var viewModel: ForecastViewModel! {
    didSet {
      self.weatherIcon.loadImageWithUrl(viewModel.forecastImageURL, placeHolder: UIImage(named: "placeholder"))
      self.dateLabel.text = viewModel.date
      self.temperatureLabel.text = viewModel.weatherDescription
    }
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

}
