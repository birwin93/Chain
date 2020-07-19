import Foundation
import ChainCore
import Chains

final class MainChainGroup: ChainGroup {
    
    static let name: String = "chain"
    
    static let chains: [Chain.Type] = [
        PackageChainGroup.self
    ]
}

MainChainGroup.main()
