//
//  TabBarBuilder.swift
//  HumanAppsTest
//
//  Created by Андрей Фроленков on 1.04.24.
//

import Foundation
import UIKit

enum Constant {
  
  enum TitleForControllers: String {
    case firstController = "Main"
    case secondController = "Settings"
  }
  
  enum ImageForControllers: String {
    case imageFirst = "scribble.variable"
    
    // TODO:
    // case secondController = "setYourImage"
   
  }
  
}

class TabBarBuilder {
    static func build() -> UITabBarController {
        let tabBarController = UITabBarController()

        // Создание экранов для TabBar
        let firstScreenViewModel = FirstViewModel()
        let firstScreenViewController = FirstViewController(viewModel: firstScreenViewModel)
      
        let secondScreenViewModel = SecondViewModel()
        let secondScreenViewController = SecondViewController(viewModel: secondScreenViewModel)
      
      // Обертка первого экрана в UINavigationController
            let firstNavigationController = UINavigationController(rootViewController: firstScreenViewController)

        // Настройка контроллеров на TabBarController
        tabBarController.setViewControllers([firstNavigationController, secondScreenViewController], animated: false)

        // Настройка вкладок TabBar
      firstScreenViewController.tabBarItem = UITabBarItem(title: .firstController, image: .imageFirst, tag: 0)
      secondScreenViewController.tabBarItem = UITabBarItem(title: .secondController, image: .imageFirst, tag: 1)
      


        return tabBarController
    }
}
