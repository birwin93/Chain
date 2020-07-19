import Danger 
let danger = Danger()

if danger.git.createdFiles.count > 1 {
    warn("Please add tests if you've created more than one file")
}

SwiftLint.lint(
    .modifiedAndCreatedFiles(directory: nil),
    inline: true,
    configFile: ".swiftlint.yml",
    strict: true,
    quiet: false,
    swiftlintPath: danger.utils.exec("mint which swiftlint")
)
