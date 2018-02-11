//
//  BonusBubbleSprite.swift
//  UfoShoot
//
//  Created by EKT DIGIDESIGN on 2/7/18.
//  Copyright © 2018 EKT DIGIDESIGN. All rights reserved.
//


import Foundation
import SpriteKit
import GameplayKit

enum bonus_types: Int
{
    case X2 = 0
    case X4
    case blow
    case rocket
    case shield
}

let BUBBLE_FILES_PREFIX = "bonus_bubble"
let BONUS_TIME = 100

class BonusBubbleSprite: KTF_Sprite {
    
    
    var _timer: Timer!
    
    var _speed: CGFloat!
    var _speedDelta: CGFloat!
    let _maxSpeed = CGFloat(7.0)
    var _bonusType = -1
    var _bonusFilesCount: Int!
    
    // GENERATE FILE NAME FOR OBSTACLE
    func getFileName() -> String {
        let bonusFilesPrefix = BUBBLE_FILES_PREFIX + "_"
        _bonusFilesCount = KTF_FILES_COUNT().countGroupOfFiles(prefix: bonusFilesPrefix,
                                                                  sufix: "png",
                                                                  firstNumber: 0);
        
        let bonusIndex = Int(arc4random()%UInt32(_bonusFilesCount))
        
        let fileName = bonusFilesPrefix + String(bonusIndex)//+".png"
        return fileName
    }
    //INIT OBSTACLE POS AND SCROLL
    func initBonusBubble()
    {
        let bubbleSprite = KTF_Sprite(imageNamed: BUBBLE_FILES_PREFIX)
        bubbleSprite.position = self.position
        bubbleSprite.name = BUBBLE_FILES_PREFIX
        self.addChild(bubbleSprite)
        
        self.setScrollSpeed(speed: 5.0, speedDeltaBetweenLayers: 0.5)
        
        let startXpoint = CGFloat(arc4random()%80) + 10
        self.position = KTF_POS().posInPrc(PrcX: startXpoint, PrcY: 110)
        self.tag = 1
        
        let indexStr = self.name!.index(self.name!.startIndex, offsetBy: BUBBLE_FILES_PREFIX.count + 1)

        self._bonusType = Int(String(self.name![indexStr]))!
       
        _timer = Timer.scheduledTimer(timeInterval: 1.0/60.0,
                                      target: self,
                                      selector: #selector(BonusBubbleSprite.bubbleAnimation),
                                      userInfo: nil,
                                      repeats: true)
    }
    
    @objc func bubbleAnimation()
    {
        var delta = CGFloat(1.0);
        var newPos_1 = self.position
        
        newPos_1.y -= _speed * delta
        delta += _speedDelta
        
        self.position = newPos_1;
        
        if (newPos_1.y <= 0)
        {
            self.stopScrolling()
            self.tag = -1
            self.removeAllActions()
            self.removeAllChildren()
            self.removeFromParent()
            //  }
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
    
}

