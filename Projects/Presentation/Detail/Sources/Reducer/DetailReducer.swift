//
//  DetailReducer.swift
//  Detail
//
//  Created by Wonji Suh  on 10/27/25.
//


import Foundation
import ComposableArchitecture

import Core
import LogMacro

@Reducer
public struct DetailReducer {
  public init() {}

  @ObservableState
  public struct State: Equatable {

    @Shared var musicItem: MusicItem?
    var isLoading: Bool
    public init(
      musicItem: MusicItem?,
      isLoading: Bool = true
    ) {
      self._musicItem = Shared(wrappedValue: musicItem, .inMemory("MusicItem"))
      self.isLoading = isLoading
    }
  }

  public enum Action: ViewAction, BindableAction {
    case binding(BindingAction<State>)
    case view(View)
    case async(AsyncAction)
    case inner(InnerAction)
    case navigation(NavigationAction)

  }

  //MARK: - ViewAction
  @CasePathable
  public enum View {
    case onAppear
  }


  //MARK: - AsyncAction 비동기 처리 액션
  public enum AsyncAction: Equatable {
    case searchDetailMusic
  }

  //MARK: - 앱내에서 사용하는 액션
  public enum InnerAction {
    case detailMusicResponse(Result<MusicItem, Error>)
  }

  //MARK: - NavigationAction
  public enum NavigationAction: Equatable {
    case backToHome

  }

  private enum CancelID: Hashable {
    case detailScreen
  }

  @Dependency(\.continuousClock) var clock
  @Dependency(MusicSearchUseCase.self) var musicSearchUseCase

  public var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
        case .binding(_):
          return .none

        case .view(let viewAction):
          return handleViewAction(state: &state, action: viewAction)

        case .async(let asyncAction):
          return handleAsyncAction(state: &state, action: asyncAction)

        case .inner(let innerAction):
          return handleInnerAction(state: &state, action: innerAction)

        case .navigation(let navigationAction):
          return handleNavigationAction(state: &state, action: navigationAction)
      }
    }
  }
}

extension DetailReducer {
  private func handleViewAction(
    state: inout State,
    action: View
  ) -> Effect<Action> {
    switch action {
      case .onAppear:
        state.isLoading = true
        return .send(.async(.searchDetailMusic))
    }
  }

  private func handleAsyncAction(
    state: inout State,
    action: AsyncAction
  ) -> Effect<Action> {
    switch action {
      case .searchDetailMusic:
        return .run { [musicItem = state.musicItem] send in
          try? await clock.sleep(for: .seconds(2))

          let searchDetailMusicResult = await Result {
            try await musicSearchUseCase.fetchTrackDetail(id: musicItem?.trackId ?? .zero)
          }

          switch searchDetailMusicResult {
            case .success(let musicDetailData):
              await send(.inner(.detailMusicResponse(.success(musicDetailData))))

            case .failure(let error):
              await send(.inner(.detailMusicResponse(.failure(error))))
          }
        }
        .cancellable(id: CancelID.detailScreen, cancelInFlight: true)
    }
  }

  private func handleNavigationAction(
    state: inout State,
    action: NavigationAction
  ) -> Effect<Action> {
    switch action {
      case .backToHome:
        return .none
    }
  }

  private func handleInnerAction(
    state: inout State,
    action: InnerAction
  ) -> Effect<Action> {
    switch action {
      case .detailMusicResponse(let result):
        switch result {
          case .success(let data):
            state.$musicItem.withLock { $0 = data }

          case .failure(let error):
            #logError("데이터가져오기 실패", error.localizedDescription)
        }
        state.isLoading = false
        return .none
    }
  }
}
