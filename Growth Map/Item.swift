//
//  Item.swift
//  Growth Map
//
//  Created by Baurzhan Beglerov on 15.11.2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
