import Foundation
import ProjectDescription
import DependencyPlugin
import ProjectTemplatePlugin
import ProjectTemplatePlugin
import DependencyPackagePlugin

let project = Project.makeAppModule(
  name: "RootTab",
  bundleId: .appBundleID(name: ".RootTab"),
  product: .staticFramework,
  settings:  .settings(),
  dependencies: [
    .Presentation(implements: .Home),
    .Presentation(implements: .Search),
  ],
  sources: ["Sources/**"]
)
