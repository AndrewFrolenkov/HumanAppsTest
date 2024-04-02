//
//  SceneDelegate.swift
//  HumanAppsTest
//
//  Created by Андрей Фроленков on 1.04.24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    
    guard let windowScene = (scene as? UIWindowScene) else { return }
    
    let tabBarController = TabBarBuilder.build()
  
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.windowScene = windowScene
    window?.rootViewController = tabBarController
    window?.makeKeyAndVisible()
  }
  
}

