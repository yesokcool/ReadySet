//
//  Traitable.swift
//  Set
//

import Foundation

protocol Traitable {
    var index: Int { get set }
    var type: Int { get set }
    
    init(_ index: Int, _ type: Int)
}
