//
//  AppDelegate.swift
//  MusicBandscape
//
//  Created by Wonji Suh  on 10/22/25.
//

import UIKit
import WeaveDI
import Perception

class AppDelegate: UIResponder, UIApplicationDelegate {

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    WeaveDI.Container.bootstrapInTask { _ in
      await AppDIManager.shared.registerDefaultDependencies()
    }

    isPerceptionCheckingEnabled = false

    return true
  }
}

