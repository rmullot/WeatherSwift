//
//  UIViewController+Weather.swift
//  WeatherUI
//
//  Created by Romain Mullot on 02/02/2019.
//  Copyright © 2019 Romain Mullot. All rights reserved.
//

extension UIViewController {

  public static func initFromNib() -> Self {
    func loadFromNib<T: UIViewController>() -> T {
      return T(nibName: String(describing: self), bundle: nil)
    }
    return loadFromNib()
  }
}

extension UITableView {

  public func registerReusableCell<T: UITableViewCell>(_: T.Type) {
    self.register(UINib(nibName: String(describing: T.self), bundle: nil), forCellReuseIdentifier: String(describing: T.self))
  }

  public func dequeueReusableCell<T: UITableViewCell>(_: T.Type, indexPath: IndexPath) -> T {
    guard let cell = self.dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as? T else {
      fatalError("Cell of type \(T.self) is not registered")
    }
    return cell
  }

  public func registerReusableView<T: UITableViewHeaderFooterView>(_: T.Type) {
    self.register(UINib(nibName: String(describing: T.self), bundle: nil), forHeaderFooterViewReuseIdentifier: String(describing: T.self))
  }

  public func dequeueReusableView<T: UITableViewHeaderFooterView>(_: T.Type) -> T {
    guard let view = self.dequeueReusableHeaderFooterView(withIdentifier: String(describing: T.self)) as? T else {
      fatalError("View of type \(T.self) is not registered")
    }
    return view
  }
}

extension UICollectionView {

  public func registerReusableCell<T: UICollectionViewCell>(_: T.Type) {
    self.register(UINib(nibName: String(describing: T.self), bundle: nil), forCellWithReuseIdentifier: String(describing: T.self))
  }

  public func registerReusableFooter<T: UICollectionReusableView>(_: T.Type) {
    self.register(UINib(nibName: String(describing: T.self), bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: T.self))
  }

  public func registerReusableHeader<T: UICollectionReusableView>(_: T.Type) {
    self.register(UINib(nibName: String(describing: T.self), bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: T.self))
  }

  public func dequeueReusableCell<T: UICollectionViewCell>(_: T.Type, indexPath: IndexPath) -> T {
    guard let cell = self.dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as? T else {
      fatalError("Cell of type \(T.self) is not registered")
    }
    return cell
  }

  public func dequeueReusableHeader<T: UICollectionReusableView>(_: T.Type, indexPath: IndexPath) -> T {
    guard let view = self.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: T.self), for: indexPath) as? T else {
      fatalError("Header of type \(T.self) is not registered")
    }
    return view
  }

  public func dequeueReusableFooter<T: UICollectionReusableView>(_: T.Type, indexPath: IndexPath) -> T {
    guard let view = self.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: T.self), for: indexPath) as? T else {
      fatalError("Footer of type \(T.self) is not registered")
    }
    return view
  }
}
