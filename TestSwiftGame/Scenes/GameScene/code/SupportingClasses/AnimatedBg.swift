//
//  AnimatedBg.swift
//  TestSwiftGame
//
//  Created by EKT DIGIDESIGN on 12/26/17.
//  Copyright © 2017 EKT DIGIDESIGN. All rights reserved.
//

import Foundation
import Foundation
import SpriteKit
import GameplayKit

 let BACKGROUNDS_FILES_PREFIX = "bg_anim_"

let ANIMATED_BG_POS = [
    [50, 50],
    [50, 150]
]


class AnimatedBg: KTF_Sprite {
    

    var _timer: Timer!
    
    var _spritesArray_middle: [KTF_Sprite] = [KTF_Sprite]()
    var _spritesArray_from_up: [KTF_Sprite] = [KTF_Sprite]()
        
    var _speed: CGFloat!
    var _speedDelta: CGFloat!
    var _screenHeight: CGFloat!
    var _maxSpeed: CGFloat!
    
    func initScrollElements()
    {
        _maxSpeed = 7.0;

        self.setScrollSpeed(speed: 4.0, speedDeltaBetweenLayers: 0.5)

        let animationFilesCount = KTF_FILES_COUNT().countGroupOfFiles(prefix: BACKGROUNDS_FILES_PREFIX,
                                                                      sufix: "png",
                                                                      firstNumber: 0);
        
        for i in 0...(animationFilesCount - 1)
        {
            let fileName = BACKGROUNDS_FILES_PREFIX + String(i)+".png"

            let spriteMiddle = KTF_Sprite(imageNamed:fileName)
            let spriteUp = KTF_Sprite(imageNamed:fileName)

            spriteMiddle.zPosition = CGFloat((i + 1)*100)
            spriteUp.zPosition = CGFloat((i + 1)*100)

            _spritesArray_middle.append(spriteMiddle)
            _spritesArray_from_up.append(spriteUp)

            
            spriteMiddle.position = KTF_POS().posInNodePrc(node: self, isParentFullScreen: false,
                                                       PrcX: CGFloat(ANIMATED_BG_POS[0][0]),
                                                       PrcY: CGFloat(ANIMATED_BG_POS[0][1]))
            spriteUp.position = KTF_POS().posInNodePrc(node: self, isParentFullScreen: false,
                                                   PrcX: CGFloat(ANIMATED_BG_POS[1][0]),
                                                   PrcY: CGFloat(ANIMATED_BG_POS[1][1]))
            self.addChild(spriteMiddle)
            self.addChild(spriteUp)
            
            _screenHeight = spriteUp.frame.size.height;
        }

    }
    func startScrolling()
    {
        _timer = Timer.scheduledTimer(timeInterval: 1.0/60.0, target: self, selector: #selector(AnimatedBg.tick), userInfo: nil, repeats: true)

    }
    @objc func tick()
    {
    // print("tick")
        self.scrollBackground()
    }
    func scrollBackground()
    {
        var delta = CGFloat(1.0);
        for i in 0...(_spritesArray_middle.count - 1)
        {
            let movingSprite_1 = _spritesArray_middle[i]
            let movingSprite_2 = _spritesArray_from_up[i]
            var newPos_1 = movingSprite_1.position
            var newPos_2 = newPos_1
            
            newPos_1.y -= _speed * delta
            delta += _speedDelta

            if (newPos_1.y <= 0 - (_screenHeight / 4 / self.yScale))/// self.yScale * 2))
            {
                newPos_1.y = newPos_1.y + _screenHeight;
            }
            newPos_2.y = newPos_1.y + _screenHeight;
            movingSprite_1.position = newPos_1;
            movingSprite_2.position = newPos_2;
        }
    }
    func stopScrolling()
    {
        if _timer != nil
        {
        _timer.invalidate()
        _timer = nil
        }
        
    }
    func setScrollSpeed(speed:CGFloat, speedDeltaBetweenLayers delta:CGFloat)
    {
        if (KTF_DeviceType().isiPhone()) {
            _speed = speed * 0.3;
            _speedDelta = delta * 0.3;
        }else{
            _speed = speed;
            _speedDelta = delta;
        }
    }
    func setScrollSpeedByPRC(speedPRC:CGFloat)
    {
        let newSpeed = _maxSpeed  *  (speedPRC / 100);
        _speed = newSpeed;
    }
    func frontLayerSpeed() ->CGFloat
    {
        return _speed * ( CGFloat(_spritesArray_middle.count-1) * _speedDelta + 1.0)
    }
    func backLayerSpeed() ->CGFloat
    {
        return _speed
    }
    
    override func removeFromParent() {
        super.removeFromParent()
    }
    
}
