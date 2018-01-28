//
//  MainScene.swift
//  TestSwiftGame
//
//  Created by EKT DIGIDESIGN on 12/6/17.
//  Copyright © 2017 EKT DIGIDESIGN. All rights reserved.
//

import SpriteKit
import GameplayKit

/////////////////////////////<<<<<<<<< DEFINITIONS /////////////////////////////////
// OBJECTS INDEX FOR POS
enum UFO_OBJ_INDEX: Int
{
    case UFO_BACK = 0
    case UFO_DRIVER
    case UFO_BASE
    case UFO_HOOD
    case UFO_LIGHTS
    case UFO_GUN
    case UFO_JET
}
// OBJECTS POS
let UFO_CLASS_POS_LIST = [
    [50, 50],    //Back
    [0, 50],   //Driver
    [0, 0],   //Base
    [32.5, 06],    //Hood
    [50, 50],    //lights
    [50, 110],    //gun
    [0, -50],    //JET
]
// OBJECTS Z ORDER
enum ufo_z_pos: CGFloat
{
    case ufo_jetZorder = -3
    case ufo_baseBackZorder = -2
    case ufo_driverZorder
    case ufo_gunZorder
    case ufo_baseZorder
    case ufo_hoodZorder
    case ufo_lightsZorder
}
// OBJECTS TAG NAME
enum ufo_tags: String
{
    case UFOObjectsTagDriver_smile
    case UFOObjectsTagDriver_shout
    case UFOObjectsTagBaseBack
    case UFOObjectsTagBase
   case UFOObjectsTagHood
   case UFOObjectsTagLights
}
//ACTION KEYS
enum ufo_actions_keys: String
{
    case action_hood_open
    case action_hood_close
}
// LIGHT BLINK STYLE
enum ufo_lightBlinkStyle: Int
{
    case UFOLightsBlinkStyleFromCenterAndOut = 0
    case UFOLightsBlinkStyleColorByColor
    case UFOLightsBlinkStyleRandom
    case UFOLightsBlinkStyleAllLightsTogether
    case UFOLightsBlinkStyleAllLightsOn
    case UFOLightsBlinkStyleAllLightsOff
}
// LIGHT STATUS
enum ufo_lightsStatus: Int
{
    case UFOLightsStatusOff = 3
    case UFOLightsStatusOn
    case UFOLightsStatusBlink
}
enum ufo_colorIndex: Int
{
    case YELLOW_LIGHT = 0
    case RED_LIGHT
    case GREEN_LIGHT
    case BLUE_LIGHT
}

let ufo_lightsByColor = [
    [0, 5],    //YELLOW
    [1, 4],   //PURPLE AND RED
    [2, 7],   //GREEN
    [3, 6],    //BLUE
]

/////////////////////////////>>>>>>>>>>> DEFINITIONS /////////////////////////////////

class UFOSprite: KTF_Sprite {
     
    
    // DECLARE CLASS OBJECTS
    var _lightsFramesArray :[KTF_Sprite] = [KTF_Sprite]()
     var _currentLightsIndex = Int()
    static let _ufoBase = UFOSprite(imageNamed: "ufo_base")
    
    func initUFO() -> UFOSprite
    {
     //   KTF_SCALE().ScaleMyNode(nodeToScale: UFOSprite._ufoBase)
    //    KTF_SCALE().ScaleMyNodeRelatively(nodeToScale: self)
   //     UFOSprite._ufoBase.setScale(1.0)
   //     print("UFO SCALE", self.xScale, self.yScale)

        return UFOSprite._ufoBase
    }

    func addPartsToUfo() {
        // add back
        UFOSprite._ufoBase.setBackSprite()
        // add hood
        UFOSprite._ufoBase.setHoodSprite()
        // add lights
        UFOSprite._ufoBase.setLightsSpriteArray()
        // add float animation
        UFOSprite._ufoBase.ufoFloatAnimation()
        
    }
    
    func setBackSprite() {
        let baseBack = KTF_Sprite(imageNamed: "ufo_base_back")
        baseBack.position  = KTF_POS().posInNodePrc(node:self, isParentFullScreen: false,
                                                PrcX: CGFloat(UFO_CLASS_POS_LIST[UFO_OBJ_INDEX.UFO_BACK.rawValue][0]),
                                                PrcY: CGFloat(UFO_CLASS_POS_LIST[UFO_OBJ_INDEX.UFO_BACK.rawValue][1]))
   baseBack.zPosition = ufo_z_pos.ufo_baseBackZorder.rawValue
        baseBack.name = ufo_tags.UFOObjectsTagBaseBack.rawValue

        self.addChild(baseBack)
        
    }
    func setHoodSprite() {
        let hood = KTF_Sprite(imageNamed: "ufo_hood")
        hood.anchorPoint = CGPoint.init(x: 0.82, y: 0.55)
        hood.position  = KTF_POS().posInNodePrc(node:self, isParentFullScreen: true,
                                                PrcX:CGFloat(UFO_CLASS_POS_LIST[UFO_OBJ_INDEX.UFO_HOOD.rawValue][0]),
                                                PrcY:CGFloat(UFO_CLASS_POS_LIST[UFO_OBJ_INDEX.UFO_HOOD.rawValue][1]))
        hood.zPosition = ufo_z_pos.ufo_hoodZorder.rawValue
        hood.name = ufo_tags.UFOObjectsTagHood.rawValue
        
        self.addChild(hood)
    }
    /*
    func setHoodSprite() {
        let hood = KTF_Sprite(imageNamed: "ufo_hood")
        hood.anchorPoint = CGPoint.init(x: 0.82, y: 0.55)
        hood.position  = KTF_POS().posInPrc(PrcX: CGFloat(UFO_CLASS_POS_LIST[UFO_OBJ_INDEX.UFO_HOOD.rawValue][0])*self.xScale*5.7,
                                            PrcY: CGFloat(UFO_CLASS_POS_LIST[UFO_OBJ_INDEX.UFO_HOOD.rawValue][1])*self.yScale/2)
        hood.zPosition = ufo_z_pos.ufo_hoodZorder.rawValue
        hood.name = ufo_tags.UFOObjectsTagHood.rawValue
        
        self.addChild(hood)
    }
  */  func setDriverSprite(driverIndex: Int, scale: CGFloat) {

        var driverFileName = "alien_"
        driverFileName.append(String(driverIndex))
// DRIVER SMILE
        driverFileName.append("_0.png")
        let driver = KTF_Sprite(imageNamed: driverFileName)
        
        driver.position = KTF_POS().posInNodePrc(node:self, isParentFullScreen: false,
                                             PrcX: CGFloat(UFO_CLASS_POS_LIST[UFO_OBJ_INDEX.UFO_DRIVER.rawValue][0]),
                                             PrcY: CGFloat(UFO_CLASS_POS_LIST[UFO_OBJ_INDEX.UFO_DRIVER.rawValue][1]))
        
        driver.xScale = driver.xScale * scale;
        driver.yScale = driver.yScale * scale;
        driver.zPosition = ufo_z_pos.ufo_driverZorder.rawValue
        driver.name = ufo_tags.UFOObjectsTagDriver_smile.rawValue

        UFOSprite._ufoBase.addChild(driver)
// DRIVER SHOUT
        driverFileName = "alien_"
        driverFileName.append(String(driverIndex))
        driverFileName.append("_1.png")
        
        let driverShout = KTF_Sprite(imageNamed: driverFileName)
        
        driverShout.position = KTF_POS().posInNodePrc(node:self, isParentFullScreen: false,
                                             PrcX: CGFloat(UFO_CLASS_POS_LIST[UFO_OBJ_INDEX.UFO_DRIVER.rawValue][0]),
                                             PrcY: CGFloat(UFO_CLASS_POS_LIST[UFO_OBJ_INDEX.UFO_DRIVER.rawValue][1]))
        
        driverShout.xScale = driverShout.xScale * scale;
        driverShout.yScale = driverShout.yScale * scale;
        driverShout.zPosition = ufo_z_pos.ufo_driverZorder.rawValue
        driverShout.name = ufo_tags.UFOObjectsTagDriver_shout.rawValue

        UFOSprite._ufoBase.addChild(driverShout)
        
        self.driverSmile()
    }
 
    func setLightsSpriteArray() {
     
      let numberOfLightsFiles = KTF_FILES_COUNT().countGroupOfFiles(prefix: "ufo_lights_", sufix: ".png", firstNumber: 0)
        var lightSprite = KTF_Sprite()
                
        for i in 0...(numberOfLightsFiles - 1)
        {
            var lightsTagName = ufo_tags.UFOObjectsTagLights.rawValue
            var lightsFileName = "ufo_lights_"
            
            lightsFileName.append(String(i))
            lightsFileName.append(".png")
          
            lightSprite = KTF_Sprite(imageNamed: lightsFileName)
            lightSprite.position = KTF_POS().posInNodePrc(node:self, isParentFullScreen: false,
                                                      PrcX: CGFloat(UFO_CLASS_POS_LIST[UFO_OBJ_INDEX.UFO_LIGHTS.rawValue][0]),
                                                      PrcY: CGFloat(UFO_CLASS_POS_LIST[UFO_OBJ_INDEX.UFO_LIGHTS.rawValue][1]))
            lightSprite.zPosition = ufo_z_pos.ufo_lightsZorder.rawValue
            
            lightsTagName.append(String(i))
            lightSprite.name = lightsTagName

            self.addChild(lightSprite)
            
            _lightsFramesArray.append(lightSprite)
        }
    }
    func ufoFloatAnimation() {
        
        let rotationSpeed = CGFloat(20) / CGFloat(arc4random()%10+20)
        let angle = KTF_CONVERT().degreesToRadians(degrees: CGFloat(((arc4random()%2)+15)/5))
        
        let action1 = SKAction.rotate(toAngle: -angle, duration: TimeInterval(rotationSpeed))
        let action2 = SKAction.rotate(toAngle: angle, duration: TimeInterval(rotationSpeed))
        let action3 = SKAction.sequence([action1, action2])
        let action4 = SKAction.repeatForever(action3)
        self.run(action4)
   
    }

    // add open, close & close with speed methods
    ////// HOOD ANIMATION
///OPEN
    func openHoodToAngle(hoodAngle: CGFloat, andSpeed: CGFloat)
    {
        self.removeAction(forKey: ufo_actions_keys.action_hood_close.rawValue)
      let hoodSprite = self.childNode(withName: ufo_tags.UFOObjectsTagHood.rawValue)
        let hoodAngleRad = KTF_CONVERT().degreesToRadians(degrees: -hoodAngle)
        
        let action1 = SKAction.rotate(toAngle: hoodAngleRad, duration: TimeInterval(andSpeed))
        hoodSprite?.run(action1, withKey: ufo_actions_keys.action_hood_open.rawValue)
    }
    ///CLOSE
    func closeHood()
    {
        self.closeHoodWithSpeed(closeSpeed: 0.3)
    }
    ///CLOSE WITH SPEED
    func closeHoodWithSpeed(closeSpeed: CGFloat)
    {
        self.removeAction(forKey: ufo_actions_keys.action_hood_open.rawValue)
     let hoodSprite = self.childNode(withName: ufo_tags.UFOObjectsTagHood.rawValue)
        
        let action1 = SKAction.rotate(toAngle: 0, duration: TimeInterval(closeSpeed))
        hoodSprite?.run(action1, withKey: ufo_actions_keys.action_hood_close.rawValue)
    }

    // DRIVER SMILE
    func driverSmile() {
        let driverSmileSprite = self.childNode(withName: ufo_tags.UFOObjectsTagDriver_smile.rawValue)
        let driverShoutSprite = self.childNode(withName: ufo_tags.UFOObjectsTagDriver_shout.rawValue)
        driverSmileSprite?.alpha = 1.0
        driverShoutSprite?.alpha = 0
    }
    // DRIVER SHOUT
    func driverShout() {
        let driverSmileSprite = self.childNode(withName: ufo_tags.UFOObjectsTagDriver_smile.rawValue)
        let driverShoutSprite = self.childNode(withName: ufo_tags.UFOObjectsTagDriver_shout.rawValue)
        driverSmileSprite?.alpha = 0
        driverShoutSprite?.alpha = 1.0
        KTF_Sound_Engine().playSound(fileName: "alien_scared")
    }
    
    ////// LIGHTS ANIMATIONS
    func blinkLightsWithStyle(style: ufo_lightBlinkStyle)
    {
        switch style {
        case ufo_lightBlinkStyle.UFOLightsBlinkStyleFromCenterAndOut:
            self.blinkLightByOrder()
            break
        case ufo_lightBlinkStyle.UFOLightsBlinkStyleColorByColor:
            self.blinkLightsByColors()
            break
        case ufo_lightBlinkStyle.UFOLightsBlinkStyleRandom:
            self.blinkLightsRandom()
            break
        case ufo_lightBlinkStyle.UFOLightsBlinkStyleAllLightsTogether:
            self.blinkAllLights()
            break
        case ufo_lightBlinkStyle.UFOLightsBlinkStyleAllLightsOn:
            self.allLightsOn()
            break
        case ufo_lightBlinkStyle.UFOLightsBlinkStyleAllLightsOff:
            self.allLightsOff()
            break
     //   default:
     //       break

        }
    }
    
    func blinkLightByOrder() {
        
        if _currentLightsIndex < _lightsFramesArray.count-1 {
            _currentLightsIndex += 1
        }
        else
        {
            _currentLightsIndex = 0
        }
        
        let currentLight = _lightsFramesArray[_currentLightsIndex]
        
        currentLight.run(
            SKAction.sequence([
                SKAction.fadeIn(withDuration: TimeInterval(0.2)),
                SKAction.wait(forDuration: TimeInterval(0.4)),
                SKAction.fadeOut(withDuration: TimeInterval(0.1)),]))
        
        self.run(SKAction.sequence([
            SKAction.wait(forDuration: TimeInterval(0.5)),
            SKAction.run{ self.blinkLightByOrder() }
            ]))
    }
    
    func blinkLightsByColors() {
        
        if (_currentLightsIndex < 3)
        {
            _currentLightsIndex += 1;
        }
        else
        {
            _currentLightsIndex = 0;
        }
        
        let currentLight1 = _lightsFramesArray[ufo_lightsByColor[_currentLightsIndex][0]]
        let currentLight2 = _lightsFramesArray[ufo_lightsByColor[_currentLightsIndex][1]]
        
        currentLight1.run(
            SKAction.sequence([
                SKAction.fadeIn(withDuration: TimeInterval(0.2)),
                SKAction.wait(forDuration: TimeInterval(0.4)),
                SKAction.fadeOut(withDuration: TimeInterval(0.1))]
            )
        )
        currentLight2.run(
            SKAction.sequence([
                SKAction.fadeIn(withDuration: TimeInterval(0.2)),
                SKAction.wait(forDuration: TimeInterval(0.4)),
                SKAction.fadeOut(withDuration: TimeInterval(0.1))]
            )
        )
        self.run(SKAction.sequence([
            SKAction.wait(forDuration: TimeInterval(0.5)),
            SKAction.run{ self.blinkLightByOrder() }
            ]))
    }
    
    func blinkLightsRandom() {
        
        var blinkTime: CGFloat
        
        for light in _lightsFramesArray {
            light.removeAllActions()
            blinkTime = CGFloat(arc4random()%10) / 10.0
            
            light.run(SKAction.repeatForever(SKAction.sequence([
                SKAction.fadeIn(withDuration: TimeInterval(blinkTime)),
                SKAction.wait(forDuration: TimeInterval(0.3)),
                SKAction.fadeOut(withDuration: TimeInterval(0.3)),
                SKAction.wait(forDuration: TimeInterval(blinkTime))
                ])))
        }
        
        _currentLightsIndex = -1;
        
    }
    
    
    func blinkAllLights() {
        
        for light in _lightsFramesArray {
            light.removeAllActions()
            
            light.run(SKAction.repeatForever(SKAction.sequence([
                SKAction.fadeIn(withDuration: TimeInterval(0.3)),
                SKAction.wait(forDuration: TimeInterval(0.3)),
                SKAction.fadeOut(withDuration: TimeInterval(0.3)),
                SKAction.wait(forDuration: TimeInterval(0.3))
                ])))
        }
        _currentLightsIndex = -1;
    }
    
    func allLightsOn() {
        for light in _lightsFramesArray {
            light.removeAllActions()
            light.run(SKAction.fadeIn(withDuration: TimeInterval(0.3)))
        }
        _currentLightsIndex = -1;
   }
  
    func allLightsOff() {
        for light in _lightsFramesArray {
            light.removeAllActions()
            light.alpha = 0
        }
        _currentLightsIndex = -1;
   }
}

class UFOSpriteTopView: KTF_Sprite {

    // DECLARE CLASS OBJECTS
    var _lightsSprite :KTF_Sprite!
    var _jetParticles :SKEmitterNode!
    var _currentLightsIndex = Int()
    static var _ufoBase: UFOSpriteTopView!
    var _ufoIndex:Int!
    var _life = 1
    
    func initUFO(ufoIndex:Int) -> UFOSpriteTopView
    {
        _ufoIndex = ufoIndex
        let ufoFileName = "ufo_top_base_" + String(_ufoIndex)
        UFOSpriteTopView._ufoBase = UFOSpriteTopView(imageNamed: ufoFileName)
        
        UFOSpriteTopView._ufoBase.addLights(ufoIndex:_ufoIndex)
        UFOSpriteTopView._ufoBase.addJetToUFO(ufoIndex:_ufoIndex)
        UFOSpriteTopView._ufoBase.tag = _ufoIndex
        return UFOSpriteTopView._ufoBase
    }

    
    func addLights(ufoIndex:Int) {
        
            var lightsTagName = ufo_tags.UFOObjectsTagLights.rawValue
            let lightsFileName = "ufo_top_lights_" + String(ufoIndex)
        
            _lightsSprite = KTF_Sprite(imageNamed: lightsFileName)
            _lightsSprite.position = KTF_POS().posInNodePrc(node:self, isParentFullScreen: false,
                                                      PrcX: CGFloat(UFO_CLASS_POS_LIST[UFO_OBJ_INDEX.UFO_LIGHTS.rawValue][0]),
                                                      PrcY: CGFloat(UFO_CLASS_POS_LIST[UFO_OBJ_INDEX.UFO_LIGHTS.rawValue][1]))
            _lightsSprite.zPosition = ufo_z_pos.ufo_lightsZorder.rawValue
            
            lightsTagName.append(String(ufoIndex))
            _lightsSprite.name = lightsTagName

            self.addChild(_lightsSprite)
        
        self.blinkAllLights()
        }

    func addJetToUFO(ufoIndex:Int)
    {
        _jetParticles = SKEmitterNode(fileNamed: "wide_jet_particles")
            _jetParticles.position = KTF_POS().posInNodePrc(node:self, isParentFullScreen: true,
                                                            PrcX: CGFloat(UFO_CLASS_POS_LIST[UFO_OBJ_INDEX.UFO_JET.rawValue][0]),
                                                            PrcY: CGFloat(UFO_CLASS_POS_LIST[UFO_OBJ_INDEX.UFO_JET.rawValue][1]))
        //_jetParticles.particlePositionRange.dx = 100
            _jetParticles.zPosition = self.zPosition - 10
            self.addChild(_jetParticles)
    }
    
    func stopParticles()
    {
        _jetParticles.removeAllActions()
        _jetParticles.removeFromParent()
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
    
    func getBulletPosPerType(index:Int) -> CGPoint
    {
        var exitPoint: CGPoint
        switch self.tag {
        case 0:
            switch index {
            case 0:
                //middle one shoot
                exitPoint = CGPoint(x: self.position.x, y: self.position.y + self.size.height/2)
                break
            case 1:
                //left 2 shoot
                exitPoint = CGPoint(x: self.position.x, y: self.position.y + self.size.height/2)
                break
            case 2:
                //right 2 shoot
                exitPoint = CGPoint(x: self.position.x, y: self.position.y + self.size.height/2)
                break
            case 3:
                //left 4 shoot
                exitPoint = CGPoint(x: self.position.x, y: self.position.y + self.size.height/2)
                break
            case 4:
                //right 4 shoot
                exitPoint = CGPoint(x: self.position.x, y: self.position.y + self.size.height/2)
                break
            default:
                //middle one shoot
                exitPoint = CGPoint(x: self.position.x, y: self.position.y + self.size.height/2)
            }
            break
        default:
            switch index {
            case 0:
                //middle one shoot
                exitPoint = CGPoint(x: self.position.x, y: self.position.y + self.size.height/2)
                break
            case 1:
                //left 2 shoot
                exitPoint = CGPoint(x: self.position.x, y: self.position.y + self.size.height/2)
                break
            case 2:
                //right 2 shoot
                exitPoint = CGPoint(x: self.position.x, y: self.position.y + self.size.height/2)
                break
            case 3:
                //left 4 shoot
                exitPoint = CGPoint(x: self.position.x, y: self.position.y + self.size.height/2)
                break
            case 4:
                //right 4 shoot
                exitPoint = CGPoint(x: self.position.x, y: self.position.y + self.size.height/2)
                break
            default:
                //middle one shoot
                exitPoint = CGPoint(x: self.position.x, y: self.position.y + self.size.height/2)
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
                endPoint = CGPoint(x: self.position.x, y: KTF_WIN_SIZE().getWinSize().height)
                break
            case 1:
                //left 2 shoot
                endPoint = CGPoint(x: self.position.x - self.size.width/4, y: KTF_WIN_SIZE().getWinSize().height)
                break
            case 2:
                //right 2 shoot
                endPoint = CGPoint(x: self.position.x + self.size.width/4, y: KTF_WIN_SIZE().getWinSize().height)
                break
            case 3:
                //left 4 shoot
                endPoint = CGPoint(x: self.position.x - self.size.width, y: KTF_WIN_SIZE().getWinSize().height)
                break
            case 4:
                //right 4 shoot
                endPoint = CGPoint(x: self.position.x + self.size.width, y: KTF_WIN_SIZE().getWinSize().height)
                break
            default:
                //middle one shoot
                endPoint = CGPoint(x: self.position.x, y: KTF_WIN_SIZE().getWinSize().height)
            }
            break
        default:
            switch index {
            case 0:
                //middle one shoot
                endPoint = CGPoint(x: self.position.x, y: KTF_WIN_SIZE().getWinSize().height)
                break
            case 1:
                //left 2 shoot
                endPoint = CGPoint(x: self.position.x - self.size.width/4, y: KTF_WIN_SIZE().getWinSize().height)
                break
            case 2:
                //right 2 shoot
                endPoint = CGPoint(x: self.position.x + self.size.width/4, y: KTF_WIN_SIZE().getWinSize().height)
                break
            case 3:
                //left 4 shoot
                endPoint = CGPoint(x: self.position.x - self.size.width/2, y: KTF_WIN_SIZE().getWinSize().height)
                break
            case 4:
                //right 4 shoot
                endPoint = CGPoint(x: self.position.x + self.size.width/2, y: KTF_WIN_SIZE().getWinSize().height)
                break
            default:
                //middle one shoot
                endPoint = CGPoint(x: self.position.x, y: KTF_WIN_SIZE().getWinSize().height)
            }
        }

        
        return endPoint
    }
    
    override func removeFromParent() {
       
  //      _lightsSprite.removeAllActions()
  //      _lightsSprite.removeFromParent()
        
    //    _jetParticles.removeAllChildren()
//_jetParticles.removeFromParent()
 //       _jetParticles.removeAllActions()
        
      //  UFOSpriteTopView._ufoBase.removeAllChildren()
     //   UFOSpriteTopView._ufoBase.removeFromParent()
     //   UFOSpriteTopView._ufoBase.removeAllActions()
        
        super.removeFromParent()
    }
}
