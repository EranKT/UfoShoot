//
//  KTFScroll.swift
//  TestSwiftGame
//
//  Created by EKT DIGIDESIGN on 1/4/18.
//  Copyright © 2018 EKT DIGIDESIGN. All rights reserved.
//


let MENU_TITLE_LABEL_OWNED = "CHOOSE"
let MENU_TITLE_LABEL_AVAILABE = "GET"
let MENU_TITLE_LABEL_NOT_AVAILABE = "OPEN AFTER LEVEL "

let MENU_BOTTOM_LABEL_OWNED = "V"
let lockName_ = "lock_image"


import Foundation
import SpriteKit

/* HOW TO IMPLEMENT:
 INIT:
 var _menu = KTF_Scroll()

 _menu = _menu.initScrollMenu(scene: self,
                              prefix: "ufo_top_base_",
                              pos: KTF_POS().posInPrc(PrcX: 50, PrcY: 50),
                              actionForImagePress: #selector(self.playButtonPressed))
 _menu.position = CGPoint(x:0, y:0)
 _menu.zPosition = gameZorder.scroll_menu_bg.rawValue//main_menu_z_pos.main_menu_z_ufo_menu.rawValue
 self.addChild(_ufoMenu)
 
 TAKE OVER TOUCH HANDLE:

 let menuSelection = _menu.touchesStarted(touches, with: event) - returns Int
    return
 
 _ufoMenu._currentItemIndex - index of item in the center 
*/

class KTF_Scroll: SKSpriteNode {
    
    var _menuItemsArray: [KTF_Sprite] = [KTF_Sprite]()
    var _scene:SKScene!
    
    var _itemSize: CGSize!
    var _centerPosition:CGPoint!
    
    var _itemsCount: Int!
    var _currentItemIndex: Int!
    let _rightNavButton = KTF_Sprite(imageNamed: "menu_right_button")
    let _leftNavButton = KTF_Sprite(imageNamed: "menu_left_button")
    static var _scrollMenu = KTF_Scroll()
    var _itemSelector:Selector!
    
    
    //INIT SCROLL MENU
    func initScrollMenu(scene:SKScene, // scene to present
                        prefix:String, // file name prefix for items to populate the menu
                        pos:CGPoint,   // center position for the menu
                        actionForImagePress:Selector // action for selecting item in the menu
        ) -> KTF_Scroll {

        KTF_Scroll._scrollMenu._scene = scene
        KTF_Scroll._scrollMenu._centerPosition = pos
        KTF_Scroll._scrollMenu.position = KTF_Scroll._scrollMenu._centerPosition
        
        KTF_Scroll._scrollMenu._itemSelector = actionForImagePress
        
        KTF_Scroll._scrollMenu._itemsCount = KTF_FILES_COUNT().countGroupOfFiles(prefix: prefix,
                                                                  sufix: "png",
                                                                  firstNumber: 0);
      KTF_Scroll._scrollMenu._currentItemIndex = KTF_DISK().getInt(forKey: SAVED_GAME_UFO)
        self.populateMenu(prefix: prefix)
        self.addNavButtons()
        self.setFirstSpriteInPlace()
        return KTF_Scroll._scrollMenu
    }

    //ADD ITEMS TO MENU
    // using saved array for available items
    //dark and add lock to not available items
    func populateMenu(prefix:String)
    {
        var itemFileName:String
        var itemSprite = KTF_Sprite()
        var mutableGameBoughtList = KTF_DISK().getArray(forKey: SAVED_GAME_BOUGHT_UFO_LIST) as! [Int]
        
        for i in 0...KTF_Scroll._scrollMenu._itemsCount-1 {
            
            itemFileName = prefix + String(i)
            itemSprite = KTF_Sprite(imageNamed: itemFileName)
            
            itemSprite.tag = i
            itemSprite.alpha = 0
            KTF_SCALE().ScaleMyNodeRelatively(nodeToScale: itemSprite)
            KTF_Scroll._scrollMenu._menuItemsArray.append(itemSprite)
            
            itemSprite.isEnabled = false
        
            // MAKE SURE FIRST UFO IS IN THE BOUGHT LIST
            if mutableGameBoughtList.count == 0
            {
                let firstUfo = KTF_Scroll._scrollMenu._menuItemsArray[0]
                firstUfo.isEnabled = true
                mutableGameBoughtList.append(firstUfo.tag)
                KTF_DISK().saveArray(array: mutableGameBoughtList, forKey: SAVED_GAME_BOUGHT_UFO_LIST)
            }
            var doesNeedToDarkUof = true
            //ENABLE TO SELECT UFO IF BOUGHT
            for savedSpriteIndex in mutableGameBoughtList {

                if savedSpriteIndex == i
                {
                    itemSprite.isEnabled = true
                    doesNeedToDarkUof = false
                }
            }
                if doesNeedToDarkUof
                {
                    itemSprite.color = SKColor.init(red: 0, green: 0, blue: 0, alpha: 1.0)
                    itemSprite.colorBlendFactor = 0.7
                    self.addLockToUfo(ufo:itemSprite)
            }
        }
    }

    // add lock image to non available items
    func addLockToUfo(ufo:KTF_Sprite)
    {
        let lockImage = KTF_Sprite(imageNamed: lockName_)
        lockImage.name = lockName_
        lockImage.zPosition = gameZorder.scroll_menu_lock.rawValue//main_menu_z_pos.main_menu_z_ufo_menu.rawValue
       lockImage.position = KTF_POS().posInNodePrc(node: ufo, isParentFullScreen: false, PrcX: 50, PrcY: 50)
        ufo.addChild(lockImage)
    }

    func removeLockFromUfo(ufo:KTF_Sprite)
    {
        //remove lock when ufo bought
        // for now no need because menu is refreshed by Game Class when item bought
    }
    
    // SET INITIAL MENU ITEM
    func setFirstSpriteInPlace() {
        
        let itemSpriteMiddle = KTF_Scroll._scrollMenu._menuItemsArray[KTF_Scroll._scrollMenu._currentItemIndex]

        KTF_Scroll._scrollMenu._scene.addChild(itemSpriteMiddle)
        itemSpriteMiddle.position = KTF_Scroll._scrollMenu._centerPosition
        itemSpriteMiddle.zPosition = gameZorder.scroll_menu_items.rawValue
        itemSpriteMiddle.alpha = 1.0
        
        KTF_Scroll._scrollMenu.setTitleLabelToMenu(currentItem: itemSpriteMiddle)
        KTF_Scroll._scrollMenu.setStatusLabelToMenu(currentItem: itemSpriteMiddle)
    }
    
    // ADD NAVIGATION BUTTONS
    func addNavButtons() {
        
        let itemSpriteMiddle = KTF_Scroll._scrollMenu._menuItemsArray[0]

        KTF_Scroll._scrollMenu._leftNavButton.position =  CGPoint(x: KTF_Scroll._scrollMenu._centerPosition.x - itemSpriteMiddle.frame.size.width*1.2,
                                           y: KTF_Scroll._scrollMenu._centerPosition.y)
        KTF_Scroll._scrollMenu._rightNavButton.position =  CGPoint(x: KTF_Scroll._scrollMenu._centerPosition.x + itemSpriteMiddle.frame.size.width*1.2,
                                           y: KTF_Scroll._scrollMenu._centerPosition.y)
        KTF_Scroll._scrollMenu._scene.addChild(KTF_Scroll._scrollMenu._leftNavButton)
        KTF_Scroll._scrollMenu._scene.addChild(KTF_Scroll._scrollMenu._rightNavButton)
        KTF_SCALE().ScaleMyNodeRelatively(nodeToScale: KTF_Scroll._scrollMenu._leftNavButton)
        KTF_SCALE().ScaleMyNodeRelatively(nodeToScale: KTF_Scroll._scrollMenu._rightNavButton)

        KTF_Scroll._scrollMenu._leftNavButton.zPosition = gameZorder.scroll_menu_nav_buttons.rawValue//main_menu_z_pos.main_menu_z_ufo_menu.rawValue
        KTF_Scroll._scrollMenu._rightNavButton.zPosition = gameZorder.scroll_menu_nav_buttons.rawValue//main_menu_z_pos.main_menu_z_ufo_menu.rawValue
    }
    
    func scrollItemsLeft() {
       
        var rightItemIndex:Int
        
        if _currentItemIndex == _itemsCount - 1 {
            rightItemIndex = 0
        }
        else
        {
            rightItemIndex = _currentItemIndex + 1
        }

        let itemSpriteMiddle = _menuItemsArray[_currentItemIndex]
        let itemSpriteRight = _menuItemsArray[rightItemIndex]
        if itemSpriteRight.parent == nil
        {
            _scene.addChild(itemSpriteRight)
        }
        itemSpriteRight.zPosition = gameZorder.scroll_menu_items.rawValue//main_menu_z_pos.main_menu_z_ufo_menu.rawValue

        itemSpriteRight.position = CGPoint(x: _centerPosition.x - itemSpriteMiddle.frame.size.width*1.2,
                                           y: _centerPosition.y)
        
        let leftPos = CGPoint(x: _centerPosition.x + itemSpriteMiddle.frame.size.width*1.2,
                              y: _centerPosition.y)
        
        itemSpriteMiddle.removeAllActions()
        itemSpriteRight.removeAllActions()

        itemSpriteMiddle.run(SKAction.sequence([
            SKAction.wait(forDuration: 0.5),
            SKAction.removeFromParent()
            ]))
        itemSpriteMiddle.run(SKAction.fadeOut(withDuration: 0.5))
        itemSpriteMiddle.run(SKAction.move(to: leftPos, duration: 0.5))
        
        
        
        itemSpriteRight.run(SKAction.fadeIn(withDuration: 0.5))
        itemSpriteRight.run(SKAction.move(to: _centerPosition, duration: 0.5))

        _currentItemIndex = rightItemIndex

        KTF_Scroll._scrollMenu.setTitleLabelToMenu(currentItem: itemSpriteRight)
        KTF_Scroll._scrollMenu.setStatusLabelToMenu(currentItem: itemSpriteRight)
        
    }

    func scrollItemsRight() {

        var leftItemIndex:Int
        
        if self._currentItemIndex == 0 {
            leftItemIndex = _itemsCount - 1
        }
        else
        {
            leftItemIndex = _currentItemIndex - 1
        }

        let itemSpriteMiddle = _menuItemsArray[_currentItemIndex]
        let itemSpriteLeft = _menuItemsArray[leftItemIndex]
        if itemSpriteLeft.parent == nil
        {
            _scene.addChild(itemSpriteLeft)
        }
        itemSpriteLeft.zPosition = gameZorder.scroll_menu_items.rawValue//main_menu_z_pos.main_menu_z_ufo_menu.rawValue
        itemSpriteLeft.position = CGPoint(x: _centerPosition.x + itemSpriteMiddle.frame.size.width*1.2,
                                          y: _centerPosition.y)
        

        let rightPos = CGPoint(x: _centerPosition.x - itemSpriteMiddle.frame.size.width*1.2,
                              y: _centerPosition.y)
      
        itemSpriteMiddle.removeAllActions()
        itemSpriteLeft.removeAllActions()

        itemSpriteMiddle.run(SKAction.sequence([
           SKAction.wait(forDuration: 0.5),
            SKAction.removeFromParent()
            ]))
        itemSpriteMiddle.run(SKAction.fadeOut(withDuration: 0.5))
        itemSpriteMiddle.run(SKAction.move(to: rightPos, duration: 0.5))
        
            itemSpriteLeft.run(SKAction.fadeIn(withDuration: 0.5))
            itemSpriteLeft.run(SKAction.move(to: _centerPosition, duration: 0.5))

        _currentItemIndex = leftItemIndex
   
        KTF_Scroll._scrollMenu.setTitleLabelToMenu(currentItem: itemSpriteLeft)
        KTF_Scroll._scrollMenu.setStatusLabelToMenu(currentItem: itemSpriteLeft)
    }
    
    // ADD TEXT LABEL ABOVE ITEM
    func setTitleLabelToMenu(currentItem: KTF_Sprite) {
      
        if (KTF_Scroll._scrollMenu.childNode(withName: "top") != nil)
        {
            let label = KTF_Scroll._scrollMenu.childNode(withName: "top")
            label?.removeFromParent()
        }
        
        let labelPos =  CGPoint(x: KTF_Scroll._scrollMenu._centerPosition.x,
                                                                  y: KTF_Scroll._scrollMenu._centerPosition.y + currentItem.frame.size.height*0.6)
        
        var title: String
        var color = SKColor()// SKColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        
        if currentItem.isEnabled
        {
            title = MENU_TITLE_LABEL_OWNED
            color = .green
        }else if currentItem.tag <= gameLevel_ - 1
        {
            title = MENU_TITLE_LABEL_AVAILABE
            color = .red
        }
        else
        {
            title = MENU_TITLE_LABEL_NOT_AVAILABE + String(KTF_Scroll._scrollMenu._currentItemIndex)
            color = .darkGray
        }
        
        
        let top = SKLabelNode(fontNamed: "Avenir-Black")
        top.text = title
        top.fontColor = color
        top.colorBlendFactor = 1.0
        top.fontSize = currentItem.frame.maxY/13
        top.position = labelPos//CGPoint(x:KTF_Scroll._scrollMenu.frame.midX, y:KTF_Scroll._scrollMenu.frame.midY*0.9)
        top.name = "top"
        KTF_Scroll._scrollMenu.addChild(top)
        
    }
    
     // ADD TEXT LABEL UNDER ITEM
    func setStatusLabelToMenu(currentItem: KTF_Sprite) {
        
        if (KTF_Scroll._scrollMenu.childNode(withName: "bottom") != nil)
        {
            let label = KTF_Scroll._scrollMenu.childNode(withName: "bottom")
            label?.removeFromParent()
        }
        if (KTF_Scroll._scrollMenu.childNode(withName: "coinBottom") != nil)
        {
            let labelCoin = KTF_Scroll._scrollMenu.childNode(withName: "coinBottom")
            labelCoin?.removeFromParent()
        }

        let labelPos =  CGPoint(x: KTF_Scroll._scrollMenu._centerPosition.x,
                                y: KTF_Scroll._scrollMenu._centerPosition.y - _leftNavButton.frame.size.height*1.7)
        
        var title: String
        let price = priceFactor_*KTF_Scroll._scrollMenu._currentItemIndex
        var color = UIColor()

        let coinsImage = KTF_Sprite(imageNamed:"space_coin")

        if currentItem.isEnabled
        {
            title = MENU_BOTTOM_LABEL_OWNED
            color = .green//UIColor.green
            coinsImage.alpha = 0
        }else if currentItem.tag <= gameLevel_ - 1
        {
            title = String(price)
            color = .red
        }
        else
        {
            title = String(price)
            color = .darkGray
        }
        
        let bottom = SKLabelNode(fontNamed: "Avenir-Black")
        bottom.text = title
        bottom.fontColor = color
        bottom.colorBlendFactor = 1.0
        bottom.fontSize = currentItem.frame.maxY/13
        bottom.position = labelPos//CGPoint(x:KTF_Scroll._scrollMenu.frame.midX, y:KTF_Scroll._scrollMenu.frame.midY*0.5)
        bottom.name = "bottom"
        KTF_Scroll._scrollMenu.addChild(bottom)
        
        KTF_SCALE().ScaleMyNodeRelatively(nodeToScale: coinsImage)
        coinsImage.position = CGPoint(x: labelPos.x - bottom.frame.size.width, y: labelPos.y + bottom.frame.size.height/2)
        coinsImage.name = "coinBottom"
        KTF_Scroll._scrollMenu.addChild(coinsImage)

    }
    
    // TOUCHES HANDELER TAKE CONTROL FROM SCENE
     func touchesStarted(_ touches: Set<UITouch>, with event: UIEvent?) -> Int{
        
        for touch in touches {
            
            let location = touch.location(in: self)
           
            let selectedUfo = _menuItemsArray[_currentItemIndex]
            let price = priceFactor_*KTF_Scroll._scrollMenu._currentItemIndex

            if _leftNavButton.contains(location)
            {
                self.scrollItemsLeft()
                return 0
            }
            else if _rightNavButton.contains(location)
            {
                scrollItemsRight()
                return 1
            }
            else if selectedUfo.contains(location)
            {
                if selectedUfo.isEnabled
                {//SELECT AVAILABLE UFO
                    _scene.perform(_itemSelector) 
                    return 2
                }
                else if selectedUfo.tag <= gameLevel_ - 1
                {
                    if price <= gameCoins_
                    {
                        //IF ITEM CAN BE BOUGHT
                 print("open GET popup")
                    return 3
                    }
                    else
                    {//IF ITEM TOO EXPENSIVE
                        print("open NO ENOUGH popup")
                        return 4
                    }
                }
                else
                {//IF ITEM WAIT TO FINISH LEVEL
                 print("open WAIT FOR LEVEL popup", selectedUfo.tag,gameLevel_, price, gameCoins_)
                    return 5
                }
            }
            else
            {
                return 6
            }
        }
        return 7
    }
    
    override func removeFromParent() {
        super.removeFromParent()
    }
}
