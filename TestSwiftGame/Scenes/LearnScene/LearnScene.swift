//
//  LearnScene.swift
//  TestSwiftGame
//
//  Created by EKT DIGIDESIGN on 12/22/17.
//  Copyright © 2017 EKT DIGIDESIGN. All rights reserved.
//

import Foundation
import SpriteKit

let LEARN_SCENE_POS_LIST = [
    [50.0, 50.0],   //BG
    [12, 94],   //HOME BUTTON
]

enum learn_scene_z_pos: CGFloat
{
    case learn_scene_z_bg = 0
    case learn_scene_z_home_button
    case learn_scene_z_item_buttons
}

let ITEMS_POSITIONS_NUMBERS = [
    // (from top left)
    
    [20, 75], [35, 75], [50, 75], [65, 75], [80, 75],
    [20, 55], [35, 55], [50, 55], [65, 55], [80, 55],
    [20, 35], [35, 35], [50, 35], [65, 35], [80, 35],
    [20, 15], [35, 15], [50, 15], [65, 15], [80, 15],
]

let ITEMS_POSITIONS_SHAPES = [
    // (from top left)
    [20, 76], [40, 76], [60, 76], [80, 76],
    [20, 56], [40, 56], [60, 56], [80, 56],
    [20, 36], [40, 36], [60, 36], [80, 36],
    [20, 16], [40, 16], [60, 16], [80, 16]
]

let ITEMS_POSITIONS_FRUITS = [
    // (from top left)
    [20, 76], [40, 76], [60, 76], [80, 76],//apple banana cherry grapes
    [20, 56], [30, 16], [70, 16], [80, 56],//kiwi lemon melon orange
    [20, 36], [40, 36], [60, 36], [50, 16],//peach pear pinapple plum
    [40, 56], [60, 56], [80, 36],//palmgranate strawberry watermellon
]

let ITEMS_POSITIONS_COLORS = [
    // (from top left)
    [8, 52],
    [20, 76], [32, 76], [44, 76], [56, 76], [68, 76], [80, 76],
    [20, 60], [32, 60], [44, 60], [56, 60], [68, 60], [80, 60],
    [20, 44], [32, 44], [44, 44], [56, 44], [68, 44], [80, 44],
    [20, 28], [32, 28], [44, 28], [56, 28], [68, 28], [80, 28],
    [20, 12], [32, 12], [44, 12], [56, 12], [68, 12], [80, 12],
    [92, 52]
]

let ITEMS_POSITIONS_LETTERS = [
    // (from top left)
    [20, 76], [32, 76], [44, 76], [56, 76], [68, 76], [80, 76],
    [20, 60], [32, 60], [44, 60], [56, 60], [68, 60], [80, 60],
    [20, 44], [32, 44], [44, 44], [56, 44], [68, 44], [80, 44],
    [20, 28], [32, 28], [44, 28], [56, 28], [68, 28], [80, 28],
    [44, 12], [56, 12]
]

let ITEMS_POSITIONS_VEGETABLES = [
    // (from top left)
    //  [8, 52],
    [20, 76], [40, 76], [60, 76], [80, 76],
    [20, 56], [30, 16], [70, 16], [80, 56],
    [20, 36], [40, 36], [60, 36], [50, 16],
    [40, 56], [60, 56], [80, 36],
]

let ITEMS_POSITIONS_WILD = [
    // (from top left)
    [20, 76], [40, 76], [60, 76], [80, 76],
    [20, 56], [40, 56], [60, 56], [80, 56],
    [20, 36], [40, 36], [60, 36], [80, 36],
    [30, 16], [50, 16], [70, 16]
]

let ITEMS_POSITIONS_FARM = [
    // (from top left)
    //  [8, 52],
    [20, 76], [40, 76], [60, 76], [80, 76],
    [20, 56], [40, 56], [60, 56], [80, 56],
    [20, 36], [40, 36], [60, 36], [80, 36],
    [30, 16], [50, 16], [70, 16],
]



class LearnScene: SKScene {
    
    let _homeButton = KTF_Sprite(imageNamed: "home_button.png")
    var _itemsArray :[KTF_Sprite] = [KTF_Sprite]()
    var _category: Int!
    var _numberOfItems: Int!
    var _lastPressedItem: Int!
    var _scaleX: CGFloat!
    var _scaleY: CGFloat!
    var _willPlaySfx: Bool!
    var _filePrefix = "view_"

    override func didMove(to view: SKView) {
    
           KTF_Ads_Banner_Support().setAdsPos(atPos: KTF_Ads_Position.KTF_Ads_Position_bottom_middle)
        
        _category = 4
        _filePrefix.append(String(_category))
        _filePrefix.append("_item_")
        
        _numberOfItems = KTF_FILES_COUNT().countGroupOfFiles(prefix: _filePrefix, sufix: ".png", firstNumber: 0)
        _lastPressedItem = -1
        _willPlaySfx = false
        
        self.addBgImage()
        self.addHomeButton()
        self.addItems()
    }
    
    //////>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> CREATE SCENE ELEMENTS
    // ADD BG
    func addBgImage()
    {
        let bgSprite = KTF_Sprite(imageNamed: "main_bg")
        bgSprite.position = KTF_POS().posInPrc(PrcX: CGFloat(LEARN_SCENE_POS_LIST[0][0]),
                                               PrcY: CGFloat(LEARN_SCENE_POS_LIST[0][1]))
        KTF_SCALE().ScaleMyNode(nodeToScale: bgSprite)
        self.addChild(bgSprite)
        bgSprite.zPosition = learn_scene_z_pos.learn_scene_z_bg.rawValue;
    }
    
    // ADD LEARN BUTTON
    func addHomeButton()
    {
        _homeButton.position = KTF_POS().posInPrc(PrcX: CGFloat(LEARN_SCENE_POS_LIST[1][0]),
                                                  PrcY: CGFloat(LEARN_SCENE_POS_LIST[1][1]))
        KTF_SCALE().ScaleMyNodeRelatively(nodeToScale: _homeButton)
        self.addChild(_homeButton)
        _homeButton.zPosition = learn_scene_z_pos.learn_scene_z_home_button.rawValue;
    }
    
    func addItems() {
        
        let scaleFactor = ITEMS_SCALE_PER_CATEGORY[_category]
        
        var fileNamePrefix: String!
        var fileName: String!
        var item: KTF_Sprite!
        
        
        for i in 0...(_numberOfItems - 1)
        {
            fileName = _filePrefix
            fileName.append(String(i))
           fileNamePrefix = fileName
            fileName.append(".png")
            
            item = KTF_Sprite(imageNamed: fileName)
            KTF_SCALE().ScaleMyNodeRelatively(nodeToScale: item)
            item.xScale = item.xScale / scaleFactor
            item.position = self.getItemsPosPerCategory(item: item, index: i)
           item.zPosition = learn_scene_z_pos.learn_scene_z_item_buttons.rawValue + CGFloat(i)
            item.name = fileNamePrefix
            item.tag = 1
            self.addChild(item)
            _itemsArray.append(item)

            self.itemFloatAnimation(item: item)
            
            _scaleX = item.xScale;
            _scaleY = item.yScale
        }
        
    }

    func getItemsPosPerCategory(item:KTF_Sprite, index:Int) -> CGPoint {
        var itemPos: CGPoint
        
        switch (_category) {
        case CATEGORIES.NUMBERS.rawValue:
            itemPos = KTF_POS().posInPrc(PrcX: CGFloat(ITEMS_POSITIONS_NUMBERS[index][0]),
                                         PrcY: CGFloat(ITEMS_POSITIONS_NUMBERS[index][1]))
            break
        case CATEGORIES.SHAPES.rawValue:
            itemPos = KTF_POS().posInPrc(PrcX: CGFloat(ITEMS_POSITIONS_SHAPES[index][0]),
                                         PrcY: CGFloat(ITEMS_POSITIONS_SHAPES[index][1]))
            break
        case CATEGORIES.FRUITS.rawValue:
            itemPos = KTF_POS().posInPrc(PrcX: CGFloat(ITEMS_POSITIONS_FRUITS[index][0]),
                                         PrcY: CGFloat(ITEMS_POSITIONS_FRUITS[index][1]))
            break
        case CATEGORIES.COLORS.rawValue:
            itemPos = KTF_POS().posInPrc(PrcX: CGFloat(ITEMS_POSITIONS_COLORS[index][0]),
                                         PrcY: CGFloat(ITEMS_POSITIONS_COLORS[index][1]))
            break
        case CATEGORIES.LETTERS.rawValue:
            itemPos = KTF_POS().posInPrc(PrcX: CGFloat(ITEMS_POSITIONS_LETTERS[index][0]),
                                         PrcY: CGFloat(ITEMS_POSITIONS_LETTERS[index][1]))
            break
        case CATEGORIES.VEGETABLES.rawValue:
            itemPos = KTF_POS().posInPrc(PrcX: CGFloat(ITEMS_POSITIONS_VEGETABLES[index][0]),
                                         PrcY: CGFloat(ITEMS_POSITIONS_VEGETABLES[index][1]))
            break
        case CATEGORIES.WILD.rawValue:
            itemPos = KTF_POS().posInPrc(PrcX: CGFloat(ITEMS_POSITIONS_WILD[index][0]),
                                         PrcY: CGFloat(ITEMS_POSITIONS_WILD[index][1]))
            break
        case CATEGORIES.FARM.rawValue:
            itemPos = KTF_POS().posInPrc(PrcX: CGFloat(ITEMS_POSITIONS_FARM[index][0]),
                                         PrcY: CGFloat(ITEMS_POSITIONS_FARM[index][1]))
            break
            
        default:
            itemPos = KTF_POS().posInPrc(PrcX: CGFloat(ITEMS_POSITIONS_LETTERS[index][0]),
                                         PrcY: CGFloat(ITEMS_POSITIONS_LETTERS[index][1]))
           break
        }
  
        return itemPos
        
    }
    
    func itemFloatAnimation(item:KTF_Sprite) {
        
        let rotationSpeed = CGFloat(20) / CGFloat(arc4random()%10+20)
        let angle = KTF_CONVERT().degreesToRadians(degrees: CGFloat(((arc4random()%2)+10)/5))
        
        let action1 = SKAction.rotate(toAngle: -angle, duration: TimeInterval(rotationSpeed))
        let action2 = SKAction.rotate(toAngle: angle, duration: TimeInterval(rotationSpeed))
        let action3 = SKAction.sequence([action1, action2])
        let action4 = SKAction.repeatForever(action3)
        item.run(action4)
        
    }

    /////<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< HANDLE TOUCHES
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch in touches {
            let location = touch.location(in: self)
            for item in _itemsArray
            {
                if item.contains(location)
                {
                    self.scaleTouchedItem(item: item)
                  // ANIMALS CATEGORIES PLAY SOUND/NAME
                    if (_category == CATEGORIES.WILD.rawValue || _category == CATEGORIES.FARM.rawValue)
                    {
                        if (item.tag != _lastPressedItem)
                        {
                            _willPlaySfx = false
                        }
                        if (_willPlaySfx)
                        {
                            _willPlaySfx = false;
                            self.playItemSfx(item: item);
                        }
                        else
                        {
                            _willPlaySfx = true;
                            self.sayItemName(item: item)
                        }
                        _lastPressedItem = item.tag;
                    }
                    else
                    {
                     // ALL REST OF CATEGORIES SAY NAME
                        self.sayItemName(item: item)
                    }
                    break
                }
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    /*    for touch in touches {
            let location = touch.location(in: self)
            
        }
   */ }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let location = touch.location(in: self)
            
            if _homeButton.contains(location)
            {
             self.homeButtonAction()
            }
        }
    }
    /////>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> HANDLE TOUCHES
    
 //SCALE ITEM WHEN TOUCHED
    func scaleTouchedItem(item:KTF_Sprite) {
        
        item.run(SKAction.sequence(
            [SKAction.scaleX(to: (_scaleX * 1.4), y: (_scaleY * 1.4), duration: 0.1),
             SKAction.scaleX(to: _scaleX, y: _scaleY, duration: 0.1)]))
    }
//SAY ITEM'S NAME
    func sayItemName(item:KTF_Sprite) {
   
        let itemName = item.name
        KTF_Sound_Engine().playSound(fileName: itemName!)
    }
//PLAY ITEM SFX
    func playItemSfx(item:KTF_Sprite) {
        
        var itemName = item.name
        itemName!.append("_sfx")
        KTF_Sound_Engine().playSound(fileName: itemName!)
    }
// HOME BUTTON PRESSED
    func homeButtonAction() {
        KTF_Sound_Engine().playSound(fileName: "laser_short")
        
        if let view = self.view {
            let transition:SKTransition = SKTransition.flipHorizontal(withDuration: 1.0)
            let scene:SKScene = MainScene(size: self.size)
            scene.scaleMode = .aspectFill
            view.presentScene(scene, transition: transition)
        }
    }
}
