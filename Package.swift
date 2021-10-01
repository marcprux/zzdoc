// swift-tools-version:5.0

import PackageDescription

let package = Package(
  name: "zzdoc",
  platforms: [ .macOS(.v10_14), .iOS(.v11) ],
  
  products: [
    .library(name: "DocCHTMLExporter", targets: [ "DocCHTMLExporter" ]),
    .library(name: "DocCStaticExporter", targets: [ "DocCStaticExporter" ]),
    .executable(name: "zzdoc", targets: [ "zzdoc" ])
  ],
  
  dependencies: [
    .package(url: "https://github.com/marcprux/DocCArchive.git", .branch("main")),
    .package(url: "https://github.com/AlwaysRightInstitute/mustache.git", from: "1.0.1"),
    .package(url: "https://github.com/apple/swift-log.git", from: "1.4.0")
  ],
  
  targets: [
    .target(name: "DocCHTMLExporter",
            dependencies: [ "DocCArchive", "mustache", "Logging" ]),
    .target(name: "DocCStaticExporter",
            dependencies: [ "DocCArchive", "DocCHTMLExporter", "Logging" ]),
    .target(name: "zzdoc",
            dependencies: [ "DocCStaticExporter", "Logging" ])
  ]
)
