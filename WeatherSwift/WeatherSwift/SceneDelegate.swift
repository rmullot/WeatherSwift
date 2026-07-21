//
//  SceneDelegate.swift
//  WeatherSwift
//

import UIKit
import WeatherCore
import WeatherUI
import FTLinearActivityIndicator

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?
  var navigationController: UINavigationController!

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }

    let newWindow = UIWindow(windowScene: windowScene)
    let searchViewController = WeatherCollectionViewController.initFromNib()
    navigationController = UINavigationController(rootViewController: searchViewController)
    newWindow.rootViewController = navigationController
    newWindow.makeKeyAndVisible()
    window = newWindow
    UIApplication.configureLinearNetworkActivityIndicatorIfNeeded()
  }

  func sceneWillEnterForeground(_ scene: UIScene) {
    // Called as the scene transitions from the background to the foreground; undo the changes made on entering the background.
  }
}
