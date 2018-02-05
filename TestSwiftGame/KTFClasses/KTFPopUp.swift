//
//  KTFPopUp.swift
//  TestSwiftGame
//
//  Created by EKT DIGIDESIGN on 1/9/18.
//  Copyright © 2018 EKT DIGIDESIGN. All rights reserved.
//

import Foundation
import SpriteKit

enum popup_items_Zposition:CGFloat {
    case popUpLabel = 100
    case popUpButton
}


enum POPUP_WINDOW_SIZE:Int{
    case full_size = 0
    case middle_size
    case small_size
}

let POP_UP_BG_SIZE = [
    [1, 1],
    [1, 0.5],
    [0.5, 0.2]
]

enum POPUP_ITEMS_POS_INDEX:Int {
    case popUP_CLOSE_BUTTON = 0
    case posUP_LEFT
    case posUP_MIDDLE
    case posUP_RIGHT
    case posMIDDLE_LEFT
    case posMIDDLE_MIDDLE
    case posMIDDLE_RIGHT
    case posDOWN_LEFT
    case posDOWN_MIDDLE
    case posDOWN_RIGHT
}

/// FIX INIT LIKE UFO
class KTF_POPUP: KTF_Sprite
{
    // NEED TO MAKE timer
    static var _popUpInstance: KTF_POPUP!

    var closeButton_: KTF_Sprite!
    var scene_: SKScene!
    var popUpScaleFactorX_:CGFloat!
    var popUpScaleFactorY_:CGFloat!

    var _topLabel:SKLabelNode!
    var _middleLabel:SKLabelNode!
    var _bottomLabel:SKLabelNode!
    var _timerLabel:SKLabelNode!
    var _image:KTF_Sprite!
    var _firstButton:KTF_Sprite!
    var _secondButton:KTF_Sprite!
    var _closeButtonSelector:String!
    var _imageSelector:String!
    var _firstButtonSelector:String!
    var _secondButtonSelector:String!
    var _timer: Timer!
    var _timerSelector:String!

 // FIX POSITIONS

    // CREATE CLOSE BUTTON
    func initPopupWindow(size:POPUP_WINDOW_SIZE,
                         forScene:SKScene!,
                         closeButtonAction:String,
                         top:String,
                         topPos:POPUP_ITEMS_POS_INDEX,
                         middle:String,
                         middlePos:POPUP_ITEMS_POS_INDEX,
                         bottom:String,
                         bottomPos:POPUP_ITEMS_POS_INDEX,
                         imageName:String,
                         imagePos:POPUP_ITEMS_POS_INDEX,
                         actionForImagePress:String,
                         FirstButtonImage:String,
                         FirstButtonPos:POPUP_ITEMS_POS_INDEX,
                         actionForFirstButtonPress:String,
                         SecondButtonImage:String,
                         SecondButtonPos:POPUP_ITEMS_POS_INDEX,
                         actionForSecondButtonPress:String,
                         timerInSeconds:Int,
                         timerPos:POPUP_ITEMS_POS_INDEX,
                         actionForTimerFinished:String
                         ) -> KTF_POPUP
    {
        let texture = SKTexture(imageNamed: "pop_up_bg")
        let windowSize = CGSize(width: texture.size().width * CGFloat(POP_UP_BG_SIZE[size.rawValue][0]),
                                height: texture.size().height * CGFloat(POP_UP_BG_SIZE[size.rawValue][1]))
        
        KTF_POPUP._popUpInstance =   KTF_POPUP(texture: texture, size: windowSize)
 
            KTF_POPUP._popUpInstance.popUpScaleFactorX_ = CGFloat(POP_UP_BG_SIZE[size.rawValue][0])
            KTF_POPUP._popUpInstance.popUpScaleFactorY_ = CGFloat(POP_UP_BG_SIZE[size.rawValue][1])
        
        KTF_POPUP._popUpInstance.scene_ = forScene

        // ADD ELEMENTS TO BG
        KTF_POPUP._popUpInstance.addCloseButton()
        KTF_POPUP._popUpInstance.addTimer(time: timerInSeconds, timerPos: timerPos)
        KTF_POPUP._popUpInstance.addImage(imageName: imageName, imagePos: imagePos)
        KTF_POPUP._popUpInstance.addLabels(top: top, topPos: topPos, middle: middle, middlePos: middlePos, bottom: bottom, bottomPos: bottomPos)
        KTF_POPUP._popUpInstance.addButtons(FirstButtonImage: FirstButtonImage,
                                            FirstButtonPos: FirstButtonPos,
                                            SecondButtonImage: SecondButtonImage,
                                            SecondButtonPos: SecondButtonPos)
        
        KTF_POPUP._popUpInstance._closeButtonSelector = closeButtonAction
        KTF_POPUP._popUpInstance._imageSelector = actionForImagePress
        KTF_POPUP._popUpInstance._firstButtonSelector = actionForFirstButtonPress
        KTF_POPUP._popUpInstance._secondButtonSelector = actionForSecondButtonPress
        KTF_POPUP._popUpInstance._timerSelector = actionForTimerFinished
        return KTF_POPUP._popUpInstance
    }
    
    func scalePopUpWindow()
    {
        self.xScale *= KTF_POPUP._popUpInstance.popUpScaleFactorX_
        self.yScale *= KTF_POPUP._popUpInstance.popUpScaleFactorY_
        
    }
    func addCloseButton()
    {
        closeButton_ = KTF_Sprite(imageNamed: "pop_up_close_button")
       closeButton_.position = self.getPosForIndex(posIndex: POPUP_ITEMS_POS_INDEX.popUP_CLOSE_BUTTON.rawValue,
                                                   forItem:closeButton_)
        self.addChild(closeButton_)
        closeButton_.zPosition = popup_items_Zposition.popUpButton.rawValue
      //  closeButton_.xScale *= popUpScaleFactorX_
      //  closeButton_.yScale *= popUpScaleFactorY_
    }
    
    func addLabels(top:String,
                   topPos:POPUP_ITEMS_POS_INDEX,
                   middle:String,
                   middlePos:POPUP_ITEMS_POS_INDEX,
                   bottom:String,
                   bottomPos:POPUP_ITEMS_POS_INDEX)
    {
        //TOP TITLE LABEL
        if top.count > 0 {
       _topLabel = SKLabelNode(fontNamed: "Avenir-Black")
        _topLabel.text = top
        _topLabel.colorBlendFactor = 1.0
        _topLabel.fontColor = UIColor.red
        _topLabel.fontSize = 120 * popUpScaleFactorX_
        _topLabel.position =  self.getPosForIndex(posIndex: topPos.rawValue,
                                                  forItem:_topLabel)
        
        _topLabel.zPosition = popup_items_Zposition.popUpLabel.rawValue
        self.addChild(_topLabel)
        }

        //MIDDLE TITLE LABEL
        if middle.count > 0 {
   _middleLabel = SKLabelNode(fontNamed: "Avenir-Black")
            _middleLabel.text = middle
            _middleLabel.colorBlendFactor = 1.0
            _middleLabel.fontColor = UIColor.red
            _middleLabel.fontSize = 120 * popUpScaleFactorX_
            _middleLabel.position =  self.getPosForIndex(posIndex: middlePos.rawValue,
                                                         forItem:_middleLabel)
            
            _middleLabel.zPosition = popup_items_Zposition.popUpLabel.rawValue
            self.addChild(_middleLabel)
        }

        //BOTTOM TITLE LABEL
        if bottom.count > 0 {
 _bottomLabel = SKLabelNode(fontNamed: "Avenir-Black")
            _bottomLabel.text = bottom
            _bottomLabel.colorBlendFactor = 1.0
            _bottomLabel.fontColor = UIColor.red
            _bottomLabel.fontSize = 120 * popUpScaleFactorX_
            _bottomLabel.position =  self.getPosForIndex(posIndex: bottomPos.rawValue,
                                                         forItem:_bottomLabel)
            
            _bottomLabel.zPosition = popup_items_Zposition.popUpLabel.rawValue
            self.addChild(_bottomLabel)
        }
}
    
    func addImage(imageName:String, imagePos:POPUP_ITEMS_POS_INDEX)
    {
        if imageName.count > 0
        {
       _image = KTF_Sprite(imageNamed: imageName)
        _image.position = self.getPosForIndex(posIndex: imagePos.rawValue, forItem:_image)
        
        _image.zPosition = popup_items_Zposition.popUpLabel.rawValue
        self.addChild(_image)
        _image.xScale *= popUpScaleFactorX_
        _image.yScale *= popUpScaleFactorX_
        }
        else
        {
            _image = nil
        }
    }
    
    func addButtons(FirstButtonImage:String,
                    FirstButtonPos:POPUP_ITEMS_POS_INDEX,
                    SecondButtonImage:String,
                    SecondButtonPos:POPUP_ITEMS_POS_INDEX)
    {
   if FirstButtonImage.count > 0
        {
          _firstButton = KTF_Sprite(imageNamed: "pop_up_button")
            _firstButton.xScale *= popUpScaleFactorX_
            _firstButton.yScale *= popUpScaleFactorX_
            _firstButton.position = self.getPosForIndex(posIndex: FirstButtonPos.rawValue,
                                                        forItem:_firstButton)
                
            _firstButton.zPosition = popup_items_Zposition.popUpButton.rawValue
            self.addChild(_firstButton)

            // ADD IMAGE TO BUTTON
            let imageOnFirstButton = KTF_Sprite(imageNamed: FirstButtonImage)
      //      imageOnFirstButton.xScale *= popUpScaleFactorX_
      //      imageOnFirstButton.yScale *= popUpScaleFactorX_
            imageOnFirstButton.position = KTF_POS().posInNodePrc(node: _firstButton,
                                                                 isParentFullScreen: false,
                                                                 PrcX: 50,
                                                                 PrcY: 50)
            imageOnFirstButton.zPosition = popup_items_Zposition.popUpButton.rawValue + 1
            _firstButton.addChild(imageOnFirstButton)
        }
   else
   {
    _firstButton = nil
        }
        if SecondButtonImage.count > 0
        {
           _secondButton = KTF_Sprite(imageNamed: "pop_up_button")
            _secondButton.xScale *= popUpScaleFactorX_
            _secondButton.yScale *= popUpScaleFactorX_
            _secondButton.position = self.getPosForIndex(posIndex: SecondButtonPos.rawValue,
                                                         forItem:_secondButton)
            
            _secondButton.zPosition = popup_items_Zposition.popUpButton.rawValue
            self.addChild(_secondButton)
       
            // ADD IMAGE TO BUTTON
            let imageOnSecondButton = KTF_Sprite(imageNamed: SecondButtonImage)
         //   imageOnSecondButton.xScale *= popUpScaleFactorX_
         //   imageOnSecondButton.yScale *= popUpScaleFactorX_
           imageOnSecondButton.position = KTF_POS().posInNodePrc(node: _secondButton,
                                                                 isParentFullScreen: false,
                                                                 PrcX: 50,
                                                                 PrcY: 50)
            imageOnSecondButton.zPosition = popup_items_Zposition.popUpButton.rawValue + 1
            _secondButton.addChild(imageOnSecondButton)
      }
        else
        {
            _secondButton = nil
        }
    }
    var _time = 0
    func addTimer(time:Int, timerPos:POPUP_ITEMS_POS_INDEX) {
    
        _time = time

        if time > 0 {

            var timeText = String(time)
            if time < 10
            {
                timeText = "0:0" + String(time)
            }
            else
            {
                timeText = "0:" + String(time)
            }
            
            _timerLabel = SKLabelNode(fontNamed: "Avenir-Black")
            _timerLabel.text = timeText
            _timerLabel.colorBlendFactor = 1.0
            _timerLabel.fontColor = UIColor.green
            _timerLabel.fontSize = 120 * popUpScaleFactorX_
            _timerLabel.position =  self.getPosForIndex(posIndex: timerPos.rawValue,
                                                        forItem:_timerLabel)
            
            _timerLabel.zPosition = popup_items_Zposition.popUpLabel.rawValue
            self.addChild(_timerLabel)
            _timer = Timer.scheduledTimer(timeInterval: TimeInterval(1) , target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
       }
    }
    
    @objc func updateTimer()
    {
        _time -= 1
        var timeText = String(_time)
        if _time >= 0 {
            
            if _time < 10
            {
                timeText = "0:0" + String(_time)
                if _time < 5
                {
                    _timerLabel.fontColor = UIColor.red
                }
            }
            else
            {
                timeText = "0:" + String(_time)
            }
            _timerLabel.text = timeText
        }
        else
        {
            self.stopTimer()
            scene_.perform(NSSelectorFromString(_timerSelector))
        }
    }

    func stopTimer()
    {
        if _timer != nil
        {
            _timer.invalidate()
            _timer = nil
        }
        self.removeFromParent()
}
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let location = touch.location(in: self)
            //CLOSE BUTTON
            if closeButton_ == nil {return}
            if closeButton_.contains(location)
            {
                if _closeButtonSelector != ""
                {
              //  self.stopTimer()
                scene_.perform(NSSelectorFromString(_closeButtonSelector))
                print("CLOSE BUTTON PRESSED")
                return
                }
                self.stopTimer()
                return
            }
            
            if _imageSelector != ""
            {
                if _image.contains(location)
                {
                    self.stopTimer()
                    scene_.perform(NSSelectorFromString(_imageSelector))
                    print("IMAGE BUTTON PRESSED")
                    return
                }
            }
            
            if _firstButtonSelector != ""
            {
                if _firstButton.contains(location)
                {
                    self.stopTimer()
                    scene_.perform(NSSelectorFromString(_firstButtonSelector))
                    print("FIRST BUTTON PRESSED")
                    return
         }
            }

            if _secondButtonSelector != ""
            {
            if _secondButton.contains(location)
            {
                self.stopTimer()
                scene_.perform(NSSelectorFromString(_secondButtonSelector))
                print("SECOND BUTTON PRESSED")
                return
          }
            }
        }
    }
    
    func getPosForIndex(posIndex:Int, forItem:SKNode) -> CGPoint {
        var itemPos: CGPoint!
        
        switch posIndex {
        case POPUP_ITEMS_POS_INDEX.popUP_CLOSE_BUTTON.rawValue:
            itemPos = CGPoint(x:self.position.x + self.size.width/2 - closeButton_.size.width*0.1,
                              y:self.position.y + self.size.height/2 - closeButton_.size.height*0.1)
            break
        case POPUP_ITEMS_POS_INDEX.posUP_LEFT.rawValue:
            itemPos = CGPoint(x:forItem.frame.size.width * 1.3,
                              y:self.position.x - self.size.width/2 + forItem.frame.size.width * 0.7)
            break
        case POPUP_ITEMS_POS_INDEX.posUP_MIDDLE.rawValue:
            itemPos = CGPoint(x:self.position.x,
                              y:self.position.y + self.size.height/2 - forItem.frame.size.height * 1.5)
            break
        case POPUP_ITEMS_POS_INDEX.posUP_RIGHT.rawValue:
            itemPos = CGPoint(x:self.position.x + self.size.width/4,// - forItem.frame.size.width * 1.0,
                              y:self.position.y + self.size.height/2 - forItem.frame.size.height * 1.1)
            break
        case POPUP_ITEMS_POS_INDEX.posMIDDLE_LEFT.rawValue:
            itemPos = CGPoint(x:self.position.x - self.size.width/4,// + forItem.frame.size.width * 0.7,
                              y:self.position.y)
            break
        case POPUP_ITEMS_POS_INDEX.posMIDDLE_MIDDLE.rawValue:
            itemPos = CGPoint(x:self.position.x,
                              y:self.position.y)
            break
        case POPUP_ITEMS_POS_INDEX.posMIDDLE_RIGHT.rawValue:
            itemPos = CGPoint(x:self.position.x + self.size.width/4,// - forItem.frame.size.width * 0.7,
                              y:self.position.y)
            break
        case POPUP_ITEMS_POS_INDEX.posDOWN_LEFT.rawValue:
            itemPos = CGPoint(x:self.position.x - self.size.width/2 + forItem.frame.size.width * 0.7,
                              y:self.position.y - self.size.height/2 + forItem.frame.size.height * 0.7)
            break
        case POPUP_ITEMS_POS_INDEX.posDOWN_MIDDLE.rawValue:
            itemPos = CGPoint(x:self.position.x,
                              y:self.position.y - self.size.height/2 + forItem.frame.size.height * 0.7)
            break
        case POPUP_ITEMS_POS_INDEX.posDOWN_RIGHT.rawValue:
            itemPos = CGPoint(x:self.position.x + self.size.width/4,// - forItem.frame.size.width * 0.7,
                              y:self.position.y - self.size.height/2 + forItem.frame.size.height * 0.7)
            break
        default:
            itemPos = CGPoint(x:0,y:0)
        }
        
        return itemPos
    }
    
    
    //TIMER
    
 
    
 
    override func removeFromParent()
    {
        if KTF_POPUP._popUpInstance._topLabel != nil
        {
            KTF_POPUP._popUpInstance.closeButton_.removeFromParent()
            KTF_POPUP._popUpInstance.closeButton_ = nil
        }
        if KTF_POPUP._popUpInstance._topLabel != nil
        {
            KTF_POPUP._popUpInstance._topLabel.removeFromParent()
            KTF_POPUP._popUpInstance._topLabel = nil
        }
        if KTF_POPUP._popUpInstance._middleLabel != nil
        {
            KTF_POPUP._popUpInstance._middleLabel.removeFromParent()
            KTF_POPUP._popUpInstance._middleLabel = nil
        }
        if KTF_POPUP._popUpInstance._bottomLabel != nil
        {
            KTF_POPUP._popUpInstance._bottomLabel.removeFromParent()
            KTF_POPUP._popUpInstance._bottomLabel = nil
        }
        if KTF_POPUP._popUpInstance._image != nil
        {
            KTF_POPUP._popUpInstance._image.removeFromParent()
            KTF_POPUP._popUpInstance._image = nil
        }
        if KTF_POPUP._popUpInstance._firstButton != nil
        {
            KTF_POPUP._popUpInstance._firstButton.removeFromParent()
            KTF_POPUP._popUpInstance._firstButton = nil
        }
        if KTF_POPUP._popUpInstance._secondButton != nil
        {
            KTF_POPUP._popUpInstance._secondButton.removeFromParent()
            KTF_POPUP._popUpInstance._secondButton = nil
        }

        self.isEnabled = false
        super.removeFromParent()
    }
}
