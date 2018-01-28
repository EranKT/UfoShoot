//
//  EnemySprite.swift
//  TestSwiftGame
//
//  Created by EKT DIGIDESIGN on 12/29/17.
//  Copyright © 2017 EKT DIGIDESIGN. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

let ENEMY_FILES_PREFIX = "enemy_"

enum ENEMY_AMOUNTS:Int {
    case easy_6 = 6
    case medium_2_lines_10 = 10
    case medium_2_lines_14 = 14
    case big_3_lines_18 = 18
    case big_4_lines_24 = 24
}

enum ENEMY_TYPE:Int {
    case green_alien = 0
    case blue_alien
}


let ENEMY_POSITIONS_EASY_6 = [
    // (from top left)
    [20, 76], [32, 76], [44, 76], [56, 76], [68, 76], [80, 76], // 6

]

let ENEMY_POSITIONS_medium_2_lines_10 = [
    // (from top left)
    [20, 78], [32, 78], [44, 78], [56, 78], [68, 78], [80, 78], // 6
              [32, 70], [44, 70], [56, 70], [68, 70]////////////// 4
 
]

let ENEMY_POSITIONS_MEDIUM_2_LINES_14 = [
    // (from top left)
     [8, 78],[20, 78], [32, 78], [44, 78], [56, 78], [68, 78], [80, 78], [92, 78], // 8
             [20, 70], [32, 70], [44, 70], [56, 70], [68, 70], [80, 70] // 6
]

let ENEMY_POSITIONS_BIG_3_LINES_18 = [
    // (from top left)
    [8, 78],[20, 78], [32, 78], [44, 78], [56, 78], [68, 78], [80, 78], [92, 78], // 8
            [20, 70], [32, 70], [44, 70], [56, 70], [68, 70], [80, 70], // 6
                      [32, 62], [44, 62], [56, 62], [68, 62]////////////// 4
]

let ENEMY_POSITIONS_BIG_4_LINES_24 = [
    // (from top left)
    [8, 78],[20, 78], [32, 78], [44, 78], [56, 78], [68, 78], [80, 78], [92, 78], // 8
            [20, 70], [32, 70], [44, 70], [56, 70], [68, 70], [80, 70],           // 6
            [20, 62], [32, 62], [44, 62], [56, 62], [68, 62], [80, 62],           // 6
                      [32, 54], [44, 54], [56, 54], [68, 54]          ////////////// 4
]

class EnemySprite: KTF_Sprite {
    
    
    var _timer: Timer!
    open var isActive_: Bool!
    open var canShoot_: Bool!
    open var life_: Int!
    var countDownToNextEnemyShoot_: Int!

    var _speed: CGFloat!
    var _speedDelta: CGFloat!
    var _maxSpeed: CGFloat!
    var _enemyFilesCount: Int!
    var _amountOfEnemies: Int!
    
    
    // GENERATE FILE NAME FOR ENEMY
    func getFileName(kindIndex:Int) -> String {
        _enemyFilesCount = KTF_FILES_COUNT().countGroupOfFiles(prefix: ENEMY_FILES_PREFIX,
                                                                  sufix: "png",
                                                                  firstNumber: 0);
        
      //  let enemyIndex = Int(arc4random()%UInt32(_enemyFilesCount))
        
        let fileName = ENEMY_FILES_PREFIX + String(kindIndex)+".png"
        return fileName
    }
    //ANIMATE ENEMY TO PLACE ON SCREEN
    func animateEnemyToPlace(itemTag:Int, amountIndex:Int, withLife:Int, canShoot:Bool) {
        self.isActive_ = false
        _amountOfEnemies = amountIndex
        canShoot_ = canShoot
        life_ = withLife
        
        let endPos = self.getEnemyPositionPerAmount(tag: itemTag)
        
        self.run(SKAction.sequence([
            SKAction.wait(forDuration: TimeInterval(0.3*CGFloat(itemTag))),
            SKAction.move(to: endPos, duration: 0.6),
           SKAction.run(self.activateEnemy),
           SKAction.run(self.itemFloatAnimation)
            ]
        ))
    }
 
    func activateEnemy() {
    self.isActive_ = true
        if self.canShoot_ {
            let shootTimeFactor = UInt32(60*(7-gameSelectedLevel_))
            countDownToNextEnemyShoot_ = Int(arc4random()%shootTimeFactor)
        }
    }
    
    func getEnemyPositionPerAmount(tag:Int) -> CGPoint{
        var itemPos: CGPoint
        
        switch (_amountOfEnemies) {
        case ENEMY_AMOUNTS.easy_6.rawValue:
            itemPos = KTF_POS().posInPrc(PrcX: CGFloat(ENEMY_POSITIONS_EASY_6[tag][0]),
                                         PrcY: CGFloat(ENEMY_POSITIONS_EASY_6[tag][1]))
            break
        case ENEMY_AMOUNTS.medium_2_lines_10.rawValue:
            itemPos = KTF_POS().posInPrc(PrcX: CGFloat(ENEMY_POSITIONS_medium_2_lines_10[tag][0]),
                                         PrcY: CGFloat(ENEMY_POSITIONS_medium_2_lines_10[tag][1]))
            break
        case ENEMY_AMOUNTS.medium_2_lines_14.rawValue:
            itemPos = KTF_POS().posInPrc(PrcX: CGFloat(ENEMY_POSITIONS_MEDIUM_2_LINES_14[tag][0]),
                                         PrcY: CGFloat(ENEMY_POSITIONS_MEDIUM_2_LINES_14[tag][1]))
            break
        case ENEMY_AMOUNTS.big_3_lines_18.rawValue:
            itemPos = KTF_POS().posInPrc(PrcX: CGFloat(ENEMY_POSITIONS_BIG_3_LINES_18[tag][0]),
                                         PrcY: CGFloat(ENEMY_POSITIONS_BIG_3_LINES_18[tag][1]))
            break
        case ENEMY_AMOUNTS.big_4_lines_24.rawValue:
            itemPos = KTF_POS().posInPrc(PrcX: CGFloat(ENEMY_POSITIONS_BIG_4_LINES_24[tag][0]),
                                         PrcY: CGFloat(ENEMY_POSITIONS_BIG_4_LINES_24[tag][1]))
            break
        default:
            itemPos = KTF_POS().posInPrc(PrcX: CGFloat(ENEMY_POSITIONS_EASY_6[tag][0]),
                                         PrcY: CGFloat(ENEMY_POSITIONS_EASY_6[tag][1]))
            break
        }

        return itemPos
    }
    
    
    func itemFloatAnimation() {
        
        let rotationSpeed = CGFloat(20) / CGFloat(arc4random()%10+20)
        let angle = KTF_CONVERT().degreesToRadians(degrees: CGFloat(((arc4random()%2)+10)/2))
        
        let action1 = SKAction.rotate(toAngle: -angle, duration: TimeInterval(rotationSpeed))
        let action2 = SKAction.rotate(toAngle: angle, duration: TimeInterval(rotationSpeed))
        let action3 = SKAction.sequence([action1, action2])
        let action4 = SKAction.repeatForever(action3)
        self.run(action4)
        
    }

    
    
    
    
    
    //INIT ENEMY POS AND SCROLL
    func initEnemy(forTag:Int)
    {
        _maxSpeed = 7.0;
        
        _timer = Timer.scheduledTimer(timeInterval: 1.0/60.0,
                                      target: self,
                                      selector: #selector(EnemySprite.enemyAnimation),
                                      userInfo: nil,
                                      repeats: true)
    }
    
    @objc func enemyAnimation()
    {
  
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

    override func removeFromParent() {
        isActive_ = false
       super.removeFromParent()
    }
}

