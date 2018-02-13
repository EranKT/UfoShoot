//
//  GameScene.swift
//  TestSwiftGame
//
//  Created by EKT DIGIDESIGN on 12/26/17.
//  Copyright © 2017 EKT DIGIDESIGN. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import AudioToolbox

/*
enum rush_scene_z_pos: CGFloat
{
    case rush_scene_z_bg = 0
    case rush_scene_z_bullets
    case rush_scene_z_ufo
    case rush_scene_z_enemy
    case rush_scene_z_pause_button
    case rush_scene_z_popUpWindow

}
*/
enum RUSH_SCENE_INDEX: Int
{
    case BG = 0
    case UFO
    case ENEMY
    case PAUSE_BUTTON
    case ROUND_LABEL
   // case ENEMY_SHIP

}
let RUSH_SCENE_POS = [
    [50, 50], //BG
    [50, 30], //UFO
    [50, 120], //ENEMY
    [88, 14],   //PAUSE BUTTON
    [50, 70], //ROUND LABEL
  //  [50, 30], //ENEMY_SHIP

]

class GameScene: SKScene, KTF_Ads_Rewarded_SupportDelegate, KTF_Ads_Inter_SupportDelegate {
    
    var _animatedBG: AnimatedBg!
    let _pauseButton = KTF_Sprite(imageNamed: "pause_button")
    
    var _gameRound = 1
    var _statusBar: KTF_StatusBar!
    var _score = 0
    var _coins = 0
    
    var _popUpWindow: KTF_POPUP!
    
    var _timer: Timer!
    var _countDownToNextObstacle: CGFloat!
    var _countDownToNextBonusBubble: CGFloat!
    var _countDownForBonusActive = -1
    var _bonusType = -1
    var _countDownToNextUfoBullet: Int!
    var _countDownToNextEnemyShipBullet = -1
    var _numberOfEnemyShipBullets = -1
    var _isEnemyShipShoot = false
    var _needToShowInterAds = false
    
    var isGamePaused = true
    var _isStageDone = false
    
    
    var _enemiesSpritesArray: [EnemySprite] = [EnemySprite]()
    var _obstaclesSpritesArray: [ObstacleSprite] = [ObstacleSprite]()
    var _bonusBubblesSpritesArray: [BonusBubbleSprite] = [BonusBubbleSprite]()
    var _ufoBulletsArray: [KTF_Sprite] = [KTF_Sprite]()
    var _enemyBulletsArray: [KTF_Sprite] = [KTF_Sprite]()
    var _enemyShipBulletsArray: [KTF_Sprite] = [KTF_Sprite]()
    var _coinsArray: [KTF_Sprite] = [KTF_Sprite]()
    var _ufoSprite = UFOSpriteTopView().initUFO(ufoIndex: KTF_DISK().getInt(forKey: SAVED_GAME_UFO))
    var _enemyShipSprite: EnemySpaceShip!
    var _ufoNumberOfBullets: Int!
    var _enemyShipNumberOfBullets = 4
    
    var _rewardedAd: KTF_Ads_Rewarded_Support!
    var _interAd: KTF_Ads_Inter_Support!
    let _bgPlayer = KTF_MusicPlayer.sharedInstance()
    
    override func didMove(to view: SKView) {
        
        KTF_Ads_Banner_Support().setAdsPos(atPos: KTF_Ads_Position.KTF_Ads_Position_bottom_middle)
        
        self.initAnimatedBg()
        self.addPauseButton()
       
            _ufoNumberOfBullets = 1
        
        _statusBar = KTF_StatusBar().initStatusBar(scene: self, posIsTop: true)
        _statusBar.populateStatusBar(includeSavedScore:true)
      //changed from stage score to game score

        self.initUfo()
        self.startGame()
    }
    
    override func sceneDidLoad()
    {
    }
    
    /////<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<  INITIAL SETTINGS
    func initAnimatedBg() {
        
        _animatedBG = AnimatedBg(imageNamed:"bg_anim.jpg")
        _animatedBG.position = KTF_POS().posInPrc(PrcX: CGFloat(RUSH_SCENE_POS[RUSH_SCENE_INDEX.BG.rawValue][0]),
                                                  PrcY: CGFloat(RUSH_SCENE_POS[RUSH_SCENE_INDEX.BG.rawValue][1]))
        self.addChild(_animatedBG)
        _animatedBG.zPosition = gameZorder.rush_scene_z_bg.rawValue//rush_scene_z_pos.rush_scene_z_bg.rawValue
        KTF_SCALE().ScaleMyNode(nodeToScale: _animatedBG)
        
        _animatedBG.initScrollElements()
        _animatedBG.setScrollSpeedByPRC(speedPRC: 100)
        _animatedBG.startScrolling()
    }
    
    // ADD LEARN BUTTON
    func addPauseButton()
    {
        _pauseButton.position = KTF_POS().posInPrc(PrcX: CGFloat(RUSH_SCENE_POS[RUSH_SCENE_INDEX.PAUSE_BUTTON.rawValue][0]),
                                                  PrcY: CGFloat(RUSH_SCENE_POS[RUSH_SCENE_INDEX.PAUSE_BUTTON.rawValue][1]))
        self.addChild(_pauseButton)
        KTF_SCALE().ScaleMyNodeRelatively(nodeToScale: _pauseButton)
        _pauseButton.zPosition = gameZorder.GENERAL_buttons.rawValue//rush_scene_z_pos.rush_scene_z_pause_button.rawValue;
    }
    
    func initUfo() {
        
        _ufoSprite.position = KTF_POS().posInPrc(PrcX: CGFloat(RUSH_SCENE_POS[RUSH_SCENE_INDEX.UFO.rawValue][0]),
                                                 PrcY: CGFloat(RUSH_SCENE_POS[RUSH_SCENE_INDEX.UFO.rawValue][1]))
        self.addChild(_ufoSprite)
        KTF_SCALE().ScaleMyNodeRelatively(nodeToScale: _ufoSprite)
        _ufoSprite.zPosition = gameZorder.ufo_base.rawValue//rush_scene_z_pos.rush_scene_z_ufo.rawValue;
        _ufoSprite.isEnabled = false
    }
    /////>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  INITIAL SETTINGS
    
    
    
    
    
    /////<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<  GAME PROCESS
    @objc func startGame()
    {
        if !isGamePaused {return}
        _isStageDone = false

        isGamePaused = false
        if gameSelectedStage_ < stagesPerLevel_
        {
            self.presentRoundLabel()
        }
        else
        {
            self.initRound()
        }
    }
    
    func presentRoundLabel() {
        //COINS LABEL
        let round = _gameRound
        let roundLabel = SKLabelNode(fontNamed: "Avenir-Black")
        roundLabel.text = "ROUND " + String(round) + "/" + String(roundsPerStage_)
        roundLabel.colorBlendFactor = 1.0
        roundLabel.color = UIColor.red
        roundLabel.fontSize = 180
        
        roundLabel.position = KTF_POS().posInPrc(PrcX: CGFloat(RUSH_SCENE_POS[RUSH_SCENE_INDEX.ROUND_LABEL.rawValue][0]),
                                                 PrcY: CGFloat(RUSH_SCENE_POS[RUSH_SCENE_INDEX.ROUND_LABEL.rawValue][1]))
        roundLabel.name = "roundLabel"
        KTF_SCALE().ScaleMyNode(nodeToScale: roundLabel)
        roundLabel.zPosition = gameZorder.round_label.rawValue//statusBarZpos_ + 3
        roundLabel.alpha = 0
        self.addChild(roundLabel)
        
        let roundLabelAppears = SKAction.fadeIn(withDuration: 0.4)
        let roundLabelWait = SKAction.wait(forDuration: 1.5)
        let roundLabelFadeOut = SKAction.fadeOut(withDuration: 0.3)
        let initRoundAction = SKAction.run(self.initRound)
        let roundLabelRemoved = SKAction.run {roundLabel.removeFromParent()}
        let roundLabelSequence = SKAction.sequence([roundLabelAppears,
                                                    roundLabelWait,
                                                    roundLabelFadeOut,
                                                    initRoundAction,
                                                    roundLabelRemoved])
        roundLabel.run(roundLabelSequence)
    }
    
    func initRound()
    {
        print("INIT ROUND")
        _obstaclesSpritesArray = []
        _countDownToNextObstacle = 50 / CGFloat(gameSelectedLevel_)
        
        _bonusBubblesSpritesArray = []
        _countDownToNextBonusBubble = 70 / CGFloat(gameSelectedLevel_)
        
        _countDownToNextUfoBullet = 10
        
        if gameSelectedStage_ < stagesPerLevel_
        {
            var enemiesAmount:Int
            
            switch _gameRound {
            case 1:
                enemiesAmount = ENEMY_AMOUNTS.easy_6.rawValue
                break
            case 2:
                enemiesAmount = ENEMY_AMOUNTS.medium_2_lines_10.rawValue
                break
            case 3:
                enemiesAmount = ENEMY_AMOUNTS.medium_2_lines_14.rawValue
                break
            case 4:
                enemiesAmount = ENEMY_AMOUNTS.big_3_lines_18.rawValue
                break
            case 5:
                enemiesAmount = ENEMY_AMOUNTS.big_4_lines_24.rawValue
                break
            default:
                enemiesAmount = ENEMY_AMOUNTS.big_4_lines_24.rawValue
            }
            
            var canShoot = false
            if gameSelectedLevel_ > 1 {
                canShoot = true
                
            }
            
            
            let enemyType = Int(arc4random()%2)
            
            //<< IF NOT LAST STAGE:
            self.addEnemies(amount: enemiesAmount,
                            type: enemyType,
                            withLife: gameSelectedStage_ + gameSelectedLevel_,
                            canShoot: canShoot)
            _ufoSprite.isEnabled = true
            //>> IF NOT LAST STAGE:
        }
        else
        {
            self.initEnemyShip()
            _countDownToNextEnemyShipBullet = 50
            _isEnemyShipShoot = true
            _numberOfEnemyShipBullets = gameSelectedLevel_ * 3
            _ufoSprite.isEnabled = true
        }
        
        _timer = Timer.scheduledTimer(timeInterval: 1.0/60.0, target: self, selector: #selector(self.tick), userInfo: nil, repeats: true)
        
    }
    
    
    //<< UFO BULLETS
    func addBulletToUFO() {
        
        var realBulletIndexForPos = 0
        
        for index in 0 ... _ufoNumberOfBullets {
            if _ufoNumberOfBullets > 1
            {
                if index == _ufoNumberOfBullets{break}
                realBulletIndexForPos = index + 1
            }
            let bulletPrefix = "bullet_" + String(KTF_DISK().getInt(forKey: SAVED_GAME_UFO)) + "_"
            
            let bulletFilesCount = KTF_FILES_COUNT().countGroupOfFiles(prefix: bulletPrefix,
                                                                       sufix: "png",
                                                                       firstNumber: 0);
            
            let bulletIndex = Int(arc4random()%UInt32(bulletFilesCount))
            
            let fileName = bulletPrefix + String(bulletIndex)+".png"
            
            let bullet = KTF_Sprite(imageNamed:fileName)
            self.addChild(bullet)
            KTF_SCALE().ScaleMyNode(nodeToScale: bullet)
            bullet.zPosition = gameZorder.GENERAL_bullets.rawValue//rush_scene_z_pos.rush_scene_z_bullets.rawValue
            bullet.position = _ufoSprite.getBulletPosPerType(index: realBulletIndexForPos)
            bullet.tag = 0
            _ufoBulletsArray.append(bullet)
            self.ufoShootBullet(bullet: bullet, typeIndex: realBulletIndexForPos)
        }
        
    }
    
    func addRocketToUFO() {
        
        let realBulletIndexForPos = 0
        
        let fileName = "rocket_0"
        
        let rocket = KTF_Sprite(imageNamed:fileName)
        self.addChild(rocket)
        KTF_SCALE().ScaleMyNode(nodeToScale: rocket)
        rocket.zPosition = gameZorder.GENERAL_bullets.rawValue//rush_scene_z_pos.rush_scene_z_bullets.rawValue
        rocket.position = _ufoSprite.getBulletPosPerType(index: realBulletIndexForPos)
        rocket.tag = 1
        _ufoBulletsArray.append(rocket)
        self.ufoShootBullet(bullet: rocket, typeIndex: realBulletIndexForPos)
        
        
    }
    
    
    func ufoShootBullet(bullet:KTF_Sprite, typeIndex:Int) {
        
        var sfxFile = "laser_short"
        if bullet.tag == 1
        {
            sfxFile = "laser_sfx"
        }
        
        KTF_Sound_Engine().playSoundWithVolume(fileName: sfxFile, volume: 0.3)
        let bulletEndPoint = _ufoSprite.getBulletEndPosPerType(index: typeIndex)
        bullet.run(SKAction.sequence(
            [SKAction.move(to: bulletEndPoint, duration: 1.0),
             SKAction.run{ self.removeUfoBullet(bullet: bullet)  }
            ]))
        
    }
    
    
    func removeUfoBullet(bullet:KTF_Sprite) {
        
        let bulletIndex = _ufoBulletsArray.index(of: bullet)
        
        if bulletIndex != nil{
            _ufoBulletsArray.remove(at: bulletIndex!)
        }
        bullet.removeAllActions()
        bullet.removeFromParent()
    }
    
    //>> UFO BULLETS
    
    //<< ENEMIES
    
    func addEnemies(amount:Int, type:Int, withLife:Int, canShoot:Bool) {
        
        var enemy:EnemySprite
        
        for i in 0...amount - 1 {
            
            enemy = EnemySprite(imageNamed:EnemySprite().getFileName(kindIndex: type))
            self.addChild(enemy)
            enemy.position = KTF_POS().posInPrc(PrcX: CGFloat(RUSH_SCENE_POS[RUSH_SCENE_INDEX.ENEMY.rawValue][0]),
                                                PrcY: CGFloat(RUSH_SCENE_POS[RUSH_SCENE_INDEX.ENEMY.rawValue][1]))
            KTF_SCALE().ScaleMyNodeRelatively(nodeToScale: enemy)
            enemy.zPosition = gameZorder.enemy.rawValue//rush_scene_z_pos.rush_scene_z_enemy.rawValue
            _enemiesSpritesArray.append(enemy)

            enemy.animateEnemyToPlace(itemTag: i, amountIndex: amount, withLife: withLife, canShoot: canShoot)
        }
    }
    
    //<< ENEMIES BULLETS
    func addBulletToEnemy(enemy:EnemySprite) {
        
        let bulletFilesCount = KTF_FILES_COUNT().countGroupOfFiles(prefix: "enemy_bullet_",
                                                                   sufix: "png",
                                                                   firstNumber: 0);
        
        let bulletIndex = Int(arc4random()%UInt32(bulletFilesCount))
        
        let fileName = "enemy_bullet_" + String(bulletIndex)+".png"
        
        let bullet = KTF_Sprite(imageNamed:fileName)
        self.addChild(bullet)
        KTF_SCALE().ScaleMyNode(nodeToScale: bullet)
        bullet.zPosition = gameZorder.GENERAL_bullets.rawValue//rush_scene_z_pos.rush_scene_z_bullets.rawValue
        bullet.position = enemy.position
        bullet.tag = 0
        _enemyBulletsArray.append(bullet)
        self.enemyShootBullet(bullet: bullet)
    }
    
    func enemyShootBullet(bullet:KTF_Sprite) {
        
        KTF_Sound_Engine().playSound(fileName: "laser_sfx")
        
        bullet.run(SKAction.sequence(
            [SKAction.move(to: CGPoint(x:bullet.position.x, y:0), duration: 2.0),
             SKAction.run{ self.removeEnemyBullet(bullet: bullet)  }
            ]))
        
    }
    
    func removeEnemyBullet(bullet:KTF_Sprite) {
        
        let bulletIndex = _enemyBulletsArray.index(of: bullet)
        _enemyBulletsArray.remove(at: bulletIndex!)
        bullet.removeAllActions()
        bullet.removeFromParent()
    }
    
    //>> ENEMIES BULLETS
    
    /////<< ENEMY SPACE SHIP
    func initEnemyShip() {
        
        if _enemyShipSprite != nil {return}
        
        _enemyShipSprite = EnemySpaceShip().initEnemyShip(enemyShipIndex: gameSelectedLevel_)
        
        _enemyShipSprite.position = KTF_POS().posInPrc(PrcX: CGFloat(RUSH_SCENE_POS[RUSH_SCENE_INDEX.ENEMY.rawValue][0]),
                                                       PrcY: CGFloat(RUSH_SCENE_POS[RUSH_SCENE_INDEX.ENEMY.rawValue][1]))
        self.addChild(_enemyShipSprite)
        KTF_SCALE().ScaleMyNodeRelatively(nodeToScale: _enemyShipSprite)
        _enemyShipSprite.xScale *= 2
        _enemyShipSprite.yScale *= 2
        _enemyShipSprite.zPosition = gameZorder.enemy_ship.rawValue//rush_scene_z_pos.rush_scene_z_enemy.rawValue;
        _enemyShipSprite.isEnabled = false
    }
    /////>> ENEMY SPACE SHIP
    
    //<< ENEMY SPACE SHIP BULLETS
    func addBulletToEnemyShip() {
        
        var realBulletIndexForPos = 0
        
        for index in 0 ... _enemyShipNumberOfBullets {
            if _enemyShipNumberOfBullets > 0
            {
                if index == _enemyShipNumberOfBullets{break}
                realBulletIndexForPos = index + 1
            }
            let bulletPrefix = "bullet_" + String(gameSelectedLevel_) + "_"
            
            let bulletFilesCount = KTF_FILES_COUNT().countGroupOfFiles(prefix: bulletPrefix,
                                                                       sufix: "png",
                                                                       firstNumber: 0);
            
            let bulletIndex = Int(arc4random()%UInt32(bulletFilesCount))
            
            let fileName = bulletPrefix + String(bulletIndex)+".png"
            
            let bullet = KTF_Sprite(imageNamed:fileName)
            self.addChild(bullet)
            KTF_SCALE().ScaleMyNode(nodeToScale: bullet)
            bullet.zPosition = gameZorder.GENERAL_bullets.rawValue//rush_scene_z_pos.rush_scene_z_bullets.rawValue
            bullet.position = _enemyShipSprite.getBulletPosPerType(index: realBulletIndexForPos)
            bullet.tag = 0
            _enemyShipBulletsArray.append(bullet)
            self.enemyShipShootBullet(bullet: bullet, typeIndex: realBulletIndexForPos)
        }
        
    }
    
    func enemyShipShootBullet(bullet:KTF_Sprite, typeIndex:Int) {
        
        KTF_Sound_Engine().playSoundWithVolume(fileName: "laser_short", volume: 0.3)
        let bulletEndPoint = _enemyShipSprite.getBulletEndPosPerType(index: typeIndex)
        bullet.run(SKAction.sequence(
            [SKAction.move(to: bulletEndPoint,
                duration: 1.0),
             SKAction.run{ self.removeEnemyShipBullet(bullet: bullet)  }
            ]))
        
    }
    
    func removeEnemyShipBullet(bullet:KTF_Sprite) {
        
        let bulletIndex = _enemyShipBulletsArray.index(of: bullet)
        
        if bulletIndex != nil{
            _enemyShipBulletsArray.remove(at: bulletIndex!)
        }
        bullet.removeAllActions()
        bullet.removeFromParent()
    }
    
    //>> ENEMY SPACE SHIP BULLETS
    
    //>> ENEMIES
    
    //<<  OBSTACLES
    
    func addObstacle() {
        let obstacleSprite = ObstacleSprite(imageNamed:ObstacleSprite().getFileName())
        self.addChild(obstacleSprite)
        obstacleSprite.initObstacle()
        KTF_SCALE().ScaleMyNode(nodeToScale: obstacleSprite)
        obstacleSprite.zPosition = gameZorder.obstacles.rawValue//rush_scene_z_pos.rush_scene_z_bg.rawValue
        _obstaclesSpritesArray.append(obstacleSprite)
    }
    //>> OBSTACLES
    
    //<<  BONUS BUBBLE
    
    func addBonusBubble() {
        let bonusBubbleFileName = BonusBubbleSprite().getFileName()
        let bonusSprite = BonusBubbleSprite(imageNamed: bonusBubbleFileName)
        self.addChild(bonusSprite)
        bonusSprite.zPosition = gameZorder.bonus_image.rawValue
        bonusSprite.name = bonusBubbleFileName
        bonusSprite.initBonusBubble()
        KTF_SCALE().ScaleMyNodeRelatively(nodeToScale: bonusSprite)
        bonusSprite.xScale = bonusSprite.xScale / 4
        bonusSprite.yScale = bonusSprite.yScale / 4
        bonusSprite.zPosition = gameZorder.bonus_bubble.rawValue//rush_scene_z_pos.rush_scene_z_bg.rawValue
        _bonusBubblesSpritesArray.append(bonusSprite)
    }
    //>> BONUS BUBBLE
    /////>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  GAME PROCESS
    
    
    
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
                    return
                }
            }
        }
        else
        {
        
        for touch in touches {
            let location = touch.location(in: self)
                 if _pauseButton.contains(location)
               {
                 self.pauseGame()
                 }
                 else
                 {
                _ufoSprite.position = location
            }
            
        }
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)

            if (_ufoSprite.contains(location) && _popUpWindow == nil)
            {
                _ufoSprite.position = location
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
      //  for touch in touches {
            
       //     let location = touch.location(in: self)
            
            if _popUpWindow != nil
            {
                if !_popUpWindow.isEnabled
                {
                    _popUpWindow = nil
                }
            }
        //}
    }
    /////>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> HANDLE TOUCHES
    
    
    
    @objc func tick()
    {
        // continue to check collecting coins after enemies finished
        self.checkIfUfoCollectedCoin()
        
        if isGamePaused {return}
        
        self.checkIfUfoWasHit()
        
        self.HandleEnemyActions()
        self.checkIfObstacleWasShoot()
        self.checkIfBonusBubbleWasShoot()
        //NEXT OBSTACLE
        if _countDownToNextObstacle <= 0 {
            _countDownToNextObstacle = 5 * 60
            self.addObstacle()
        } else {
            _countDownToNextObstacle = _countDownToNextObstacle - 1
        }
        
        //NEXT BONUS BUBBLE
        if _countDownToNextBonusBubble <= 0 {
            _countDownToNextBonusBubble = 5 * 60
            self.addBonusBubble()
        } else {
            _countDownToNextBonusBubble = _countDownToNextBonusBubble - 1
        }
        
        //BONUS TIMER
        if _countDownForBonusActive > 0
        {
            _countDownForBonusActive = _countDownForBonusActive - 1
        }
        else if _countDownForBonusActive == 0
        {
            self.bonusEnded()
        }
        
        //NEXT UFO BULLET
        if _countDownToNextUfoBullet == 0
        {
            if _bonusType != bonus_types.rocket.rawValue
            {
                _countDownToNextUfoBullet = 10
                self.addBulletToUFO()
            }
            else
            {
                _countDownToNextUfoBullet = 25
                self.addRocketToUFO()
            }
        }
        else
        { _countDownToNextUfoBullet = _countDownToNextUfoBullet - 1}
        
        //NEXT SPACE SHIP BULLET
        if _numberOfEnemyShipBullets == 0
        {
            if _isEnemyShipShoot
            {
                _isEnemyShipShoot = false
                _numberOfEnemyShipBullets = (maxLevelsInGame_ - gameSelectedLevel_) * 3
            }
            else
            {
                _isEnemyShipShoot = true
                _numberOfEnemyShipBullets = gameSelectedLevel_ * 2
            }
        }
        else
        {
            _numberOfEnemyShipBullets -= 1
        }
        
        if _countDownToNextEnemyShipBullet == 0 && _isEnemyShipShoot
        {
            _countDownToNextEnemyShipBullet = 1
            self.addBulletToEnemyShip()
        }
        else if _isEnemyShipShoot
        {
            _countDownToNextEnemyShipBullet -= 1
        }
    }
    
    func HandleEnemyActions() {
        
        if gameSelectedStage_ < stagesPerLevel_
        {
            for enemy in _enemiesSpritesArray {
                
                if _enemiesSpritesArray.count <= 0 {return}
                if enemy.isActive_ == false {return}
                
                //<< CHECK IF ENEMY TIME TO SHOOT
                if enemy.canShoot_
                {
                    if enemy.countDownToNextEnemyShoot_ <= 0
                    {
                        self.addBulletToEnemy(enemy: enemy)
                        let shootTimeFactor = UInt32(60*(maxLevelsInGame_ - gameSelectedLevel_) + 60*3)
                        enemy.countDownToNextEnemyShoot_ = Int(arc4random()%shootTimeFactor)
                    }
                    else
                    {
                        enemy.countDownToNextEnemyShoot_ = enemy.countDownToNextEnemyShoot_ - 1
                    }
                }
                //>> CHECK IF ENEMY TIME TO SHOOT
                if _bonusType == bonus_types.rocket.rawValue
                {
                    //<< CHECK IF ROCKET HIT ENEMY
                    for rocket in _ufoBulletsArray {
                        if enemy.frame.contains(rocket.position) {
                            
                            _score += (2 * KTF_DISK().getInt(forKey: SAVED_GAME_UFO))
                            _statusBar.updateStageScore(score: _score)
                            
                            if enemy.life_ > 0
                            {
                                enemy.life_ = enemy.life_ - (2 * (KTF_DISK().getInt(forKey: SAVED_GAME_UFO)-1))
                            }
                            else
                            {
                                self.particlesAction(fileName: "blow_particles.sks", pos: enemy.position, duration: 0.5)
                                let enemyIndex = _enemiesSpritesArray.index(of: enemy)
                                if !enemy.isActive_{return}
                                _enemiesSpritesArray.remove(at: enemyIndex!)
                                enemy.isActive_ = false
                                
                                enemy.removeAllActions()
                                enemy.removeFromParent()
                            }
                            if _enemiesSpritesArray.isEmpty
                            {
                                self.enemiesFinished()
                            }
                        }
                    }
                    //>> CHECK IF ROCKET HIT ENEMY
                }
                else
                {
                    //<< CHECK IF BULLET HIT ENEMY
                    for bullet in _ufoBulletsArray {
                        if enemy.frame.contains(bullet.position) {
                            
                            let bulletIndex = _ufoBulletsArray.index(of: bullet)
                            _ufoBulletsArray.remove(at: bulletIndex!)
                            bullet.removeAllActions()
                            bullet.removeFromParent()
                            _score += KTF_DISK().getInt(forKey: SAVED_GAME_UFO)
                            _statusBar.updateStageScore(score: _score)
                            
                            if enemy.life_ > 0
                            {
                                enemy.life_ = enemy.life_ - KTF_DISK().getInt(forKey: SAVED_GAME_UFO) - 1
                            }
                            else
                            {
                                self.particlesAction(fileName: "blow_particles.sks", pos: enemy.position, duration: 0.5)
                                let enemyIndex = _enemiesSpritesArray.index(of: enemy)
                                if !enemy.isActive_{return}
                                _enemiesSpritesArray.remove(at: enemyIndex!)
                                enemy.isActive_ = false
                                
                                enemy.removeAllActions()
                                enemy.removeFromParent()
                            }
                            if _enemiesSpritesArray.isEmpty
                            {
                                self.enemiesFinished()
                            }
                        }
                    }
                    //>> CHECK IF BULLET HIT ENEMY
                }
                
            }
        }
        else if _enemyShipSprite != nil
        {
            if _enemyShipSprite.isEnabled{
                
                //ENEMY SHIP ACTIONS
                for bullet in _ufoBulletsArray {
                    
                    if _enemyShipSprite == nil{break}
                    
                    if _enemyShipSprite.frame.contains(bullet.position) {
                        
                        let bulletIndex = _ufoBulletsArray.index(of: bullet)
                        _ufoBulletsArray.remove(at: bulletIndex!)
                        bullet.removeAllActions()
                        bullet.removeFromParent()
                        
                        var hitValue = KTF_DISK().getInt(forKey: SAVED_GAME_UFO)
                        if _bonusType == bonus_types.rocket.rawValue
                        {
                        hitValue = KTF_DISK().getInt(forKey: SAVED_GAME_UFO) * 3
                        }
                        
                        if _enemyShipSprite.life_ > 0
                        {
                            for _ in 0 ... hitValue
                            {
                               _enemyShipSprite.enemyShipWasHit()
                                _score += KTF_DISK().getInt(forKey: SAVED_GAME_UFO)
                                _statusBar.updateStageScore(score: _score)
                            }
                        }
                        else
                        {
                            self.particlesAction(fileName: "blow_particles.sks", pos: _enemyShipSprite.position, duration: 3.5)
                            _enemyShipSprite.isEnabled = false
                            _countDownToNextEnemyShipBullet = -1
                            _enemyShipSprite.removeAllActions()
                            _enemyShipSprite.removeFromParent()
                            _enemyShipSprite = nil
                            self.enemiesFinished()
                        }
                    }
                }
            }
            
        }
        
    }
    
    func enemiesFinished() {
        
        // prepare for next round
        isGamePaused = true
        
        for bonusBubble in _bonusBubblesSpritesArray {
            // move bonus bubble to y=0 will clear bubble.
            bonusBubble.position = CGPoint(x: bonusBubble.position.x, y: 0)
        }
        
        for obstacle in _obstaclesSpritesArray
        {
            _score += _obstaclesSpritesArray.count * 5
            _statusBar.updateStageScore(score: _score)
            
            if _obstaclesSpritesArray.count <= 0
            {
                break
            }
            self.obstacleBlow(obstacle: obstacle)
        }
        
    }
    
    func checkIfUfoWasHit() {
        
        if !_ufoSprite.isEnabled
        {
            return
        }
        
        
        //SET HIT RECT OF UFO
        let ufoRect = CGRect(x: _ufoSprite.position.x - _ufoSprite.size.width*0.3,
                             y: _ufoSprite.position.y - _ufoSprite.size.height*0.3,
                             width: _ufoSprite.size.width*0.6,
                             height: _ufoSprite.size.height*0.6)
        
        
        //<< CHECK IF BONUS BUBBLE HIT UFO
        for bonusBubble in _bonusBubblesSpritesArray {
            
            if bonusBubble.frame.intersects(ufoRect) || bonusBubble.tag == -1 {
             
                if bonusBubble.frame.intersects(ufoRect)
                {
                    if _bonusType > -1
                    {       //clear previous bonus
                        self.bonusEnded()
                    }
                    _bonusType = bonusBubble._bonusType
     
                    let bonusIndex = _bonusBubblesSpritesArray.index(of: bonusBubble)
                    bonusBubble.position = CGPoint(x: bonusBubble.position.x, y: 0)
                    _bonusBubblesSpritesArray.remove(at: bonusIndex!)
                    
                    self.ufoGotBonus()
                    break
                }
            }
        }
        //>> CHECK IF BONUS BUBBLE HIT UFO
        
        if _bonusType == bonus_types.shield.rawValue{return}
        
        //<< CHECK IF ENEMY BULLET HIT UFO
        for bullet in _enemyBulletsArray {
            if ufoRect.contains(bullet.position) {
                
                let bulletIndex = _enemyBulletsArray.index(of: bullet)
                _enemyBulletsArray.remove(at: bulletIndex!)
                bullet.removeAllActions()
                bullet.removeFromParent()
                
                self.ufoBlow()
                return
            }
        }
        
        //>> CHECK IF ENEMY BULLET HIT UFO
        
        //<< CHECK IF ENEMY SHIP BULLET HIT UFO
        for bullet in _enemyShipBulletsArray {
            if ufoRect.contains(bullet.position) {
                
                let bulletIndex = _enemyShipBulletsArray.index(of: bullet)
                _enemyShipBulletsArray.remove(at: bulletIndex!)
                bullet.removeAllActions()
                bullet.removeFromParent()
                
                self.ufoBlow()
                return
            }
        }
        //>> CHECK IF ENEMY SHIP BULLET HIT UFO
        
        //<< CHECK IF OBSTACLE HIT UFO
        for obstacle in _obstaclesSpritesArray {
            
            //  if _obstaclesSpritesArray.count <= 0 {break}
            
            if obstacle.frame.intersects(ufoRect) || obstacle.tag == -1 {
                let obstacleIndex = _obstaclesSpritesArray.index(of: obstacle)
                _obstaclesSpritesArray.remove(at: obstacleIndex!)
                
                obstacle.stopScrolling()
                obstacle.removeAllActions()
                obstacle.removeFromParent()
                if obstacle.frame.intersects(ufoRect)
                {
                    self.ufoBlow()
                    break
                }
            }
        }
        //>> CHECK IF OBSTACLE HIT UFO
        
        //<< CHECK IF UFO BUMP ENEMIES
        for enemy in _enemiesSpritesArray {
            
            //   if _enemiesSpritesArray.count <= 0 {break}
            
            if _ufoSprite.frame.contains(enemy.position) {
                
                let enemyIndex = _enemiesSpritesArray.index(of: enemy)
                _enemiesSpritesArray.remove(at: enemyIndex!)
                enemy.isActive_ = false
                enemy.removeAllActions()
                enemy.removeFromParent()
                self.ufoBlow()
                break
            }
        }
        //>> CHECK IF UFO BUMP ENEMIES
        
        //<< CHECK IF UFO BUMP ENEMY SPACE SHIP
        if _enemyShipSprite != nil
        {
            if _enemyShipSprite.frame.intersects(ufoRect) && _enemyShipSprite.isEnabled
            {
                self.ufoBlow()
            }
        }
        //>> CHECK IF UFO BUMP ENEMY SPACE SHIP
    }
    
    
    func ufoBlow() {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        self.particlesAction(fileName: "blow_particles.sks", pos: _ufoSprite.position, duration: 1.5)
        //play blow sfx
        
        // remove ufo from screen
        // _ufoSprite.isPaused = true
        _ufoSprite.isEnabled = false
        _ufoSprite.run(SKAction.fadeOut(withDuration: 0.5))
        _countDownToNextUfoBullet = -1
        // animate ufo show back in screen
        self.stopTick()
        
        var openPopup: SKAction
        
        if _ufoSprite._life == 1
        {
            //open watch
            openPopup = SKAction.run {self.setPopUpWindow(type: 0)}
        }
        else
        {
            if gameCoins_ >= 2000
            {
                // pay to continue game
                openPopup = SKAction.run {self.setPopUpWindow(type: 1)}
            }
            else
            {
                // go to pause screen with inter ads
                _needToShowInterAds = true
                //TODO: not calling go pause method when no inter ads to show
                openPopup = SKAction.run {
                    self._interAd = KTF_Ads_Inter_Support().presentInterAds()
                    self._interAd.delegate = self
                    self.pauseButtonAction()
                }
            }
        }
        let actionWithDelay = SKAction.sequence([SKAction.wait(forDuration: 1.0),
                                                 openPopup])
        _ufoSprite.run(actionWithDelay)
    }
    
    func reloadUfoToScreen() {
        self.particlesAction(fileName: "MagicParticle.sks", pos: _ufoSprite.position, duration: 0.5)
        //   _ufoSprite.isPaused = false
        //  _ufoSprite.run(SKAction.fadeIn(withDuration: 0.5))
        _ufoSprite.run(SKAction.sequence([
            SKAction.fadeIn(withDuration: 1.0),
            SKAction.wait(forDuration: 2.0),
            SKAction.run(self.activateUfo)
            ]))
        _countDownToNextUfoBullet = 10
    }
    
    func activateUfo()
    {
        _ufoSprite.isEnabled = true
    }
    
    func checkIfObstacleWasShoot() {
        //run same check for bullets like for enemies
        for obstacle in _obstaclesSpritesArray {
            
            if _obstaclesSpritesArray.count <= 0 {return}
            
            //<< CHECK IF BULLET HIT OBSTACLE
            for bullet in _ufoBulletsArray {
                if obstacle.frame.contains(bullet.position) {
                    
                    let bulletIndex = _ufoBulletsArray.index(of: bullet)
                    _ufoBulletsArray.remove(at: bulletIndex!)
                    bullet.removeAllActions()
                    bullet.removeFromParent()
                    
                    _score += KTF_DISK().getInt(forKey: SAVED_GAME_UFO)
                    _statusBar.updateStageScore(score: _score)
                    
                    self.obstacleBlow(obstacle: obstacle)
                    break
                }
            }
            //>> CHECK IF BULLET HIT OBSTACLE
        }
    }
    
    func obstacleBlow(obstacle:ObstacleSprite) {
        
        let obstacleIndex = _obstaclesSpritesArray.index(of: obstacle)
        
        if _obstaclesSpritesArray.count <= 0 {return}
        
        _obstaclesSpritesArray.remove(at: obstacleIndex!)
        
        self.particlesAction(fileName: "blow_particles.sks", pos: obstacle.position, duration: 0.5)
        self.coinAction(pos:obstacle.position)
        
        obstacle.removeAllActions()
        obstacle.removeFromParent()
        
        if _enemiesSpritesArray.isEmpty
        {
            self.checkIfUfoCollectedCoin()
        }
    }
    
    func checkIfBonusBubbleWasShoot() {
     
        for bonus in _bonusBubblesSpritesArray {
            
            if _bonusBubblesSpritesArray.count <= 0 {return}
            if let bubbleSprite = bonus.childNode(withName: BUBBLE_FILES_PREFIX)
            {
            //<< CHECK IF BULLET HIT BONUS BUBBLE
            for bullet in _ufoBulletsArray {
                if bonus.frame.contains(bullet.position) {
                    
                    let bulletIndex = _ufoBulletsArray.index(of: bullet)
                    _ufoBulletsArray.remove(at: bulletIndex!)
                    bullet.removeAllActions()
                    bullet.removeFromParent()
                    
                    _score += KTF_DISK().getInt(forKey: SAVED_GAME_UFO)
                    _statusBar.updateStageScore(score: _score)
                    
                    self.bonusWasShot(bubble: bubbleSprite)
                    break
                }
            }
            //>> CHECK IF BULLET HIT BONUS BUBBLE
            }
            
        }
    }
    
    func bonusWasShot(bubble: SKNode) {

        //TODO: add bubble blow SFX
            bubble.removeFromParent()
    }
    
    func ufoGotBonus() {
        
        switch _bonusType {
        case bonus_types.X2.rawValue:
            
            _ufoNumberOfBullets = 2
            _countDownForBonusActive = BONUS_TIME
            
        case bonus_types.X4.rawValue:
            
            _ufoNumberOfBullets = 4
            _countDownForBonusActive = BONUS_TIME
            
        case bonus_types.blow.rawValue:
            
            for obstacle in _obstaclesSpritesArray
            {
                _score += _obstaclesSpritesArray.count * 5
                _statusBar.updateStageScore(score: _score)
                
                if _obstaclesSpritesArray.count <= 0
                {
                    break
                }
                self.obstacleBlow(obstacle: obstacle)
            }
            
            if _enemiesSpritesArray.count > 0
            {
                for enemy in _enemiesSpritesArray
                {
                    _score += 1
                    _statusBar.updateStageScore(score: _score)
                    
                    if enemy.life_ > 0
                    {
                        enemy.life_ = enemy.life_ - gameSelectedLevel_ - 1
                    }
                    if enemy.life_ <= 0
                    {
                        self.particlesAction(fileName: "blow_particles.sks", pos: enemy.position, duration: 0.5)
                        let enemyIndex = _enemiesSpritesArray.index(of: enemy)
                        if !enemy.isActive_{return}
                        _enemiesSpritesArray.remove(at: enemyIndex!)
                        enemy.isActive_ = false
                        
                        enemy.removeAllActions()
                        enemy.removeFromParent()
                    }
                    if _enemiesSpritesArray.isEmpty
                    {
                        self.enemiesFinished()
                    }
                }
            }
            else if _enemyShipSprite != nil
            {
                for _ in 0...25
                {
                if _enemyShipSprite.isEnabled
                {
                    _score += 1
                    _statusBar.updateStageScore(score: _score)
                    
                    if _enemyShipSprite.life_ > 0
                    {
                        _enemyShipSprite.enemyShipWasHit()
                        print("BOMB +1")
                    }
                    else
                    {
                        self.particlesAction(fileName: "blow_particles.sks", pos: _enemyShipSprite.position, duration: 3.5)
                        _enemyShipSprite.isEnabled = false
                        _countDownToNextEnemyShipBullet = -1
                        _enemyShipSprite.removeAllActions()
                        _enemyShipSprite.removeFromParent()
                        _enemyShipSprite = nil
                        self.enemiesFinished()
                    }
                }
                }
            }
            
        case bonus_types.rocket.rawValue:
            _countDownForBonusActive = BONUS_TIME
        case bonus_types.shield.rawValue:
            
            let ufoShield = KTF_Sprite(imageNamed:BUBBLE_FILES_PREFIX + "_" + String(bonus_types.shield.rawValue))
            ufoShield.position = KTF_POS().posInNodePrc(node: _ufoSprite,
                                                        isParentFullScreen: false,
                                                        PrcX: 50,
                                                        PrcY: 50)//_ufoSprite.position
            ufoShield.zPosition = gameZorder.ufo_shield.rawValue//ufo_z_pos.ufo_shieldZorder.rawValue
            ufoShield.name = BUBBLE_FILES_PREFIX
            _ufoSprite.addChild(ufoShield)
            _countDownForBonusActive = BONUS_TIME

            //add scale "glow effect"
            let scaleX = ufoShield.xScale
            let scaleY = ufoShield.yScale
            let actionScaleUp = SKAction.scaleX(to: scaleX * 1.2, y: scaleY * 1.2, duration: 0.5)
            let actionScaleDown = SKAction.scaleX(to: scaleX, y: scaleY, duration: 0.5)
            let actionSequence = SKAction.sequence([actionScaleUp,actionScaleDown])
            ufoShield.run(SKAction.repeatForever(actionSequence))

        default:
            print("DO NOTHING")
        }
    }
    
    func bonusEnded()
    {
        // clear bonus items
        _countDownForBonusActive = -1
        
        switch _bonusType {
        case bonus_types.X2.rawValue:
            
            _ufoNumberOfBullets = 1
            
        case bonus_types.X4.rawValue:
            
            _ufoNumberOfBullets = 1
            
        case bonus_types.blow.rawValue:
            print("BOMB DO NOTHING")
            
        case bonus_types.rocket.rawValue:
            _countDownToNextUfoBullet = 10
            
        case bonus_types.shield.rawValue:
            let shieldSprite = _ufoSprite.childNode(withName: BUBBLE_FILES_PREFIX)
            shieldSprite?.removeAllActions()
            shieldSprite?.removeFromParent()
            
        default:
            print("DO NOTHING")
        }
        _bonusType = -1
    }
    
    func coinAction(pos:CGPoint){
        
        let numberOfCoins = (arc4random()%40)+5
        
        //   physicsWorld.speed = 0.1
        
        for _ in 0...numberOfCoins {
            
            physicsWorld.gravity = CGVector(dx: 0, dy: -1)
            let coin = KTF_Sprite(imageNamed: "space_coin")
            coin.zPosition = gameZorder.coins.rawValue//1
            coin.position = pos
            coin.physicsBody = SKPhysicsBody(circleOfRadius: coin.size.height / 10.0)
            coin.physicsBody?.isDynamic = true
            coin.physicsBody?.allowsRotation = false
            coin.physicsBody?.affectedByGravity = true
            
            KTF_SCALE().ScaleMyNodeRelatively(nodeToScale: coin)
            
            let xPos = CGFloat(arc4random_uniform(UInt32(self._animatedBG.size.width)))
            let fallTimer = CGFloat((arc4random()%50)+10)
            let delayTime = fallTimer/100
            let actionDelay = SKAction.wait(forDuration: TimeInterval(delayTime))
            let actionCoin = SKAction.move(to:CGPoint(x:xPos,y:0), duration: 2.0)
            
            let actionRemoveCoin = SKAction.run {self.removeCoin(coin: coin)}
            let actionSequence = SKAction.sequence([actionDelay, actionCoin, actionRemoveCoin])
            coin.run(actionSequence)
            self.addChild(coin)
            _coinsArray.append(coin)
        }
    }
    
    func checkIfUfoCollectedCoin()
    {
        //TODO: CHECK IF WORK LIKE SHOULD MOVED FINISH ROUND AFTER COLLECTING ALL COINS
        
        if _enemiesSpritesArray.isEmpty
        {
            if !_coinsArray.isEmpty
            {
                //    self.checkIfUfoCollectedCoin()
            }
            else
            {
                if !isGamePaused {return}
                if _gameRound < roundsPerStage_ && gameSelectedStage_ < stagesPerLevel_
                    
                {//NEXT ROUND
                    _gameRound += 1
                    self.startGame()
                }
                else
                {//NEXT STAGE
                    _gameRound = 1
                    _isStageDone = true
                    _statusBar.updatelevel()
                    self.setPopUpWindow(type: 2)
                }
                self.stopTick()
                return
            }
        }
        for coin in _coinsArray {
            
            if _coinsArray.isEmpty {break}
            
            if coin.frame.intersects(_ufoSprite.frame)
            {
                let coinsEarnd = 1
                _coins += coinsEarnd
               
                _statusBar.updateCoinsAndSave(addToCoins: coinsEarnd, shouldUpdateStatusBar: true, animated: false)
              //changed from stage coins to game coins
               // _statusBar.updateStageCoins(coins: _coins, amountToUpdate: coinsEarnd)
                self.removeCoin(coin: coin)
            }
        }
    }
    
    func removeCoin(coin:KTF_Sprite)
    {
        let coinIndex = _coinsArray.index(of: coin)
        
        if coinIndex != nil{
            _coinsArray.remove(at: coinIndex!)
        }
        coin.removeAllActions()
        coin.removeFromParent()
    }
    
    func pauseGame()  {
        isGamePaused = true
        self.stopTick()
        // real line
        self.setPopUpWindow(type: 50)
        // for tests
        //  self.setPopUpWindow(type: 2)
    }
    
    func stopTick()
    {
        if _timer != nil
        {
            _timer.invalidate()
            _timer = nil
        }
    }
    
    func particlesAction(fileName:String, pos:CGPoint, duration: TimeInterval) {
        if let particles = SKEmitterNode(fileNamed: fileName) {
            particles.position = pos
            // particles.particleLifetime = 1.0
            //  particles.numParticlesToEmit = 200
            // particles.particleBirthRate = 0.1
            //     particles.particleColorRedRange = 1.0
            //     particles.particleColorBlueRange = 1.0
            //   particles.particleColorGreenRange = 1.0
            //    particles.particleSpeed = 0.5
            particles.zPosition = gameZorder.GENERAL_particles.rawValue//1000
            addChild(particles)
            
            particles.run(SKAction.sequence(
                [SKAction.wait(forDuration: duration),
                 SKAction.fadeOut(withDuration: 0.3),
                 SKAction.run{self.stopParticles(particles: particles)}]))
        }
        
    }
    
    func stopParticles(particles:SKEmitterNode)
    {
        particles.removeAllActions()
        particles.removeFromParent()
    }
    
    // GAME SCENE ---- // WATCH&PAY&TIMER // PAY&TIMER //{ THIS CAN BE IN MAIN MENU EARNED- WATCH*2 // PLAY NEXT // pause
    
    func setPopUpWindow(type:Int){
        if _popUpWindow != nil  {return}
        
        ////IF DEAD FIRST TIME
        var windowSize = POPUP_WINDOW_SIZE.middle_size
        var closeButtonSel = "pauseButtonAction"
        var topText = "GET ONE LIFE"
        var topPos = POPUP_ITEMS_POS_INDEX.posUP_MIDDLE
        var centerText = String(2000)
        var middlePos = POPUP_ITEMS_POS_INDEX.posMIDDLE_LEFT
        var bottomText = "WATCH"
        var bottomPos = POPUP_ITEMS_POS_INDEX.posMIDDLE_RIGHT
        var imageName = ""
        var imagePos = POPUP_ITEMS_POS_INDEX.posMIDDLE_MIDDLE
        var imageSel = ""
        var FirstButtonImage = "space_coin"
        var FirstButtonPos = POPUP_ITEMS_POS_INDEX.posDOWN_LEFT
        var firstButtonSel = "handleCoinsFromPopup"// reduce coins and continue game
        var SecondButtonImage = "pop_up_rewarded_button"
        var SecondButtonPos = POPUP_ITEMS_POS_INDEX.posDOWN_RIGHT
        var secondButtonSel = "presentRewardedAd"//watch rewarded and continue
        var timer = 10
        var timerPos = POPUP_ITEMS_POS_INDEX.posDOWN_MIDDLE
        var timerSel = "pauseButtonAction"// move to pause
        
        switch type {
        case 0: // IF DEAD FIRST TIME AND DON'T HAVE MONEY
            print("GAME COINS:",gameCoins_)
            if gameCoins_ < 2000
            {
                // now buy life option
                centerText = ""
                FirstButtonImage = ""
                firstButtonSel = ""
                //watch TITLE
                bottomPos = POPUP_ITEMS_POS_INDEX.posMIDDLE_LEFT
                //watch BUTTON
                SecondButtonPos = POPUP_ITEMS_POS_INDEX.posMIDDLE_RIGHT
                // timer
                timerPos = POPUP_ITEMS_POS_INDEX.posDOWN_MIDDLE
            }
        case 1://IF DEAD SECOND TIME AND HAVE ENOUGH COINS (combine with original popup)
            closeButtonSel = "pauseButtonAction"
            topText = "GET ONE LIFE"
            topPos = POPUP_ITEMS_POS_INDEX.posUP_MIDDLE
            centerText = String(2000)
            middlePos = POPUP_ITEMS_POS_INDEX.posMIDDLE_MIDDLE
            bottomText = ""
            bottomPos = POPUP_ITEMS_POS_INDEX.posMIDDLE_RIGHT
            imageName = ""
            imagePos = POPUP_ITEMS_POS_INDEX.posMIDDLE_MIDDLE
            imageSel = ""
            FirstButtonImage = "space_coin"
            FirstButtonPos = POPUP_ITEMS_POS_INDEX.posDOWN_LEFT
            firstButtonSel = "handleCoinsFromPopup"// reduce coins and continue game
            SecondButtonImage = "space_coin"
            SecondButtonPos = POPUP_ITEMS_POS_INDEX.posDOWN_RIGHT
            secondButtonSel = "handleCoinsFromPopup"// reduce coins and continue game
            timer = 10
            timerPos = POPUP_ITEMS_POS_INDEX.posDOWN_MIDDLE
            timerSel = "pauseButtonAction"// move to pause
            break
        case 2://IF STAGE FINISHED
            closeButtonSel = "pauseButtonAction"
            windowSize = POPUP_WINDOW_SIZE.middle_size
            topText = "STAGE " + String(gameSelectedLevel_) + "-" + String(gameSelectedStage_) + " FINISHD"
            topPos = POPUP_ITEMS_POS_INDEX.posUP_MIDDLE
            centerText = "EARNED: " + String(_coins)
            middlePos = POPUP_ITEMS_POS_INDEX.posMIDDLE_MIDDLE
            bottomText = "X2"
            bottomPos = POPUP_ITEMS_POS_INDEX.posDOWN_MIDDLE
            imageName = ""
            imagePos = POPUP_ITEMS_POS_INDEX.posMIDDLE_RIGHT
            imageSel = ""//
            FirstButtonImage = "pop_up_rewarded_button"
            FirstButtonPos = POPUP_ITEMS_POS_INDEX.posDOWN_RIGHT
            firstButtonSel = "presentRewardedAd"//watch and open new popup
            SecondButtonImage = "map_button"//go to map button
            SecondButtonPos = POPUP_ITEMS_POS_INDEX.posDOWN_LEFT
            secondButtonSel = "mapButtonAction" //go to map
            timer = 0
            timerPos = POPUP_ITEMS_POS_INDEX.posMIDDLE_MIDDLE
            timerSel = ""
            break
        case 3://IF WATCHED REWARDED AT STAGE FINISHED
            closeButtonSel = "pauseButtonAction"
            windowSize = POPUP_WINDOW_SIZE.middle_size
            topText = "STAGE " + String(gameSelectedLevel_) + "-" + String(gameSelectedStage_) + " FINISHD"
            topPos = POPUP_ITEMS_POS_INDEX.posUP_MIDDLE
            centerText = "EARNED: " + String(_coins)
            middlePos = POPUP_ITEMS_POS_INDEX.posMIDDLE_MIDDLE
            bottomText = ""
            bottomPos = POPUP_ITEMS_POS_INDEX.posMIDDLE_RIGHT
            imageName = ""
            imagePos = POPUP_ITEMS_POS_INDEX.posMIDDLE_RIGHT
            imageSel = ""
            FirstButtonImage = "map_button" // go to map button
            FirstButtonPos = POPUP_ITEMS_POS_INDEX.posDOWN_LEFT
            firstButtonSel = "mapButtonAction"//go to map
            SecondButtonImage = "play_button"//play button
            SecondButtonPos = POPUP_ITEMS_POS_INDEX.posDOWN_RIGHT
            secondButtonSel = "startGame" //play next level
            timer = 0
            timerPos = POPUP_ITEMS_POS_INDEX.posMIDDLE_MIDDLE
            timerSel = ""
            break
        default: // pause button pressed
            closeButtonSel = "pauseButtonAction"
            topText = "GAME PAUSED"
            closeButtonSel = "resumeGame"
            topPos = POPUP_ITEMS_POS_INDEX.posUP_MIDDLE
            centerText = "HOME"
            middlePos = POPUP_ITEMS_POS_INDEX.posMIDDLE_LEFT
            bottomText = "PLAY"
            bottomPos = POPUP_ITEMS_POS_INDEX.posMIDDLE_RIGHT
            imageName = ""
            imagePos = POPUP_ITEMS_POS_INDEX.posMIDDLE_MIDDLE
            imageSel = ""
            FirstButtonImage = "home_button"
            FirstButtonPos = POPUP_ITEMS_POS_INDEX.posDOWN_LEFT
            firstButtonSel = "pauseButtonAction"
            SecondButtonImage = "play_button"//resume game button
            SecondButtonPos = POPUP_ITEMS_POS_INDEX.posDOWN_RIGHT
            secondButtonSel = "resumeGame" //resume game
            timer = 0
            timerPos = POPUP_ITEMS_POS_INDEX.posMIDDLE_MIDDLE
            timerSel = ""
        }
        
        _popUpWindow = KTF_POPUP().initPopupWindow(size: windowSize,
                                                   forScene: self, closeButtonAction: closeButtonSel,
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
                                                   timerInSeconds: timer,
                                                   timerPos: timerPos,
                                                   actionForTimerFinished: timerSel)
        
        _popUpWindow.isEnabled = true
        _popUpWindow.position = KTF_POS().posInPrc(PrcX: 50, PrcY: 50)
        KTF_SCALE().ScaleMyNode(nodeToScale: _popUpWindow)
        _popUpWindow.zPosition = gameZorder.popup_window_bg.rawValue//rush_scene_z_pos.rush_scene_z_popUpWindow.rawValue
        
        self.addChild(_popUpWindow)
    }
    
    @objc func handleCoinsFromPopup()
    {
        _statusBar.updateCoinsAndSave(addToCoins: -2000, shouldUpdateStatusBar:true, animated: false)
        isGamePaused = false
        self.reloadUfoToScreen()
        _timer = Timer.scheduledTimer(timeInterval: 1.0/60.0, target: self, selector: #selector(self.tick), userInfo: nil, repeats: true)
    }
    
    @objc func resumeGame()
    {
        if _popUpWindow != nil
        {
            _popUpWindow.removeFromParent()
        }
        _countDownToNextObstacle = 50
        isGamePaused = false
        self.reloadUfoToScreen()
        _timer = Timer.scheduledTimer(timeInterval: 1.0/60.0, target: self, selector: #selector(self.tick), userInfo: nil, repeats: true)
    }
    
    // PAUSE BUTTON PRESSED
    @objc func pauseButtonAction() {
        
        self.clearScene()
        KTF_Sound_Engine().playSound(fileName: "ufo_pass")
        
        if let view = self.view {
            self.removeAllActions()
            let transition:SKTransition = SKTransition.flipHorizontal(withDuration: 1.0)
            let scene:SKScene = MainScene(size: self.size)
            scene.scaleMode = .aspectFill
            view.presentScene(scene, transition: transition)
        }
    }
    
    @objc func mapButtonAction() {
        
        if _isStageDone
        {
            KTF_DISK().saveBool(isTrue: true, forKey: SAVED_IS_CHANGING_STAGE)
        }
        
        self.clearScene()
        KTF_Sound_Engine().playSound(fileName: "ufo_pass")
        
        if let view = self.view {
            self.removeAllActions()
            let transition:SKTransition = SKTransition.flipHorizontal(withDuration: 1.0)
            let scene:SKScene = MapScene(size: self.size)
            scene.scaleMode = .aspectFill
            view.presentScene(scene, transition: transition)
        }
    }
    
    func clearScene()
    {
        self.stopTick()
        _obstaclesSpritesArray.removeAll()
        _bonusBubblesSpritesArray.removeAll()
        _enemiesSpritesArray.removeAll()
        _ufoBulletsArray.removeAll()
        _animatedBG.removeFromParent()
        _ufoSprite.removeFromParent()
        
        if _popUpWindow != nil
        {
            _popUpWindow.removeAllActions()
            _popUpWindow.removeFromParent()
        }
    }
    
    //////////////////////////////////////<< ADS HANDLING ////////////////////////////////////////
    
    @objc func presentRewardedAd()
    {
        _bgPlayer.setMusicVolume(volume: 0.01)
        _popUpWindow.removeFromParent()
        _popUpWindow = nil
        _rewardedAd = KTF_Ads_Rewarded_Support().presentRewardAdFor(scene: self)
        _rewardedAd.delegate = self
    }
    
    
    func rewardedFinishSuccessfuly()
    {
        if _isStageDone
        {
            // open popup window with "you earned coins" & to go to map or play next level
            _ufoSprite._life = 1
            self.setPopUpWindow(type: 3)
        }
        else
        {
            _ufoSprite._life = 0
        }
    }
    
    func rewardedAdClosed()
    {
        _bgPlayer.setMusicVolume(volume: 0.1)
        _rewardedAd.reloadRewardedAd()
        
        if _isStageDone
        {//TODO: fix if coins received if reward was not accepted
            for _ in 0..._coins
            {
                let coinsEarnd = 1
                _coins += coinsEarnd
                _statusBar.updateCoinsAndSave(addToCoins: coinsEarnd, shouldUpdateStatusBar: true, animated: false)
                //changed from stage coins to game coins
                // _statusBar.updateStageCoins(coins: _coins, amountToUpdate: coinsEarnd)
                if _popUpWindow._middleLabel != nil
                {
                    _popUpWindow._middleLabel.text = "EARNED: " + String(_coins)
                }
            }
        _coins = 0
        }
        else if _ufoSprite._life == 0
        {
            self.resumeGame()
        }
        else
        {
            self.pauseButtonAction()
        }
    }
    
    func interAdClosed()
    {
        _bgPlayer.setMusicVolume(volume: 0.1)
        // need to act like reward received
        if _needToShowInterAds
        {
            self.pauseButtonAction()
            _rewardedAd.reloadRewardedAd()
        }
        else
        {
            self.rewardedFinishSuccessfuly()
            self.rewardedAdClosed()
        }
        
    }
    
    func didNotReceiveInterAd()
    {
        _bgPlayer.setMusicVolume(volume: 0.1)
        _rewardedAd.reloadRewardedAd()
        self.pauseButtonAction()
    }
    
    //////////////////////////////////////>> ADS HANDLING ////////////////////////////////////////
    
    
}

