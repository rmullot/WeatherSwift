//
//  ForecastInfoCell.swift
//  WeatherSwift
//
//  Created by Romain Mullot on 22/01/2019.
//  Copyright © 2019 Romain Mullot. All rights reserved.
//

import UIKit

final class ForecastInfoCell: UITableViewCell {

    static let cellID = "ForecastInfoCellID"

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    weak var viewModel: ForecastViewModel! {
        didSet {
            self.dateLabel.text = viewModel.date
            self.temperatureLabel.text = viewModel.weatherDescription
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
    }

}
