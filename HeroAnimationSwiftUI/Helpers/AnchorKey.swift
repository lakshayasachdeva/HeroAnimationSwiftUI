//
//  AnchorKey.swift
//  HeroAnimationSwiftUI
//
//  Created by Lakshaya Sachdeva on 17/10/23.
//

import Foundation
import SwiftUI

// This anchor preference key is used to store the source and destination frame values and with these values we can establish a smooth transition from the source view to the destination view
struct AnchorKey: PreferenceKey {
    static var defaultValue: [String: Anchor<CGRect>] = [:]
    static func reduce(value: inout [String: Anchor<CGRect>], nextValue: () -> [String: Anchor<CGRect>]) {
        value.merge(nextValue()) { $1 }
    }
}
