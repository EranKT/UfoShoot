//
//  MapScene.swift
//  TestSwiftGame
//
//  Created by EKT DIGIDESIGN on 1/13/18.
//  Copyright © 2018 EKT DIGIDESIGN. All rights reserved.
//

import Foundation
import SpriteKit

// MISSING PLANETS FOR 5 MORE LEVELS (20)
// ADD ANIMATION FOR WHEN STAGE FINISHED

let MAP_SCENE_POS_LIST = [
    [50.0, 50.0],   //0 BG
    [50.0, 83],   //1 TITLE
    [25.0, 85],    //2 LEFT NAV BUTTON
    [75.0, 85],    //3 RIGHT NAV BUTTON
    [15.0, 93.0],    //4 HOME
    [85.0, 93.0],    //5 PLAY
]

let MAP_SCENE_PLANETS_POS_Y = [
    [15, 24],   // bottom
    [33, 42],   // 2nd
    [51, 60],    //3rd
    [69, 78],    //top
]



class MapScene: SKScene
{
    let fadeTime = 0.5
    
    // planets array
    var _currentPlanetsArray: [KTF_Sprite] = [KTF_Sprite]()
    var _rootLinesArray: [KTF_Sprite] = [KTF_Sprite]()
    var _rootColorLinesArray: [KTF_Sprite] = [KTF_Sprite]()

    var _bgSprite:KTF_Sprite!
    var _homeButton = KTF_Sprite(imageNamed: "pop_up_button")
    var _playButton = KTF_Sprite(imageNamed: "pop_up_button")

    // nav arrows
   let _rightNavButton = KTF_Sprite(imageNamed: "menu_right_button")
    let _leftNavButton = KTF_Sprite(imageNamed: "menu_left_button")
    // title label
    var _titleLabel: SKLabelNode!
    var _ufoMenuBg: KTF_Sprite!
    var _ufoMenu = KTF_Scroll()
    var _selectedStage = 100
    
    
    // Current screenIndex
    var _currentScreenIndex = 0
    var _planetPrefix = "planet_"
    var _isStageChanging = KTF_DISK().getBool(forKey: SAVED_IS_CHANGING_STAGE)
    
    override func didMove(to view: SKView)
    {
        _currentScreenIndex = gameSelectedLevel_
        if _isStageChanging && _currentScreenIndex > 1{
            _currentScreenIndex -= 1
        }
        _ufoMenuBg = nil
        self.addBgImage()
        self.addHomeButton()
        self.addPlayButton()
        self.addNavButtons()
        self.addTitleLabel()
        self.addPlanets()
        self.addLinesBetweenPlanets()
        self.showGalaxy()
    }
    // INIT SCENE ELEMENTS //
    // create bg
    func addBgImage()
    {
        _bgSprite = KTF_Sprite(imageNamed: "main_bg")
        _bgSprite.position = KTF_POS().posInPrc(PrcX: CGFloat(MAP_SCENE_POS_LIST[0][0]),
                                               PrcY: CGFloat(MAP_SCENE_POS_LIST[0][1]))
        KTF_SCALE().ScaleMyNode(nodeToScale: _bgSprite)
        self.addChild(_bgSprite)
        _bgSprite.zPosition = gameZorder.map_scene_z_bg.rawValue//map_scene_z_pos.z_bg.rawValue;
    }
    
    // ADD HOME BUTTON
    func addHomeButton()
    {
        _homeButton.position = KTF_POS().posInPrc(PrcX: CGFloat(MAP_SCENE_POS_LIST[4][0]),
                                                   PrcY: CGFloat(MAP_SCENE_POS_LIST[4][1]))
        KTF_SCALE().ScaleMyNodeRelatively(nodeToScale: _homeButton)
        self.addChild(_homeButton)
        _homeButton.zPosition = gameZorder.GENERAL_buttons.rawValue//map_scene_z_pos.z_home_button.rawValue;
 
        let homeImage = KTF_Sprite(imageNamed: "home_button")
        homeImage.position = KTF_POS().posInNodePrc(node: _homeButton, isParentFullScreen: false, PrcX: 50, PrcY: 50)
        homeImage.zPosition = gameZorder.GENERAL_buttons_image.rawValue//map_scene_z_pos.z_home_button.rawValue;
        _homeButton.addChild(homeImage)
        self.ButtonFlashAnimation(sprite: _homeButton)   }
    
    // ADD PLAY BUTTON
    func addPlayButton()
    {
        _playButton.position = KTF_POS().posInPrc(PrcX: CGFloat(MAP_SCENE_POS_LIST[5][0]),
                                                  PrcY: CGFloat(MAP_SCENE_POS_LIST[5][1]))
        KTF_SCALE().ScaleMyNodeRelatively(nodeToScale: _playButton)
        self.addChild(_playButton)
        _playButton.zPosition = gameZorder.GENERAL_buttons.rawValue//map_scene_z_pos.z_play_button.rawValue;
 
        let playImage = KTF_Sprite(imageNamed: "play_button")
        playImage.position = KTF_POS().posInNodePrc(node: _playButton, isParentFullScreen: false, PrcX: 50, PrcY: 50)
        playImage.zPosition = gameZorder.GENERAL_buttons_image.rawValue//map_scene_z_pos.z_play_button.rawValue + 1;
        _playButton.addChild(playImage)
        self.ButtonFlashAnimation(sprite: _playButton)   }
 
    func ButtonFlashAnimation(sprite:KTF_Sprite)
    {
        let initialScaleX = sprite.xScale;
        let initialScaleY = sprite.yScale;
        
        sprite.run(SKAction.repeatForever(SKAction.sequence(
            [SKAction.scaleX(to: initialScaleX*1.1, y: initialScaleY*1.1, duration: TimeInterval(0.5)),
             SKAction.scaleX(to: initialScaleX, y: initialScaleY, duration: TimeInterval(0.5))
            ])))
    }

    // add nav arrows
    func addNavButtons() {
        
        _leftNavButton.position = KTF_POS().posInPrc(PrcX: CGFloat(MAP_SCENE_POS_LIST[2][0]),
                                                      PrcY: CGFloat(MAP_SCENE_POS_LIST[2][1]))
        _rightNavButton.position = KTF_POS().posInPrc(PrcX: CGFloat(MAP_SCENE_POS_LIST[3][0]),
                                                      PrcY: CGFloat(MAP_SCENE_POS_LIST[3][1]))
        self.addChild(_leftNavButton)
        self.addChild(_rightNavButton)
        KTF_SCALE().ScaleMyNodeRelatively(nodeToScale: _leftNavButton)
        KTF_SCALE().ScaleMyNodeRelatively(nodeToScale: _rightNavButton)
        
        _leftNavButton.zPosition = gameZorder.GENERAL_buttons.rawValue//map_scene_z_pos.z_nav_buttons.rawValue
        _rightNavButton.zPosition = gameZorder.GENERAL_buttons.rawValue//map_scene_z_pos.z_nav_buttons.rawValue
    }

    // add label
    
    func addTitleLabel()
    {
        let title = "LEVEL " + String(_currentScreenIndex)
        
        //COINS TITLE LABEL
        _titleLabel = SKLabelNode(fontNamed: "Avenir-Black")
        _titleLabel.text = title
        _titleLabel.colorBlendFactor = 1.0
        if _currentScreenIndex > gameLevel_
        {
            _titleLabel.fontColor = UIColor.red
        }
        else
        {
            _titleLabel.fontColor = UIColor.green
        }
        _titleLabel.fontSize = 120
        _titleLabel.position =  KTF_POS().posInPrc(PrcX: CGFloat(MAP_SCENE_POS_LIST[1][0]),
                                                   PrcY: CGFloat(MAP_SCENE_POS_LIST[1][1]))

        _titleLabel.name = "levelTitle"
        KTF_SCALE().ScaleMyNode(nodeToScale: _titleLabel)
        _titleLabel.zPosition = gameZorder.GENERAL_title.rawValue//map_scene_z_pos.z_title.rawValue
        self.addChild(_titleLabel)
    }

    // add planets to screen - create with alpha 0, add to array, fadeIn
    func addPlanets() {
        
        var planet: KTF_Sprite
        let planetNamePrefix = _planetPrefix + String(_currentScreenIndex) + "_"

        for index in 0...stagesPerLevel_-1
        {
            let yMax = UInt32(MAP_SCENE_PLANETS_POS_Y[index][1])
            let yMin = UInt32(MAP_SCENE_PLANETS_POS_Y[index][0])
            let posY = CGFloat((arc4random()%(yMax - yMin)) + yMin)
            let posX = CGFloat((arc4random()%70) + 15)
            let planetName = planetNamePrefix + String(index)

            planet = KTF_Sprite(imageNamed: planetName)
            planet.position = KTF_POS().posInPrc(PrcX: posX, PrcY: posY)
            KTF_SCALE().ScaleMyNodeRelatively(nodeToScale: planet)
            planet.zPosition = gameZorder.map_scene_z_planets.rawValue//map_scene_z_pos.z_planets.rawValue
            planet.tag = index + 1
            _currentPlanetsArray.append(planet)
            self.addChild(planet)
            planet.alpha = 0
 
        //    if (_currentScreenIndex > gameLevel_) || (_currentScreenIndex == gameLevel_ && index >= gameStage_)
        //    {
                self.makePlanetDark(planet: planet)
        //    }
        }
    }
    
    // add lines between planets after planets appear
    func addLinesBetweenPlanets() {
        
 //    let index = 0
        // get 2 planets
        for index in 0..._currentPlanetsArray.count - 2 {
            var colorIndex = 0

        let firstPlanet = _currentPlanetsArray[index]
        let secondPlanet =  _currentPlanetsArray[index + 1]
            let p1 = firstPlanet.position
            let p2 = secondPlanet.position
            // calculate distance between the planets
            let distance = CGFloat(hypotf(Float(p1.x - p2.x)/Float(_bgSprite.yScale), Float(p1.y - p2.y)/Float(_bgSprite.yScale)))
            // calculate angle between the planets
     //   let lineAngle = KTF_CONVERT().degreesToRadians(degrees: self.tryMyWayOfAngle(firstPlanet: p1, secondPlanet: p2))
        let lineAngle = KTF_CONVERT().degreesToRadians(degrees:self.getAngleBetweenPlanets(firstPlanet: p1, secondPlanet: p2))
            // calculate position for black line (OR NOT)
         //   let x = (p2.x - p1.x)/2 + p1.x
         //   let y = abs((p2.y - p1.y)/2) + p1.y
        
            // create black line in the y size of distance
            var texture = SKTexture(imageNamed: "map_root_" + String(colorIndex))
            let lineSize = CGSize(width: texture.size().width, height: distance)
            let blackLine = KTF_Sprite(texture: texture, size: lineSize)
        let linePos = p1//CGPoint(x:p1.x, y:p1.y)//(x: p1.x + blackLine.size.width/4, y: p1.y + blackLine.size.height/4)
               blackLine.position = linePos
            blackLine.anchorPoint = CGPoint(x: 0.5, y: 0.0)
            blackLine.zRotation = lineAngle
            KTF_SCALE().ScaleMyNode(nodeToScale: blackLine)
        blackLine.zPosition = gameZorder.map_scene_z_root_lines.rawValue//map_scene_z_pos.z_root_lines.rawValue
           _rootLinesArray.append(blackLine)
            self.addChild(blackLine)
             blackLine.alpha = blackLine.alpha*0.2
              blackLine.alpha = 0
            //CHECK IF GREEN LINE IS SHOWN BEFORE SECOND PLANET IS LIGHTED
            if (_currentScreenIndex < gameLevel_) || (_currentScreenIndex == gameLevel_ && index < gameStage_ - 1)
            {
                // green line
                colorIndex = 2
            }
            else
            {
                //red line
                colorIndex = 1
            }
            // create red/green line
            texture = SKTexture(imageNamed: "map_root_" + String(colorIndex))
            let colorLine = KTF_Sprite(texture: texture, size: lineSize)
            // neet to have y anchorPoint 0 & to start from pos of first planet
            colorLine.anchorPoint = CGPoint(x: 0.5, y: 0.0)
            colorLine.position = p1//linePos
            colorLine.zRotation = lineAngle
            KTF_SCALE().ScaleMyNode(nodeToScale: colorLine)
        colorLine.zPosition = gameZorder.map_scene_z_root_lines.rawValue//map_scene_z_pos.z_root_lines.rawValue
            _rootColorLinesArray.append(colorLine)
            // Y scale of colored line set to 0
            self.addChild(colorLine)

      //    colorLine.yScale = colorLine.yScale * 0.5
          colorLine.yScale = 0
        }
    }
    
    func showGalaxy()   {
        //fade in all planets & black lines
        for planet in _currentPlanetsArray
        {
            planet.run(SKAction.fadeIn(withDuration: 0.5))
        }
        for blackLine in _rootLinesArray
        {
            blackLine.run(SKAction.fadeIn(withDuration: 0.5))
        }
       self.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                   SKAction.run {
                                    self.animateGalaxy(index: 0)
                                }]))
    }
    
    func animateGalaxy(index:Int) {
         //check if index is bigger than stages per level - if yes return
        let planet = _currentPlanetsArray[index]
        self.lightPlanet(planet: planet)
        
        if index >= stagesPerLevel_ - 1 {
            if _isStageChanging
            {
                _isStageChanging = false
                KTF_DISK().saveBool(isTrue: _isStageChanging, forKey: SAVED_IS_CHANGING_STAGE)
              if _currentScreenIndex == gameSelectedLevel_ - 1 && _currentScreenIndex > 1
              {
                self.replaceLevel(increaseLevel: true)
                }
            }
            return
        }

        let coloredLine = _rootColorLinesArray[index]
        
        coloredLine.run(SKAction.sequence([
            SKAction.scaleY(to: _bgSprite.yScale, duration: 0.8),
            SKAction.run {
                self.animateGalaxy(index: index + 1)
            }]))
    }
    
    //SCENE HANDLE ACTIONS//
    // nav arrows action
    func replaceLevel(increaseLevel:Bool) {
        
        self.clearLevelItems()

        if increaseLevel
        {
        if _currentScreenIndex == maxLevelsInGame_ - 1{return}
            _currentScreenIndex += 1
        }
        else
        {
            if _currentScreenIndex > 1
            {
                _currentScreenIndex -= 1
            }
        }
//fade out title, planets, black & colored lines
        _titleLabel.run(SKAction.fadeOut(withDuration: 0.2))
        
        self.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                    SKAction.run {
                                        self.updateTitle()
                                        self.addPlanets()
                                        self.addLinesBetweenPlanets()
                                        self.showGalaxy()
            }]))
    }

    func updateTitle()
    {
        let title = "LEVEL " + String(_currentScreenIndex)
        
        //COINS TITLE LABEL
        _titleLabel.text = title
        _titleLabel.colorBlendFactor = 1.0
        if _currentScreenIndex > gameLevel_
        {
            _titleLabel.fontColor = UIColor.red
        }
        else
        {
            _titleLabel.fontColor = UIColor.green
        }
  
        _titleLabel.run(SKAction.sequence([SKAction.wait(forDuration: 0.3),
                                           SKAction.fadeIn(withDuration: 0.3)
                                    ]))
        
        
    }

    // TOUCHES HANDLE //

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        //IF POP UP WINDOW SHOWN IT TAKE CONTROL ON TOUCH BEGAN
        if _ufoMenuBg != nil
        {
            _ = _ufoMenu.touchesStarted(touches, with: event)
            return
        }

        for touch in touches {
            let location = touch.location(in: self)
            
            if _homeButton.contains(location)
            {
                self.homeButtonAction()
                return
            }
            if _playButton.contains(location)
            {
                
                self.openUfoSelectionPopUp()
                return
            }
            
            if _isStageChanging{return}
            
            if _leftNavButton.contains(location)
            {
                self.replaceLevel(increaseLevel: false)
                return
            }
            if _rightNavButton.contains(location)
            {
                self.replaceLevel(increaseLevel: true)
                return
           }
            
            for planet in _currentPlanetsArray
            {
                if planet.contains(location)
                {
                    _selectedStage = planet.tag
                    self.openUfoSelectionPopUp()
                    return
                }
            }
        }
    }

func openUfoSelectionPopUp()
{
    let menuPos = KTF_POS().posInPrc(PrcX: 50, PrcY: 50)

    let texture = SKTexture(imageNamed: "pop_up_bg")
    let windowSize = CGSize(width: texture.size().width,
                            height: texture.size().height * 0.5)
    
   _ufoMenuBg = KTF_Sprite(texture: texture, size: windowSize)
    _ufoMenuBg.position = menuPos
    _ufoMenuBg.zPosition = gameZorder.scroll_menu_bg.rawValue//main_menu_z_pos.main_menu_z_ufo_menu.rawValue
   KTF_SCALE().ScaleMyNode(nodeToScale: _ufoMenuBg)
    self.addChild(_ufoMenuBg)
    
    _ufoMenu = _ufoMenu.initScrollMenu(scene: self,
                                       prefix: "ufo_top_base_",
                                       pos: menuPos,
                                       actionForImagePress:#selector(self.playSavedStage))
    _ufoMenu.position = CGPoint(x:0, y:0)
    _ufoMenu.zPosition = gameZorder.scroll_menu.rawValue//main_menu_z_pos.main_menu_z_ufo_menu.rawValue
    self.addChild(_ufoMenu)
    }
    
    @objc func playSavedStage()
    {
        let selectedUfoIndex = _ufoMenu._currentItemIndex
        KTF_DISK().saveInt(number: selectedUfoIndex!, forKey: SAVED_GAME_UFO)

        _ufoMenu.removeAllActions()
        _ufoMenu.removeFromParent()
        _ufoMenuBg.removeFromParent()
        _ufoMenuBg = nil
        
        self.playButtonPressed(planetTag:_selectedStage)
    }
    
    // play button action
     func playButtonPressed(planetTag:Int)
    {
        if planetTag <= _currentPlanetsArray.count
        {
        if _currentScreenIndex > gameLevel_ || _currentScreenIndex == gameLevel_ && planetTag > gameStage_ {return}
        gameSelectedLevel_ = _currentScreenIndex
        gameSelectedStage_ = planetTag
        KTF_DISK().saveInt(number: gameSelectedLevel_, forKey: SAVED_GAME_SELECTED_LEVEL)
        KTF_DISK().saveInt(number: gameSelectedStage_, forKey: SAVED_GAME_SELECTED_STAGE)
        }
        
        self.clearLevelItems()
        _bgSprite.removeFromParent()
        _homeButton.removeAllChildren()
        _homeButton.removeFromParent()
        _playButton.removeAllChildren()
        _playButton.removeFromParent()
        _rightNavButton.removeFromParent()
        _leftNavButton.removeFromParent()
        _titleLabel.removeFromParent()

        KTF_Sound_Engine().playSound(fileName: "ufo_pass")
        
        if let view = self.view {
            let transition:SKTransition = SKTransition.flipHorizontal(withDuration: 1.0)
            let scene:SKScene = GameScene(size: self.size)
            scene.scaleMode = .aspectFill
            view.presentScene(scene, transition: transition)
        }
        
    }
    
    func homeButtonAction() {
        
        self.clearLevelItems()

         _bgSprite.removeFromParent()
        _homeButton.removeAllChildren()
        _homeButton.removeFromParent()
        _playButton.removeAllChildren()
        _playButton.removeFromParent()
        _rightNavButton.removeFromParent()
        _leftNavButton.removeFromParent()
        _titleLabel.removeFromParent()

        KTF_Sound_Engine().playSound(fileName: "ufo_pass")
        
        if let view = self.view {
            let transition:SKTransition = SKTransition.flipHorizontal(withDuration: 1.0)
            let scene:SKScene = MainScene(size: self.size)
            scene.scaleMode = .aspectFill
            view.presentScene(scene, transition: transition)
        }
    }

    // CALCULATIONS //

    func makePlanetDark(planet:KTF_Sprite)
    {
        planet.color = SKColor.init(red: 0, green: 0, blue: 0, alpha: 1.0)
        planet.colorBlendFactor = 0.7
    }
    
    func lightPlanet(planet:KTF_Sprite)
    {
        if (_currentScreenIndex < gameLevel_) || (_currentScreenIndex == gameLevel_ && planet.tag <= gameStage_)
        {
        planet.color = SKColor.init(red: 1, green: 1, blue: 1, alpha: 1.0)
        planet.colorBlendFactor = 1.0
        }
    }
    
    func getAngleBetweenPlanets(firstPlanet:CGPoint, secondPlanet:CGPoint) -> CGFloat
    {
        // get origin point to origin by subtracting end from start
        let originPoint = CGPoint(x:secondPlanet.x - firstPlanet.x, y:secondPlanet.y - firstPlanet.y)
        
        // get bearing in radians
        let bearingRadians = CGFloat(fabs(atan2f(Float(originPoint.y), Float(originPoint.x))))
  //      bearingRadians = bearingRadians * 2
        
        // convert to degrees
        var bearingDegrees = CGFloat(Float(bearingRadians) * Float(180.0 / .pi))
        bearingDegrees = bearingDegrees - 90
     // correct discontinuity
        bearingDegrees = (firstPlanet.x < secondPlanet.x ? bearingDegrees : (360.0 + bearingDegrees))

        return bearingDegrees
  }

    func clearLevelItems()
    {
        self.removeAllActions()
        _titleLabel.removeAllActions()
        
        for planet in _currentPlanetsArray
        {
            planet.removeAllActions()
            planet.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.2),
                                          SKAction.run {
                                            planet.removeFromParent()
                }]))
        }
        for blackLine in _rootLinesArray
        {
            blackLine.removeAllActions()
            blackLine.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.2),
                                             SKAction.run {
                                                blackLine.removeFromParent()
                }]))
        }
        for coloredLine in _rootColorLinesArray
        {
            coloredLine.removeAllActions()
            coloredLine.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.2),
                                               SKAction.run {
                                                coloredLine.removeFromParent()
                }]))
        }
        _currentPlanetsArray.removeAll()
        _rootLinesArray.removeAll()
        _rootColorLinesArray.removeAll()

    }
}
