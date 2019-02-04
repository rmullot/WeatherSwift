//
//  WeatherCollectionViewController.swift
//  WeatherSwift
//
//  Created by Romain Mullot on 02/02/2019.
//  Copyright © 2019 Romain Mullot. All rights reserved.
//

import UIKit
import WeatherUI
import WeatherCore

final class WeatherCollectionViewController: BaseViewController<WeatherInfoViewModel>, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

  @IBOutlet weak var collectionView: UICollectionView!

  private let refreshControl = UIRefreshControl()

  override func viewDidLoad() {
    super.viewDidLoad()
    self.collectionView.accessibilityIdentifier = UITestingIdentifiers.weatherCollectionViewController.rawValue
    self.title = L10n.weather
    self.collectionView.registerReusableCell(ForecastInfoCell.self)
    self.viewModel = WeatherInfoViewModel()
    collectionView.refreshControl = refreshControl
    refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
    self.viewModel.forecastsDidChange = { [weak self] viewModel in
      self?.refreshControl.endRefreshing()
      self?.collectionView.reloadData()
    }
    viewModel.updateForecasts()
  }

  @objc private func refresh(_ sender: Any) {
    viewModel.updateForecasts()
  }

  // MARK: - UICollectionViewDataSource

  public func numberOfSections (in collectionView: UICollectionView) -> Int {
    return 1
  }

  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.forecastsCount
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cellForecast = collectionView.dequeueReusableCell(ForecastInfoCell.self, indexPath: indexPath)
    cellForecast.viewModel = viewModel.getForecastViewModel(index: indexPath.row)
    return cellForecast
  }

  // MARK: - UICollectionViewDelegateFlowLayout

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return  CGSize(width: UIScreen.main.bounds.size.width / 3, height: 150)
  }

  // MARK: - UICollectionViewDelegate

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    viewModel.displayDescription(index: indexPath.row)
  }

}
