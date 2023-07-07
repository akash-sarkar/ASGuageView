//
//  Model.swift
//  ASGuageView
//
//  Created by ST-MacBookpro on 04/07/23.
//

import Foundation
import UIKit

class ColorArrayModel {
    let color: UIColor
    let startScore: CGFloat
    let endScore: CGFloat
    let gap: CGFloat?
    
    init(color: UIColor, startAngle: CGFloat, endAngle: CGFloat, gap: CGFloat? = nil) {
        self.color = color
        self.startScore = startAngle
        self.endScore = endAngle
        self.gap = gap
    }
}
