//
//  UIView+Constrainst.swift
//  WeatherUI
//
//  Created by Romain Mullot on 02/02/2019.
//  Copyright © 2019 Romain Mullot. All rights reserved.
//

import Foundation

extension UIView {

  /// Add a subview to the current view wich match perfectly the size of this one
  public func addSubViewWithAutoresizingConstrainst(view: UIView) {
    guard view.superview == nil else { return }
    commonConfiguration(view)
  }

  /// Add a subview to the current view wich match perfectly the size of this one in using a xib file
  public func instantiate(from nibName: String) {
    let bundle = Bundle(for: type(of: self))
    guard let view = UINib(nibName: nibName, bundle: bundle).instantiate(withOwner: self, options: nil).first as? UIView else { return }
    commonConfiguration(view)
  }

  public static func loadFromNib<T: UIView>() -> T {
    let keyName = String(describing: T.self)
    let bundle = Bundle(for: T.self)
    guard let view = UINib(nibName: keyName, bundle: bundle).instantiate(withOwner: self, options: nil).first as? T else { fatalError() }
    return view
  }

  private func commonConfiguration(_ view: UIView) {
    view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    view.frame = bounds
    view.layer.masksToBounds = true
    view.translatesAutoresizingMaskIntoConstraints = true
    addSubview(view)
  }
}
