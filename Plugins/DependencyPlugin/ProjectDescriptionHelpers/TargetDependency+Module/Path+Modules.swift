//
//  Path+Modules.swift
//  Plugins
//
//  Created by 서원지 on 2/21/24.
//

import Foundation
import ProjectDescription


// MARK: - Presentation
public extension ProjectDescription.Path {
  static var Presentation: Self {
      return .relativeToRoot("Projects/\(ModulePath.Presentations.name)")
  }
  static func Presentation(implementation module: ModulePath.Presentations) -> Self {
      return .relativeToRoot("Projects/\(ModulePath.Presentations.name)/\(module.rawValue)")
  }
}

// MARK: - Core
public extension ProjectDescription.Path {
  static var Core: Self {
    return .relativeToRoot("Projects/\(ModulePath.Cores.name)")
  }
  
  static func Core(implementation module: ModulePath.Cores) -> Self {
    return .relativeToRoot("Projects/\(ModulePath.Cores.name)/\(module.rawValue)")
  }
}


// MARK: ProjectDescription.Path + DesignSystem
public extension ProjectDescription.Path {
  static var Shared: Self {
    return .relativeToRoot("Projects/\(ModulePath.Shareds.name)")
  }
  
  static func Shared(implementation module: ModulePath.Shareds) -> Self {
    return .relativeToRoot("Projects/\(ModulePath.Shareds .name)/\(module.rawValue)")
  }
}

// MARK: - Network
public extension ProjectDescription.Path {
  static var Networking: Self {
    return .relativeToRoot("Projects/\(ModulePath.Cores.name)/\(ModulePath.Networks.name)")
  }
  
  static func Network(implementation module: ModulePath.Networks) -> Self {
    return .relativeToRoot("Projects/\(ModulePath.Cores.name)/\(ModulePath.Networks.name)/\(module.rawValue)")
  }
}

// MARK: - Domain
public extension ProjectDescription.Path {
  static var Domain: Self {
    return .relativeToRoot("Projects/\(ModulePath.Cores.name)/\(ModulePath.Domains.name)")
  }

  static func Domain(implementation module: ModulePath.Domains) -> Self {
    return .relativeToRoot("Projects/\(ModulePath.Cores.name)/\(ModulePath.Domains.name)/\(module.rawValue)")
  }
}

// MARK: - Data
public extension ProjectDescription.Path {
  static var Data: Self {
    return .relativeToRoot("Projects/\(ModulePath.Cores.name)/\(ModulePath.Datas.name)")
  }

  static func Data(implementation module: ModulePath.Datas) -> Self {
    return .relativeToRoot("Projects/\(ModulePath.Cores.name)/\(ModulePath.Datas.name)/\(module.rawValue)")
  }
}
