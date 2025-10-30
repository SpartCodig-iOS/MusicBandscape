import Foundation
import ProjectDescription
import DependencyPlugin
import ProjectTemplatePlugin
import DependencyPackagePlugin

let project = Project.makeAppModule(
  name: "Repository",
  bundleId: .appBundleID(name: ".Repository"),
  product: .staticFramework,
  settings:  .settings(),
  dependencies: [
    .Network(implements: .Networking),
    .Data(implements: .DataInterface),
    .Data(implements: .Service)
  ],
  sources: ["Sources/**"]
)
