import Foundation
import ProjectDescription
import DependencyPlugin
import ProjectTemplatePlugin
import ProjectTemplatePlugin
import DependencyPackagePlugin

let project = Project.makeAppModule(
  name: "Search",
  bundleId: .appBundleID(name: ".Search"),
  product: .staticFramework,
  settings:  .settings(),
  dependencies: [
    .Presentation(implements: .Detail),
    .Core(implements: .Core),
    .Shared(implements: .Shared),
  ],
  sources: ["Sources/**"]
)
