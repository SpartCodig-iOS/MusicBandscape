//
//   MusicSearchUseCase.swift
//  UseCase
//
//  Created by Wonji Suh  on 10/24/25.
//

import Foundation

import Entity
import DomainInterface
import DataInterface
import Repository

import WeaveDI
import ComposableArchitecture

public struct MusicSearchUseCase: MusicSearchUseCaseProtocol {
  private let repository: MusicSearchRepositoryProtocol

  nonisolated public init(
    repository: MusicSearchRepositoryProtocol
  ) {
    self.repository = repository
  }

  public func searchMusic(searchQuery: String) async throws -> [Entity.MusicItem] {
    let dto = try await repository.fetchMusic(search: searchQuery)
    return dto.toDomain()
  }

  public func fetchTrackDetail(id: Int) async throws -> MusicItem {
    let dtos = try await repository.fetchDetailMusic(id: "\(id)")

    guard let track = dtos.first?.toDomain() else {
      throw URLError(.badServerResponse)
    }
    return track
  }
}


extension MusicSearchUseCase: DependencyKey {
  public static var liveValue: MusicSearchUseCaseProtocol {
    let repository: MusicSearchRepositoryProtocol = UnifiedDI.register(MusicSearchRepositoryProtocol.self) {
      MusicSearchRepository()
    }
    return MusicSearchUseCase(repository: repository)
  }


  public static var testValue = MockMusicSearchRepository()


  public static var previewValue: MusicSearchUseCaseProtocol {
    let repository: MusicSearchRepositoryProtocol = UnifiedDI.register(MusicSearchRepositoryProtocol.self) {
      MusicSearchRepository()
    }
    return MusicSearchUseCase(repository: repository)
  }
}

@AutoSyncExtension
extension DependencyValues {
  var musicUseCase: MusicSearchUseCaseProtocol {
    get { self[MusicSearchUseCase.self] }
    set { self[MusicSearchUseCase.self] = newValue }
  }
}


public extension RegisterModule {
  var musicUseCaseModule: @Sendable () -> Module {
    makeUseCaseWithRepository(
      MusicSearchUseCaseProtocol.self,
      repositoryProtocol: MusicSearchRepositoryProtocol.self,
      repositoryFallback: MockMusicSearchRepository(),
      factory: { repo in
        return MusicSearchUseCase(repository: repo)
      }
    )
  }

  var musicRepositoryModule: @Sendable () -> Module {
    makeDependency(MusicSearchRepositoryProtocol.self) {
      MusicSearchRepository()
    }
  }
}
