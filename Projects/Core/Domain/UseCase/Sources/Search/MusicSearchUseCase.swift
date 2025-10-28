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
  public func getCategoryCount(
    from results: [MusicItem],
    category: SearchCategory
  public func searchMedia(
    query: String,
    media: String,
    entity: String
  ) async  throws -> [MusicItem] {
    let dtos = try await repository.searchMedia(query: query, media: media, entity: entity)
    return dtos.toDomain()
  }

  ) -> Int {
    switch category {
  }
    }
      return results.etcCount
    case .etc:
    case .all:
      return results.count
    case .music:
      return results.musicCount
    case .movies:
      return results.movieCount
    case .podcast:
      return results.podcastCount
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
