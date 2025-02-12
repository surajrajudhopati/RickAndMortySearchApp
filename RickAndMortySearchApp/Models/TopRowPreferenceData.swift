//
//  TopRowPreferenceData.swift
//  RickAndMortySearchApp
//
//  Created by Suraj Raju Dhopati on 2/11/25.
//

import SwiftUI

struct TopRowPreferenceData: Equatable {
    let id: Int
    let minY: CGFloat
}

struct TopRowPreferenceKey: PreferenceKey {
    typealias Value = TopRowPreferenceData?
    
    static var defaultValue: TopRowPreferenceData? = nil
    
    static func reduce(value: inout TopRowPreferenceData?, nextValue: () -> TopRowPreferenceData?) {
        if let next = nextValue() {
            if let current = value {
                value = next.minY < current.minY ? next : current
            } else {
                value = next
            }
        }
    }
}
