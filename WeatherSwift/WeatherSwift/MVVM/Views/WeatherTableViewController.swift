//
//  WeatherTableViewController.swift
//  WeatherSwift
//
//  Created by Romain Mullot on 02/02/2019.
//  Copyright © 2019 Romain Mullot. All rights reserved.
//

import UIKit
import WeatherUI

final class WeatherTableViewController: BaseViewController<WeatherInfoViewModel>, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet weak var tableView: UITableView!

  private let refreshControl = UIRefreshControl()

  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.accessibilityIdentifier = UITestingIdentifiers.weatherTableViewController.rawValue
    self.title = "WEATHER"
    self.tableView.registerReusableCell(ForecastInfoCell.self)
    self.viewModel = WeatherInfoViewModel()
    tableView.refreshControl = refreshControl
    refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
    self.viewModel.forecastsDidChange = { [weak self] viewModel in
      self?.refreshControl.endRefreshing()
      self?.tableView.reloadData()
    }
    viewModel.updateForecasts()
  }

  @objc private func refresh(_ sender: Any) {
    viewModel.updateForecasts()
  }

  // MARK: - UITableViewDataSource

  public func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.forecastsCount
  }

  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellForecast = tableView.dequeueReusableCell(ForecastInfoCell.self, indexPath: indexPath)
    cellForecast.viewModel = viewModel.getForecastViewModel(index: indexPath.row)
    return cellForecast
  }

  public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }

  public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 1
  }

  public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 1
  }

  // MARK: - UITableViewDelegate

  public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    return UIView()
  }

  public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return UIView()
  }

  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    viewModel.displayDescription(index: indexPath.row)
  }

}
