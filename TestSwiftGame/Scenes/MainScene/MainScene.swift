//
//  MainScene.swift
//  TestSwiftGame
//
//  Created by EKT DIGIDESIGN on 12/6/17.
//  Copyright © 2017 EKT DIGIDESIGN. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

enum main_menu_z_pos: CGFloat
{
    case main_menu_z_bg = 0
    case main_menu_z_play_button
    case main_menu_z_map_button
    case main_menu_z_ufo_menu
    case main_menu_z_title
    case main_menu_z_more_button
    case main_menu_z_rate_button
    case main_menu_z_popUpWindow
}

let MAIN_SCENE_POS_LIST = [
    [50.0, 50.0],   //0 BG
    [50.0, 75.0],   //1 TITLE
    [20, 20],    //2 map
    [80, 20.0],    //3 PLAY
    [50.0, 47.0],    //4 MENU
    [50.0, 50.0],    //5 MORE
    [50.0, 50.0]    //6 RATE
]

enum main_menu_pop_up_type: Int
{
    case get = 0
    case not_enough_coins
    case not_available_yet
}

class MainScene: SKScene {
 
    // DECLARE CLASS OBJECTS
    private var _mapButton = KTF_Sprite(imageNamed: "map_button")
    private var _playButton = KTF_Sprite(imageNamed: "pop_up_button")
 //   private var moreButton = UIMenuItem.init(title: #imageLiteral(resourceName: "more_button"), action: <#T##Selector#>)
    private var rateButton = KTF_Sprite(imageNamed: "rate_button")
    var _ufoMenu = KTF_Scroll()
    var _popUpWindow: KTF_POPUP!

    var _statusBar: KTF_StatusBar!

    // let audio = KTF_MusicPlayer.sharedInstance()

    override func didMove(to view: SKView) {
        
       //REMOVE IF CONDITION TO RESET FOR TESTS
        if gameLevel_ <= 0
        {
            gameLevel_ = 1
            gameStage_ = 1
            KTF_DISK().saveInt(number: gameLevel_, forKey: SAVED_GAME_FINISHED_LEVEL)
            KTF_DISK().saveInt(number: gameStage_, forKey: SAVED_GAME_FINISHED_STAGE)
            KTF_DISK().saveInt(number: 0, forKey: SAVED_GAME_COINS)
            KTF_DISK().saveInt(number: 0, forKey: SAVED_GAME_SCORE)
        }
        gameSelectedLevel_ = gameLevel_
        gameSelectedStage_ = gameStage_
        KTF_DISK().saveInt(number: gameSelectedLevel_, forKey: SAVED_GAME_SELECTED_LEVEL)
        KTF_DISK().saveInt(number: gameSelectedStage_, forKey: SAVED_GAME_SELECTED_STAGE)
     //   KTF_DISK().saveInt(number: 0, forKey: SAVED_GAME_UFO)
        KTF_DISK().saveBool(isTrue: false, forKey: SAVED_IS_CHANGING_STAGE)

        KTF_Ads_Banner_Support().setAdsPos(atPos: KTF_Ads_Position.KTF_Ads_Position_bottom_middle)
        
        self.addBgImage()
        self.addMapButton()
        self.addTitleImage()
        self.addPlayButton()
      //  self.setPopUpWindow()
        let menuPos = KTF_POS().posInPrc(PrcX: CGFloat(MAIN_SCENE_POS_LIST[4][0]),
                                        PrcY: CGFloat(MAIN_SCENE_POS_LIST[4][1]))
        _ufoMenu = _ufoMenu.initScrollMenu(scene: self,
                                           prefix: "ufo_top_base_",
                                           pos: menuPos,
                                           actionForImagePress:#selector(self.playButtonPressed))
        _ufoMenu.position = CGPoint(x:0, y:0)
        _ufoMenu.zPosition = main_menu_z_pos.main_menu_z_ufo_menu.rawValue
        self.addChild(_ufoMenu)
  
        _statusBar = KTF_StatusBar().initStatusBar(scene: self, posIsTop: true)
        _statusBar.populateStatusBar(includeSavedScore:true)
        
    }
// LOAD SCENE
    override func sceneDidLoad() {}
    
    
    
    //////>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> CREATE SCENE ELEMENTS
   
    // ADD BG
    func addBgImage()
    {
        let bgSprite = KTF_Sprite(imageNamed: "main_bg")
        bgSprite.position = KTF_POS().posInPrc(PrcX: CGFloat(MAIN_SCENE_POS_LIST[0][0]),
                                               PrcY: CGFloat(MAIN_SCENE_POS_LIST[0][1]))
        KTF_SCALE().ScaleMyNode(nodeToScale: bgSprite)
        self.addChild(bgSprite)
        bgSprite.zPosition = main_menu_z_pos.main_menu_z_bg.rawValue;
    }
    // ADD TITLE
    func addTitleImage()
    {
        let titleSprite = KTF_Sprite(imageNamed: "title")
        titleSprite.position = KTF_POS().posInPrc(PrcX: CGFloat(MAIN_SCENE_POS_LIST[1][0]),
                                                  PrcY: CGFloat(MAIN_SCENE_POS_LIST[1][1]))
        KTF_SCALE().ScaleMyNode(nodeToScale: titleSprite)
        self.addChild(titleSprite)
        titleSprite.zPosition = main_menu_z_pos.main_menu_z_title.rawValue;
    }
    // ADD map BUTTON
    func addMapButton()
    {
        _mapButton.position = KTF_POS().posInPrc(PrcX: CGFloat(MAIN_SCENE_POS_LIST[2][0]),
                                                   PrcY: CGFloat(MAIN_SCENE_POS_LIST[2][1]))
        KTF_SCALE().ScaleMyNodeRelatively(nodeToScale: _mapButton)
        self.addChild(_mapButton)
        _mapButton.zPosition = main_menu_z_pos.main_menu_z_map_button.rawValue;
        self.ButtonFlashAnimation(sprite: _mapButton)
    }
    
    // ADD PLAY BUTTON
    func addPlayButton()
    {
        _playButton.position = KTF_POS().posInPrc(PrcX: CGFloat(MAIN_SCENE_POS_LIST[3][0]),
                                                   PrcY: CGFloat(MAIN_SCENE_POS_LIST[3][1]))
        KTF_SCALE().ScaleMyNodeRelatively(nodeToScale: _playButton)
        self.addChild(_playButton)
    _playButton.zPosition = main_menu_z_pos.main_menu_z_play_button.rawValue;

        let playImage = KTF_Sprite(imageNamed: "play_button")
        playImage.position = KTF_POS().posInNodePrc(node: _playButton, isParentFullScreen: false, PrcX: 50, PrcY: 50)
        playImage.zPosition = main_menu_z_pos.main_menu_z_play_button.rawValue + 1;
        _playButton.addChild(playImage)
        self.ButtonFlashAnimation(sprite: _playButton)
 }

    
    //////>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> CREATE SCENE ELEMENTS

  
    
    //////<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< INITIAL ANIMATION
    func ButtonFlashAnimation(sprite:KTF_Sprite)
    {
        let initialScaleX = sprite.xScale;
        let initialScaleY = sprite.yScale;
        
        sprite.run(SKAction.repeatForever(SKAction.sequence(
            [SKAction.scaleX(to: initialScaleX*1.1, y: initialScaleY*1.1, duration: TimeInterval(0.5)),
             SKAction.scaleX(to: initialScaleX, y: initialScaleY, duration: TimeInterval(0.5))
            ])))
    }
    
    //////>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> INITIAL ANIMATION

    
/////<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< HANDLE TOUCHES
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
        //IF POP UP WINDOW SHOWN IT TAKE CONTROL ON TOUCH BEGAN
        if _popUpWindow != nil
         {
            if _popUpWindow.isEnabled
            {
                for touch in touches {
                    
                    let point = touch.location(in: self)
                    if _popUpWindow.contains(point)
                    {
                _popUpWindow.touchesBegan(touches, with: event)
                    }
                    else
                    {
                        _popUpWindow.isEnabled = false
                        _popUpWindow.removeFromParent()
                        _popUpWindow = nil
                    }
                return
            }
        }
        }
     
        let ufoMenuSelection = _ufoMenu.touchesStarted(touches, with: event)

        if ufoMenuSelection >= 3 && ufoMenuSelection < 6
        {
            self.setPopUpWindow(type: ufoMenuSelection)
        }
        
        for touch in touches {
            
            let location = touch.location(in: self)
            
            //TODO: MOVE THIS TOUCH TO SCROLL CLASS
       //     let ufoInMenu = _ufoMenu._menuItemsArray[_ufoMenu._currentItemIndex]
    /*
            if _ufoMenu._leftNavButton.contains(location)
            {
                _ufoMenu.scrollItemsLeft()
                return
            }
            else if _ufoMenu._rightNavButton.contains(location)
            {
                _ufoMenu.scrollItemsRight()
                return
            }else if ufoInMenu.contains(location)
            {
                if ufoInMenu.isEnabled
                {
                    self.playButtonPressed()
                }
            }
  */
            if _playButton.contains(location)
            {
                self.playButtonPressed()
            }
            else if _mapButton.contains(location)
            {
                self.mapButtonPressed()
            }
            else if !_ufoMenu.contains(location)
            {
                self.particlesAction(pos:location)
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        if _popUpWindow != nil
        {
            if !_popUpWindow.isEnabled
            {
                _popUpWindow = nil
            }
        }
    }
    
    func mapButtonPressed() {
        
        KTF_Sound_Engine().playSoundWithVolume(fileName: "alien_scared", volume: 0.5)
        _playButton.removeAllChildren()

        if let view = self.view {
            self.removeAllActions()
            KTF_FILES_COUNT().removeAllChildrenForScene(scene: self)
            let transition:SKTransition = SKTransition.doorway(withDuration: 1.5)
            let scene:SKScene = MapScene(size: self.size)
            scene.scaleMode = .aspectFill
            view.presentScene(scene, transition: transition)
            view.ignoresSiblingOrder = false
           self.cleanScene()
        }
    }
    
    // REPLACE SCENE TO GAME SCENE
    @objc func playButtonPressed() {

        let selectedUfoIndex = _ufoMenu._currentItemIndex
      
        KTF_DISK().saveInt(number: selectedUfoIndex!, forKey: SAVED_GAME_UFO)
       _playButton.removeAllChildren()
        KTF_Sound_Engine().playSoundWithVolume(fileName: "alien_scared", volume: 0.5)
        if let view = self.view {
            self.removeAllActions()
            KTF_FILES_COUNT().removeAllChildrenForScene(scene: self)
            let transition:SKTransition = SKTransition.doorsOpenHorizontal(withDuration: 1.0)
            let scene:SKScene = GameScene(size: self.size)
            scene.scaleMode = .aspectFill
            view.presentScene(scene, transition: transition)
            view.ignoresSiblingOrder = false
            self.cleanScene()
       }
        
}
    
    // OPEN MY APPS LIST ON THE APP STORE
    func moreButtonPressed() {
    }
    
    // OPEN THIS APP ON THE APP STORE
    func rateButtonPressed() {
    }
    //////>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> BUTTONS ACTIONS
    func openPopUpForState(index:Int) {
        
        
        
    }
    //SET BUYING METHOD
    //SET POPUPS FOR GAME SCENE
    
    //POP UP OPTIONS:
    // GAME SCENE ---- // WATCH&PAY&TIMER // PAY&TIMER //{ THIS CAN BE IN MAIN MENU EARNED- WATCH*2 // PLAY NEXT // HOME
    func setPopUpWindow(type:Int){
        print("START POPUP ACCORDING TO STATUS")

    ////IF ITEM CAN BE BOUGHT
        let windowSize = POPUP_WINDOW_SIZE.middle_size
        var topText = "GET"
        let topPos = POPUP_ITEMS_POS_INDEX.posUP_MIDDLE
        var centerText = ""
        let middlePos = POPUP_ITEMS_POS_INDEX.posMIDDLE_MIDDLE
        var bottomText = String(priceFactor_ * _ufoMenu._currentItemIndex)
        let bottomPos = POPUP_ITEMS_POS_INDEX.posDOWN_MIDDLE
        var imageName = "ufo_top_base_" + String(_ufoMenu._currentItemIndex)
        var imagePos = POPUP_ITEMS_POS_INDEX.posMIDDLE_MIDDLE
        var imageSel = "buyUfo"
        var FirstButtonImage = "space_coin"
        var FirstButtonPos = POPUP_ITEMS_POS_INDEX.posDOWN_LEFT
        var firstButtonSel = "buyUfo"
        var SecondButtonImage = "space_coin"
        var SecondButtonPos = POPUP_ITEMS_POS_INDEX.posDOWN_RIGHT
        var secondButtonSel = "buyUfo"
        
        switch type {

        case 4://IF ITEM TOO EXPENSIVE
             topText = "COLLECT MORE COINS"
             centerText = ""
             bottomText = String(priceFactor_ * _ufoMenu._currentItemIndex)
             imageName = "ufo_top_base_" + String(_ufoMenu._currentItemIndex)
             imagePos = POPUP_ITEMS_POS_INDEX.posMIDDLE_MIDDLE
             imageSel = ""
             FirstButtonImage = ""
             FirstButtonPos = POPUP_ITEMS_POS_INDEX.posDOWN_LEFT
             firstButtonSel = ""
             SecondButtonImage = ""
             SecondButtonPos = POPUP_ITEMS_POS_INDEX.posDOWN_RIGHT
             secondButtonSel = ""
            break
        case 5://IF NEED TO WAIT FOR LEVEL
             topText = "FINISH LEVEL " + String(_ufoMenu._currentItemIndex)
             centerText = ""
             bottomText = String(priceFactor_ * _ufoMenu._currentItemIndex)
             imageName = "ufo_top_base_" + String(_ufoMenu._currentItemIndex)
             imagePos = POPUP_ITEMS_POS_INDEX.posMIDDLE_MIDDLE
             imageSel = ""
             FirstButtonImage = ""
             FirstButtonPos = POPUP_ITEMS_POS_INDEX.posDOWN_LEFT
             firstButtonSel = ""
             SecondButtonImage = ""
             SecondButtonPos = POPUP_ITEMS_POS_INDEX.posDOWN_RIGHT
             secondButtonSel = ""
            break
            
        default:
            print("error not need to open pop up")
        }

        _popUpWindow = KTF_POPUP().initPopupWindow(size: windowSize,
                                                   forScene: self, closeButtonAction: "",
                                                   top: topText, topPos: topPos,
                                                   middle: centerText, middlePos: middlePos,
                                                   bottom: bottomText, bottomPos: bottomPos,
                                                   imageName: imageName, imagePos: imagePos,
                                                   actionForImagePress: imageSel,
                                                   FirstButtonImage: FirstButtonImage,
                                                   FirstButtonPos: FirstButtonPos,
                                                   actionForFirstButtonPress: firstButtonSel,
                                                   SecondButtonImage: SecondButtonImage,
                                                   SecondButtonPos: SecondButtonPos,
                                                   actionForSecondButtonPress: secondButtonSel,
                                                   timerInSeconds: 0,
                                                   timerPos: SecondButtonPos,
                                                   actionForTimerFinished: "")

        _popUpWindow.isEnabled = true
        _popUpWindow.position = KTF_POS().posInPrc(PrcX: 50, PrcY: 50)
        KTF_SCALE().ScaleMyNode(nodeToScale: _popUpWindow)
        _popUpWindow.zPosition = main_menu_z_pos.main_menu_z_popUpWindow.rawValue
        self.addChild(_popUpWindow)
    }
    
   @objc func buyUfo()
    {
        let ufoToBuy = _ufoMenu._menuItemsArray[_ufoMenu._currentItemIndex]
        // add to bought ufo array
        var mutableGameBoughtList = KTF_DISK().getArray(forKey: SAVED_GAME_BOUGHT_UFO_LIST) as! [Int]
        ufoToBuy.isEnabled = true
        mutableGameBoughtList.append(ufoToBuy.tag)
        KTF_DISK().saveArray(array: mutableGameBoughtList, forKey: SAVED_GAME_BOUGHT_UFO_LIST)
        // remove coins
        let price = 0 - (priceFactor_ * _ufoMenu._currentItemIndex)
        _statusBar.updateCoinsAndSave(addToCoins: price, shouldUpdateStatusBar:true, animated: false)
        _ufoMenu.scrollItemsLeft()
        ufoToBuy.color = SKColor.white
        ufoToBuy.colorBlendFactor = 1.0
        
        _ufoMenu.scrollItemsRight()
        _popUpWindow.removeFromParent()
    }
    
    //PARTICLES
    func particlesAction(pos:CGPoint) {
        if let particles = SKEmitterNode(fileNamed: "FirefliesParticle.sks") {
            particles.position = pos
            particles.particleSpeed = 0.5
            particles.zPosition = 1000
            addChild(particles)
            
            particles.run(SKAction.sequence(
            [SKAction.wait(forDuration: 1.0),
             SKAction.fadeOut(withDuration: 1.0),
             SKAction.run{self.stopParticles(particles: particles)}]))
        }
    }
 
    func stopParticles(particles:SKEmitterNode)
    {
        
        particles.removeAllActions()
        particles.removeFromParent()
    }
    
    func cleanScene()
    {
        _mapButton.removeAllActions()
        _mapButton.removeFromParent()
        
        //TODO:CHECK IF ALL CHILDREN REMOVED IN CLASS
        _playButton.removeAllActions()
        _playButton.removeFromParent()
        
        rateButton.removeAllActions()
        rateButton.removeFromParent()
        
        //TODO:CHECK IF ALL CHILDREN REMOVED IN CLASS
        _ufoMenu.removeAllActions()
        _ufoMenu.removeAllChildren()
        _ufoMenu.removeFromParent()

        //TODO:CHECK IF ALL CHILDREN REMOVED IN CLASS
        if _popUpWindow != nil
        {
            _popUpWindow.removeAllActions()
            _popUpWindow.removeFromParent()
        }
        
      super.removeFromParent()
  }
    
}



