//
//  DIRegistry.swift
//  MusicBandscape
//
//  Created by Wonji Suh  on 10/22/25.
//


import WeaveDI
import Core

/// 모든 의존성을 자동으로 등록하는 레지스트리
extension WeaveDI.Container {
  private static let helper = RegisterModule()

  ///  Repository 등록
  static func registerRepositories() async {
    let repositories: [Module] = [
      helper.musicRepositoryModule()
    ]

    await repositories.asyncForEach { module in
      await module.register()
    }
  }

  ///  UseCase 등록
  static func registerUseCases() async {

    let useCases: [Module] = [
      helper.musicUseCaseModule()
    ]

    await useCases.asyncForEach { module in
      await module.register()
    }
  }
}
