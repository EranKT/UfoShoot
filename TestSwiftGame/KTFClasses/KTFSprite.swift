//
//  KTFSprite.swift
//  TestSwiftGame
//
//  Created by EKT DIGIDESIGN on 12/25/17.
//  Copyright © 2017 EKT DIGIDESIGN. All rights reserved.
//

import Foundation
import SpriteKit


class KTF_Sprite: SKSpriteNode {

    open var tag: Int!
    open var isEnabled: Bool!
    open var price: Int!

    
    override func removeFromParent() {        
        super.removeFromParent()
    }
}
