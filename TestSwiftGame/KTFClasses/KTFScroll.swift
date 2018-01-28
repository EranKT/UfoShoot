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


import Foundation
import SpriteKit

class KTF_Scroll: SKSpriteNode {
    
    var _menuItemsArray: [KTF_Sprite] = [KTF_Sprite]()
 //   var _savedItemsArray: [KTF_Sprite] = [KTF_Sprite]()
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
    func initScrollMenu(scene:SKScene,
                        prefix:String,
                        pos:CGPoint,
                        actionForImagePress:Selector) -> KTF_Scroll {

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
    func populateMenu(prefix:String) {
        
        var itemFileName:String
        
        var itemSprite = KTF_Sprite()
        
        var mutableGameBoughtList = KTF_DISK().getArray(forKey: SAVED_GAME_BOUGHT_UFO_LIST) as! [Int] // for buy test:[Int] = []
        for i in 0...KTF_Scroll._scrollMenu._itemsCount-1 {
            
            itemFileName = prefix + String(i)
            itemSprite = KTF_Sprite(imageNamed: itemFileName)

            if i >= gameLevel_
            {
                //COLOR SPRITE IN GRAY
            /*    let myImage = UIImage.init(named: itemFileName)
                let aImage:UIImage = KTF_GRAY_IMAGE().convertImageToGrayScale(image: myImage!)
                //   let sourceImageRef = aImage.cgImage
                let texture = SKTexture(image:aImage)
                itemSprite = KTF_Sprite(texture: texture)
                itemSprite.alpha = 0.5
                //    itemSprite = KTF_Sprite(spriteWithCGImage:sourceImageRef, key:"")
              */
         }
            
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
                }
        }
  
        
    }

    // SET INITIAL MENU ITEM
    func setFirstSpriteInPlace() {
        
        let itemSpriteMiddle = KTF_Scroll._scrollMenu._menuItemsArray[KTF_Scroll._scrollMenu._currentItemIndex]

        KTF_Scroll._scrollMenu._scene.addChild(itemSpriteMiddle)
        itemSpriteMiddle.position = KTF_Scroll._scrollMenu._centerPosition
        itemSpriteMiddle.zPosition = main_menu_z_pos.main_menu_z_play_button.rawValue
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

        KTF_Scroll._scrollMenu._leftNavButton.zPosition = main_menu_z_pos.main_menu_z_play_button.rawValue
        KTF_Scroll._scrollMenu._rightNavButton.zPosition = main_menu_z_pos.main_menu_z_play_button.rawValue
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
        itemSpriteRight.zPosition = main_menu_z_pos.main_menu_z_play_button.rawValue

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
        itemSpriteLeft.zPosition = main_menu_z_pos.main_menu_z_play_button.rawValue
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
                                y: KTF_Scroll._scrollMenu._centerPosition.y - _leftNavButton.frame.size.height*1.4)
        
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
                {//SELECT OWNED UFO
                    _scene.perform(_itemSelector) 
                    return 2
                }
                else if selectedUfo.tag <= gameLevel_ - 1
                {
                    if price <= gameCoins_
                    {//IF ITEM CAN BE BOUGHT
                 print("open GET pop up")
                    return 3
                    }
                    else
                    {//IF ITEM TOO EXPENSIVE
                        print("open NO ENOUGH pop up")
                        return 4
                    }
                }
                else
                {//IF ITEM WAIT TO FINISH LEVEL
                 print("open WAIT FOR LEVEL pop up", selectedUfo.tag,gameLevel_, price, gameCoins_)
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
/*
        _rightNavButton.removeFromParent()
        _leftNavButton.removeFromParent()
       
        if KTF_Scroll._scrollMenu._menuItemsArray.count > 0
        {
        for item in _menuItemsArray
        {
            if item.parent != nil
            {
            item.removeFromParent()
            }
            
        }
        
        _menuItemsArray.removeAll()
        }*/
        super.removeFromParent()
    }
}
