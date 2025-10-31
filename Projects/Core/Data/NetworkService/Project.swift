import Foundation
import ProjectDescription
import DependencyPlugin
import ProjectTemplatePlugin
import DependencyPackagePlugin

let project = Project.makeAppModule(
  name: "NetworkService",
  bundleId: .appBundleID(name: ".NetworkService"),
  product: .staticFramework,
  settings:  .settings(),
  dependencies: [
    .SPM.asyncMoya,
    .Network(implements: .Networking),
    .Data(implements: .API)
  ],
  sources: ["Sources/**"]
)
