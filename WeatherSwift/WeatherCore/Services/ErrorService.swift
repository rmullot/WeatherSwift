//
//  ErrorService.swift
//  WeatherSwift
//
//  Created by Romain Mullot on 22/01/2019.
//  Copyright © 2019 Romain Mullot. All rights reserved.
//

import Foundation
import SwiftMessages

public protocol ErrorServiceProtocol {
  func showErrorMessage(message: String)
}

public final class ErrorService: ErrorServiceProtocol {

  public static let sharedInstance = ErrorService()

  private let marginMessageBox: CGFloat = 20

  public func showErrorMessage(message: String) {
    let view = MessageView.viewFromNib(layout: .cardView)
    view.configureTheme(.error)
    view.configureContent(title: L10n.errorTitle, body: message)
    SwiftMessages.show {
      view.configureDropShadow()
      view.button?.isHidden = true
      view.layoutMarginAdditions = UIEdgeInsets(top: self.marginMessageBox, left: self.marginMessageBox, bottom: self.marginMessageBox, right: self.marginMessageBox)
      (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
      return view
    }
  }

  private init() {}

}
