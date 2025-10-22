//
//  Extension+AppDIContainer.swift
//  MusicBandscape
//
//  Created by Wonji Suh  on 10/22/25.
//

import WeaveDI

extension AppWeaveDI.Container {
  @DIContainerActor
  func registerDefaultDependencies() async {
    await registerDependencies(logLevel: .errors) { container in
      // Repository 먼저 등록
      let factory = ModuleFactoryManager()

      await factory.registerAll(to: container)
    }
  }
}
