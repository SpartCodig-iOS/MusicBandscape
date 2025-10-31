//
//  MusicDetailUseCase.swift
//  UseCase
//
//  Created by Wonji Suh  on 10/31/25.
//

import Foundation

import Entity
import DomainInterface
import DataInterface
import Repository

import WeaveDI
import ComposableArchitecture

public struct MusicDetailUseCase: MusicDetailUseCaseProtocol {
  private let repository: MusicDetailRepositoryProtocol

  nonisolated public init(
    repository: MusicDetailRepositoryProtocol
  ) {
    self.repository = repository
  }


  public func fetchTrackDetail(id: Int) async throws -> MusicItem {
    let dtos = try await repository.fetchDetailMusic(id: "\(id)")

    guard let track = dtos.first?.toDomain() else {
      throw URLError(.badServerResponse)
    }
    return track
  }
}


extension MusicDetailUseCase: DependencyKey {
  public static var liveValue: MusicDetailUseCaseProtocol {
    let repository  = UnifiedDI.register(MusicDetailRepositoryProtocol.self) {
      MusicDetailRepository()
    }
    return MusicDetailUseCase(repository: repository)
  }

  public static var testValue = MusicDetailRepository()

  public static var previewValue: MusicDetailUseCaseProtocol {
    let repository  = UnifiedDI.register(MusicDetailRepositoryProtocol.self) {
      MusicDetailRepository()
    }
    return MusicDetailUseCase(repository: repository)
  }
}

@AutoSyncExtension
extension DependencyValues {
  var musicDetailUseCase: MusicDetailUseCaseProtocol {
    get { self[MusicDetailUseCase.self] }
    set { self[MusicDetailUseCase.self] = newValue }
  }
}


public extension RegisterModule {
  var musicDetailUseCaseModule: @Sendable () -> Module {
    makeUseCaseWithRepository(
      MusicDetailUseCaseProtocol.self,
      repositoryProtocol: MusicDetailRepositoryProtocol.self,
      repositoryFallback: MockMusicDetailRepository(),
      factory: { repo in
        return MusicDetailUseCase(repository: repo)
      }
    )
  }

  var musicDetailRepositoryModule: @Sendable () -> Module {
    makeDependency(MusicDetailRepositoryProtocol.self) {
      MusicDetailRepository()
    }
  }
}

