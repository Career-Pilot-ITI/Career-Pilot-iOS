//
//  ShakeEffect.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 15/07/2026.
//

import SwiftUI

struct ShakeEffect: GeometryEffect {

    var shakes: CGFloat

    var animatableData: CGFloat {
        get { shakes }
        set { shakes = newValue }
    }

    func effectValue(size: CGSize) -> ProjectionTransform {

        let translation = 6 * sin(shakes * .pi * 4)

        return ProjectionTransform(
            CGAffineTransform(
                translationX: translation,
                y: 0
            )
        )
    }
}
