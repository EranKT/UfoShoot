//
//  EnemySpaceShip.swift
//  TestSwiftGame
//
//  Created by EKT DIGIDESIGN on 1/8/18.
//  Copyright © 2018 EKT DIGIDESIGN. All rights reserved.
//

import Foundation
import SpriteKit

enum ENEMY_SHIP_OBJ_INDEX: Int
{
    case ENEMY_SHIP_LIGHTS
    case ENEMY_SHIP_LIFE_BAR
}
// OBJECTS POS
let ENEMY_SHIP_CLASS_POS_LIST = [
    [50, 50],    //lights
    [50, 80],    //life bar
]
// OBJECTS Z ORDER
/*
enum enemyShip_z_pos: CGFloat
{
    case enemyShip_lightsZorder = 1
    case enemyShip_lifeBarBgZorder
    case enemyShip_lifeBarZorder
}
*/
// OBJECTS TAG NAME
enum enemyShip_tags: String
{
    case EnemyShipObjectsTagDriver_smile
    case EnemyShipObjectsTagDriver_shout
    case EnemyShipObjectsTagBaseBack
    case EnemyShipObjectsTagBase
    case EnemyShipObjectsTagHood
    case EnemyShipObjectsTagLights
}

class EnemySpaceShip: KTF_Sprite {
    
    
    
    // DECLARE CLASS OBJECTS
    var _lightsSprite :KTF_Sprite!
    var _lifeBarBgSprite :KTF_Sprite!
    var _lifeBarSprite :KTF_Sprite!
    var _lifeBarScaleXUnit: CGFloat!
    var life_ = 100 * gameSelectedLevel_
    
    var _enemyShipIndex:Int!

    static var _enemySpaceShipBase: EnemySpaceShip!
    
    func initEnemyShip(enemyShipIndex:Int) -> EnemySpaceShip
    {
        _enemyShipIndex = enemyShipIndex
        let enemyShipFileName = "ufo_top_base_" + String(_enemyShipIndex)
        EnemySpaceShip._enemySpaceShipBase = EnemySpaceShip(imageNamed: enemyShipFileName)
        
        EnemySpaceShip._enemySpaceShipBase.addLights(enemyShipIndex:_enemyShipIndex)
        EnemySpaceShip._enemySpaceShipBase.addLifeBarToShip()
        EnemySpaceShip._enemySpaceShipBase.animateEnemyToPlace()
        
        EnemySpaceShip._enemySpaceShipBase.tag = _enemyShipIndex
        EnemySpaceShip._enemySpaceShipBase.zRotation = KTF_CONVERT().degreesToRadians(degrees: 180)
        return EnemySpaceShip._enemySpaceShipBase
    }
    
    
    func addLights(enemyShipIndex:Int) {
        
        var lightsTagName = enemyShip_tags.EnemyShipObjectsTagLights.rawValue
        let lightsFileName = "ufo_top_lights_" + String(enemyShipIndex)
        
        _lightsSprite = KTF_Sprite(imageNamed: lightsFileName)
        _lightsSprite.position = KTF_POS().posInNodePrc(node:self, isParentFullScreen: false,
                                                        PrcX: CGFloat(ENEMY_SHIP_CLASS_POS_LIST[ENEMY_SHIP_OBJ_INDEX.ENEMY_SHIP_LIGHTS.rawValue][0]),
                                                        PrcY: CGFloat(ENEMY_SHIP_CLASS_POS_LIST[ENEMY_SHIP_OBJ_INDEX.ENEMY_SHIP_LIGHTS.rawValue][1]))
        _lightsSprite.zPosition = gameZorder.enemy_ship_lights.rawValue//gameZorder.enemy_ship_lights.rawValue//enemyShip_z_pos.enemyShip_lightsZorder.rawValue
        
        lightsTagName.append(String(enemyShipIndex))
        _lightsSprite.name = lightsTagName
        
        self.addChild(_lightsSprite)
        
        self.blinkAllLights()
    }
    
    func addLifeBarToShip()
    {
        _lifeBarBgSprite = KTF_Sprite(imageNamed: "life_bar_bg")
        _lifeBarBgSprite.anchorPoint = CGPoint(x: 1.0, y:0.5)
        _lifeBarBgSprite.position = CGPoint(x:self.position.x + self.size.width/2, y:self.position.y - self.size.height*0.35)

      /*  _lifeBarBgSprite.position = KTF_POS().posInNodePrc(node:self, isParentFullScreen: false,
                                                        PrcX: CGFloat(ENEMY_SHIP_CLASS_POS_LIST[ENEMY_SHIP_OBJ_INDEX.ENEMY_SHIP_LIFE_BAR.rawValue][0]),
                                                        PrcY: CGFloat(ENEMY_SHIP_CLASS_POS_LIST[ENEMY_SHIP_OBJ_INDEX.ENEMY_SHIP_LIFE_BAR.rawValue][1]))
    */
        _lifeBarBgSprite.zPosition = gameZorder.enemy_ship_lifeBarBg.rawValue//enemyShip_z_pos.enemyShip_lifeBarBgZorder.rawValue
    //    KTF_SCALE().ScaleMyNode(nodeToScale: _lifeBarBgSprite)
        self.addChild(_lifeBarBgSprite)
        
        _lifeBarSprite = KTF_Sprite(imageNamed: "life_bar")
        _lifeBarSprite.anchorPoint = CGPoint(x: 1.0, y:0.5)
        _lifeBarSprite.position = CGPoint(x:self.position.x + self.size.width/2, y:self.position.y - self.size.height*0.35)
      /*  _lifeBarSprite.position = KTF_POS().posInNodePrc(node:self, isParentFullScreen: false,
                                                           PrcX: CGFloat(ENEMY_SHIP_CLASS_POS_LIST[ENEMY_SHIP_OBJ_INDEX.ENEMY_SHIP_LIFE_BAR.rawValue][0]),
                                                           PrcY: CGFloat(ENEMY_SHIP_CLASS_POS_LIST[ENEMY_SHIP_OBJ_INDEX.ENEMY_SHIP_LIFE_BAR.rawValue][1]))
      */
        _lifeBarSprite.zPosition = gameZorder.enemy_ship_lifeBar.rawValue//enemyShip_z_pos.enemyShip_lifeBarZorder.rawValue
        //    KTF_SCALE().ScaleMyNode(nodeToScale: _lifeBarBgSprite)
      _lifeBarScaleXUnit = _lifeBarSprite.xScale/CGFloat(life_)
        self.addChild(_lifeBarSprite)
        
    }
    
    ////// LIGHTS ANIMATION
    func blinkAllLights() {
        
        _lightsSprite.run(SKAction.repeatForever(SKAction.sequence([
            SKAction.fadeIn(withDuration: TimeInterval(0.3)),
            SKAction.wait(forDuration: TimeInterval(0.3)),
            SKAction.fadeOut(withDuration: TimeInterval(0.3)),
            SKAction.wait(forDuration: TimeInterval(0.3))
            ])))
    }
    
    
    func animateEnemyToPlace() {
        self.isEnabled = false
        
        let endPos = KTF_POS().posInPrc(PrcX: 50, PrcY: 75)
        
        self.run(SKAction.sequence([
            SKAction.wait(forDuration: 1.0),
            SKAction.move(to: endPos, duration: 1.5),
            SKAction.run(self.activateEnemyShip),
            SKAction.run(self.shipMoveAnimation)
            ]
        ))
    }

    func activateEnemyShip() {
        self.isEnabled = true
          //  let shootTimeFactor = UInt32(60*(7-gameSelectedLevel_))
        //    countDownToNextEnemyShoot_ = Int(arc4random()%shootTimeFactor)
    }
    
    func shipMoveAnimation() {
        // START MOVE ANIMATION LEFT AND RIGHT OF SCREEN
        let actionWaitOneSide = SKAction.wait(forDuration: 1.0)
        let moveLeft = SKAction.moveTo(x: self.size.width/2, duration: 5.0)
        let actionWaitSecondSide = SKAction.wait(forDuration: 1.0)
        let moveRight = SKAction.moveTo(x: (self.parent?.frame.size.width)! - self.size.width/2, duration: 5.0)
        let sequenceAction = SKAction.repeatForever(SKAction.sequence([actionWaitOneSide,
                                                                       moveLeft,
                                                                       actionWaitSecondSide,
                                                                       moveRight]))
        self.run(sequenceAction)
    }

    func enemyShipWasHit()
    {
        if _lifeBarSprite.xScale > 0
        {
            _lifeBarSprite.xScale -= _lifeBarScaleXUnit
            life_ -= 1
        }
        else
        {
      print("ENEMY SHIP IS DEAD")
        }
    }
    override func removeFromParent() {
        self.isEnabled = false
        super.removeFromParent()
    }

    
    func getBulletPosPerType(index:Int) -> CGPoint
    {
        var exitPoint: CGPoint
        switch self.tag {
        case 0:
            switch index {
            case 0:
                //middle one shoot
                exitPoint = CGPoint(x: self.position.x, y: self.position.y - self.size.height/2)
                break
            case 1:
                //left 2 shoot
                exitPoint = CGPoint(x: self.position.x, y: self.position.y - self.size.height/2)
                break
            case 2:
                //right 2 shoot
                exitPoint = CGPoint(x: self.position.x, y: self.position.y - self.size.height/2)
                break
            case 3:
                //left 4 shoot
                exitPoint = CGPoint(x: self.position.x, y: self.position.y - self.size.height/2)
                break
            case 4:
                //right 4 shoot
                exitPoint = CGPoint(x: self.position.x, y: self.position.y - self.size.height/2)
                break
            default:
                //middle one shoot
                exitPoint = CGPoint(x: self.position.x, y: self.position.y - self.size.height/2)
            }
            break
        default:
            switch index {
            case 0:
                //middle one shoot
                exitPoint = CGPoint(x: self.position.x, y: self.position.y - self.size.height/2)
                break
            case 1:
                //left 2 shoot
                exitPoint = CGPoint(x: self.position.x, y: self.position.y - self.size.height/2)
                break
            case 2:
                //right 2 shoot
                exitPoint = CGPoint(x: self.position.x, y: self.position.y - self.size.height/2)
                break
            case 3:
                //left 4 shoot
                exitPoint = CGPoint(x: self.position.x, y: self.position.y - self.size.height/2)
                break
            case 4:
                //right 4 shoot
                exitPoint = CGPoint(x: self.position.x, y: self.position.y - self.size.height/2)
                break
            default:
                //middle one shoot
                exitPoint = CGPoint(x: self.position.x, y: self.position.y - self.size.height/2)
            }
        }
        
        return exitPoint
    }
    
    func getBulletEndPosPerType(index:Int) -> CGPoint
    {
        var endPoint: CGPoint
        
        switch self.tag {
        case 0:
            switch index {
            case 0:
                //middle one shoot
                endPoint = CGPoint(x: self.position.x, y:0)// KTF_WIN_SIZE().getWinSize().height)
                break
            case 1:
                //left 2 shoot
                endPoint = CGPoint(x: self.position.x - self.size.width/4, y: 0)// KTF_WIN_SIZE().getWinSize().height)
                break
            case 2:
                //right 2 shoot
                endPoint = CGPoint(x: self.position.x + self.size.width/4, y: 0)// KTF_WIN_SIZE().getWinSize().height)
                break
            case 3:
                //left 4 shoot
                endPoint = CGPoint(x: self.position.x - self.size.width, y: 0)// KTF_WIN_SIZE().getWinSize().height)
                break
            case 4:
                //right 4 shoot
                endPoint = CGPoint(x: self.position.x + self.size.width, y: 0)// KTF_WIN_SIZE().getWinSize().height)
                break
            default:
                //middle one shoot
                endPoint = CGPoint(x: self.position.x, y: 0)// KTF_WIN_SIZE().getWinSize().height)
            }
            break
        default:
            switch index {
            case 0:
                //middle one shoot
                endPoint = CGPoint(x: self.position.x, y: 0)// KTF_WIN_SIZE().getWinSize().height)
                break
            case 1:
                //left 2 shoot
                endPoint = CGPoint(x: self.position.x - self.size.width/4, y: 0)// KTF_WIN_SIZE().getWinSize().height)
                break
            case 2:
                //right 2 shoot
                endPoint = CGPoint(x: self.position.x + self.size.width/4, y: 0)// KTF_WIN_SIZE().getWinSize().height)
                break
            case 3:
                //left 4 shoot
                endPoint = CGPoint(x: self.position.x - self.size.width/2, y: 0)// KTF_WIN_SIZE().getWinSize().height)
                break
            case 4:
                //right 4 shoot
                endPoint = CGPoint(x: self.position.x + self.size.width/2, y: 0)// KTF_WIN_SIZE().getWinSize().height)
                break
            default:
                //middle one shoot
                endPoint = CGPoint(x: self.position.x, y: 0)// KTF_WIN_SIZE().getWinSize().height)
            }
        }
        
        
        return endPoint
    }

}

