import Foundation
import ProjectDescription
import DependencyPlugin
import ProjectTemplatePlugin
import ProjectTemplatePlugin
import DependencyPackagePlugin

let project = Project.makeAppModule(
  name: "Splash",
  bundleId: .appBundleID(name: ".Splash"),
  product: .staticFramework,
  settings:  .settings(),
  dependencies: [
    .Shared(implements: .Shared),
    .Domain(implements: .UseCase),
  ],
  sources: ["Sources/**"]
)
