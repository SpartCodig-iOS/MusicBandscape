//
//  Project+Template.swift
//  MyPlugin
//
//  Created by 서원지 on 1/6/24.
//

import ProjectDescription

public extension Project {
  static func makeAppModule(
    name: String = Environment.appName,
    bundleId: String,
    platform: Platform = .iOS,
    product: Product,
    packages: [Package] = [],
    deploymentTarget: ProjectDescription.DeploymentTargets = Environment.deploymentTarget,
    destinations: ProjectDescription.Destinations = Environment.deploymentDestination,
    settings: ProjectDescription.Settings,
    scripts: [ProjectDescription.TargetScript] = [],
    dependencies: [ProjectDescription.TargetDependency] = [],
    sources: ProjectDescription.SourceFilesList = ["Sources/**"],
    resources: ProjectDescription.ResourceFileElements? = nil,
    infoPlist: ProjectDescription.InfoPlist = .default,
    entitlements: ProjectDescription.Entitlements? = nil,
    schemes: [ProjectDescription.Scheme] = []
  ) -> Project {

    let appTarget: Target = .target(
      name: name,
      destinations: destinations,
      product: product,
      bundleId: bundleId,
      deploymentTargets: deploymentTarget,
      infoPlist: infoPlist,
      sources: sources,
      resources: resources,
      entitlements: entitlements,
      scripts: scripts,
      dependencies: dependencies
    )

    let appProdTarget: Target = .target(
      name: "\(name)-Prod",
      destinations: destinations,
      product: product,
      bundleId: "\(bundleId)",
      deploymentTargets: deploymentTarget,
      infoPlist: infoPlist,
      sources: sources,
      resources: resources,
      entitlements: entitlements,
      scripts: scripts,
      dependencies: dependencies
    )


    let appStageTarget: Target = .target(
      name: "\(name)-Stage",
      destinations: destinations,
      product: product,
      bundleId: "\(bundleId)",
      deploymentTargets: deploymentTarget,
      infoPlist: infoPlist,
      sources: sources,
      resources: resources,
      entitlements: entitlements,
      scripts: scripts,
      dependencies: dependencies
    )


    let appDevTarget: Target = .target(
      name: "\(name)-Debug",
      destinations: destinations,
      product: product,
      bundleId: "\(bundleId)",
      deploymentTargets: deploymentTarget,
      infoPlist: infoPlist,
      sources: sources,
      resources: resources,
      entitlements: entitlements,
      scripts: scripts,
      dependencies: dependencies
    )

    let appTestTarget : Target = .target(
      name: "\(name)Tests",
      destinations: destinations,
      product: .unitTests,
      bundleId: "\(bundleId).\(name)Tests",
      deploymentTargets: deploymentTarget,
      infoPlist: .default,
      sources: ["\(name)Tests/Sources/**"],
      dependencies: [.target(name: name)]
    )

    let targets = [appTarget, appDevTarget, appStageTarget, appProdTarget ,appTestTarget]

    return Project(
      name: name,
      options: .options(
        defaultKnownRegions: ["en", "ko"],
        developmentRegion: "ko"
      ),
      packages: packages,
      settings: settings,
      targets: targets,
      schemes: schemes
    )
  }

  static func makeModule(
    name: String = Environment.appName,
    bundleId: String,
    platform: Platform = .iOS,
    product: Product,
    packages: [Package] = [],
    deploymentTarget: ProjectDescription.DeploymentTargets = Environment.deploymentTarget,
    destinations: ProjectDescription.Destinations = Environment.deploymentDestination,
    settings: ProjectDescription.Settings,
    scripts: [ProjectDescription.TargetScript] = [],
    dependencies: [ProjectDescription.TargetDependency] = [],
    sources: ProjectDescription.SourceFilesList = ["Sources/**"],
    resources: ProjectDescription.ResourceFileElements? = nil,
    infoPlist: ProjectDescription.InfoPlist = .default,
    entitlements: ProjectDescription.Entitlements? = nil,
    schemes: [ProjectDescription.Scheme] = []
  ) -> Project {
    
    let appTarget: Target = .target(
      name: name,
      destinations: destinations,
      product: product,
      bundleId: bundleId,
      deploymentTargets: deploymentTarget,
      infoPlist: infoPlist,
      sources: sources,
      resources: resources,
      entitlements: entitlements,
      scripts: scripts,
      dependencies: dependencies
    )
    
    let appDevTarget: Target = .target(
      name: "\(name)-QA",
      destinations: destinations,
      product: product,
      bundleId: "\(bundleId)",
      deploymentTargets: deploymentTarget,
      infoPlist: infoPlist,
      sources: sources,
      resources: resources,
      entitlements: entitlements,
      scripts: scripts,
      dependencies: dependencies
    )
    
    let appTestTarget : Target = .target(
      name: "\(name)Tests",
      destinations: destinations,
      product: .unitTests,
      bundleId: "\(bundleId).\(name)Tests",
      deploymentTargets: deploymentTarget,
      infoPlist: .default,
      sources: ["\(name)Tests/Sources/**"],
      dependencies: [.target(name: name)]
    )
    
    let targets = [appTarget, appDevTarget, appTestTarget]
    
    return Project(
      name: name,
      packages: packages,
      settings: settings,
      targets: targets,
      schemes: schemes
    )
  }
}



extension Scheme {
  public static func makeScheme(target: ConfigurationName, name: String) -> Scheme {
    return Scheme.scheme(
      name: name,
      shared: true,
      buildAction: .buildAction(targets: ["\(name)"]),
      testAction: .targets(
        ["\(name)Tests"],
        configuration: target,
        options: .options(coverage: true, codeCoverageTargets: ["\(name)"])
      ),
      runAction: .runAction(configuration: target),
      archiveAction: .archiveAction(configuration: target),
      profileAction: .profileAction(configuration: target),
      analyzeAction: .analyzeAction(configuration: target)
      
    )
    
  }
  

}


public extension Scheme {
    static func scheme(name: String, environment: ConfiguratuonEnviroment) -> Scheme {
      let appName = Project.Environment.appName
        let schemeName = switch environment {
        case .prod: appName
        case .dev, .stage: "\(appName)-\(environment.name)"
        }

        return .scheme(
            name: schemeName,
            buildAction: .buildAction(targets: [.target(name)]),
            runAction: .runAction(configuration: .init(stringLiteral: environment.name)),
            archiveAction: .archiveAction(configuration: .release),
            profileAction: .profileAction(configuration: .release),
            analyzeAction: .analyzeAction(configuration: .debug)
        )
    }
}
