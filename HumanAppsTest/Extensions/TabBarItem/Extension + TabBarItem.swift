//
//  Extension + TabBarItem.swift
//  HumanAppsTest
//
//  Created by Андрей Фроленков on 1.04.24.
//

import Foundation
import UIKit

extension UITabBarItem {
  
  convenience init(title: Constant.TitleForControllers, image: Constant.ImageForControllers, tag: Int) {
    self.init(title: title.rawValue, image: UIImage(systemName: image.rawValue), tag: tag)
  }
}
