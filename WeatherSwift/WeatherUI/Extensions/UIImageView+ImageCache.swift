//
//  ImageCache.swift
//  WeatherUI
//
//  Created by Romain Mullot on 02/02/2019.
//  Copyright © 2019 Romain Mullot. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
import WeatherCore

extension UIImageView {

  public func loadImageWithUrl(_ urlString: String, placeHolder: UIImage?) {
    urlString.isUrl({ (success, url) in
      guard success, let url = url else { return }
      let filter = AspectScaledToFillSizeFilter( size: self.frame.size )
      NetworkActivityService.sharedInstance.newRequestStarted()
      self.af.setImage(withURL: url, placeholderImage: placeHolder, filter: filter, imageTransition: .crossDissolve(0.2), runImageTransitionIfCached: true) { _ in
        NetworkActivityService.sharedInstance.requestFinished()
      }
    })
  }

}
