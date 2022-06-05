
import Foundation

protocol Traitable {
    var type: Int { get }
    
    init(_ index: Int, _ type: Int)
}
