import Danger 
let danger = Danger()

if danger.git.createdFiles.count > 1 {
    warn("Please add tests if you've created more than one file")
}