import Foundation
import ProjectDescription
import DependencyPlugin
import ProjectTemplatePlugin
import ProjectTemplatePlugin
import DependencyPackagePlugin

let project = Project.makeAppModule(
  name: "Detail",
  bundleId: .appBundleID(name: ".Detail"),
  product: .staticFramework,
  settings:  .settings(),
  dependencies: [
    .Shared(implements: .Shared),
    .Core(implements: .Core),
  ],
  sources: ["Sources/**"]
)
