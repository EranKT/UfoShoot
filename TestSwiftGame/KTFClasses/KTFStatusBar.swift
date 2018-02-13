//
//  KTFStatusBar.swift
//  TestSwiftGame
//
//  Created by EKT DIGIDESIGN on 1/5/18.
//  Copyright © 2018 EKT DIGIDESIGN. All rights reserved.
//

import Foundation
import SpriteKit


let STATUSBAR_POS_UP = CGPoint.init(x: KTF_WIN_SIZE().getWinSize().width / 2,
             y: KTF_WIN_SIZE().getWinSize().height - KTF_StatusBar.statusBar_.frame.height/2)

let STATUSBAR_POS_DOWN = CGPoint.init(x: KTF_WIN_SIZE().getWinSize().width / 2,
                                      y: KTF_StatusBar.statusBar_.frame.height/2)

let SCORE_BAR_BG_FILE = "score_bar_bg"
let SCORE_BG_FILE = "score_bg"
let COIN_IMAGE_FILE = "space_coin"

//let statusBarZpos_ = CGFloat(1000)

let scoreBgPos_ = CGPoint(x: KTF_StatusBar.statusBar_.scoreBg_.frame.width*0.6,
                          y: KTF_StatusBar.statusBar_.position.y -
                            KTF_StatusBar.statusBar_.scoreBg_.frame.height*0.1)
let scoreTitleLabelPos_ = CGPoint(x: scoreBgPos_.x,
                             y: scoreBgPos_.y + KTF_StatusBar.statusBar_.scoreBg_.frame.height*0.4)
let scorePos_ = CGPoint(x: scoreBgPos_.x,
                             y: scoreBgPos_.y - KTF_StatusBar.statusBar_.scoreBg_.frame.height*0.2)

let levelBgPos_ = CGPoint(x: KTF_StatusBar.statusBar_.frame.width/2,
                         y: KTF_StatusBar.statusBar_.position.y -
                            KTF_StatusBar.statusBar_.levelBg_.frame.height*0.1)
let levelTitleLabelPos_ = CGPoint(x: levelBgPos_.x,
                             y: levelBgPos_.y + KTF_StatusBar.statusBar_.levelBg_.frame.height*0.4)
let levelPos_ = CGPoint(x: levelBgPos_.x,
                             y: levelBgPos_.y - KTF_StatusBar.statusBar_.levelBg_.frame.height*0.2)

let coinsBgPos_ = CGPoint(x: KTF_StatusBar.statusBar_.frame.width - KTF_StatusBar.statusBar_.coinsBg_.frame.width*0.6,
                         y: KTF_StatusBar.statusBar_.position.y -
                            KTF_StatusBar.statusBar_.coinsBg_.frame.height*0.1)
let coinsTitleLabelPos_ = CGPoint(x: coinsBgPos_.x,
                             y: coinsBgPos_.y +
                                KTF_StatusBar.statusBar_.coinsBg_.frame.height*0.4)
let coinsImagePos_ = CGPoint(x: coinsBgPos_.x - KTF_StatusBar.statusBar_.coinsBg_.frame.width*0.6,
                             y: coinsBgPos_.y)
let coinsPos_ = CGPoint(x: coinsBgPos_.x,
                             y: coinsBgPos_.y - KTF_StatusBar.statusBar_.coinsBg_.frame.height*0.2)



class KTF_StatusBar: KTF_Sprite {
    
    static var statusBar_ = KTF_StatusBar()
    
    let scoreBg_ = KTF_Sprite(imageNamed: SCORE_BG_FILE)
    let levelBg_ = KTF_Sprite(imageNamed: SCORE_BG_FILE)
    let coinsBg_ = KTF_Sprite(imageNamed: SCORE_BG_FILE)
    let coinsImage_ = KTF_Sprite(imageNamed: COIN_IMAGE_FILE)

    var scoreLabel_: SKLabelNode!
    var levelLabel_: SKLabelNode!
    var coinsLabel_: SKLabelNode!
    
    var scene_: SKScene!
    
    func initStatusBar(scene:SKScene, posIsTop:Bool ) -> KTF_StatusBar {
 KTF_StatusBar.statusBar_ = KTF_StatusBar(imageNamed: SCORE_BAR_BG_FILE)
        
        KTF_StatusBar.statusBar_.scene_ = scene
        KTF_StatusBar.statusBar_.scene_.addChild(KTF_StatusBar.statusBar_)
        KTF_StatusBar.statusBar_.zPosition = gameZorder.statusBar_bg.rawValue//statusBarZpos_
        KTF_SCALE().ScaleMyNode(nodeToScale: KTF_StatusBar.statusBar_)
        var pos:CGPoint
        if posIsTop
        {
            pos = STATUSBAR_POS_UP
        }
        else
        {
            pos = STATUSBAR_POS_DOWN
        }
        
        KTF_StatusBar.statusBar_.position = pos

        return KTF_StatusBar.statusBar_
    }
    
    func populateStatusBar(includeSavedScore:Bool)   {
        
        self.addScoreToBar(title: "SCORE", includeSavedScore:includeSavedScore)
        self.addLevelToBar(title: "LEVEL")
        self.addCoinsToBar(title: "SPACE COINS", includeSavedScore:includeSavedScore)
        // add level with label
        // add coins count with icon
    }
    
    func addScoreToBar(title:String, includeSavedScore:Bool) {
        //SCORE BG
        KTF_SCALE().ScaleMyNode(nodeToScale: scoreBg_)
        scoreBg_.position =  scoreBgPos_
        scoreBg_.zPosition = gameZorder.statusBar_scoreBg.rawValue//statusBarZpos_ + 1
        scene_.addChild(scoreBg_)
        
        //SCORE TITLE LABEL
        let scoreTitleLabel = SKLabelNode(fontNamed: "Avenir-Black")
        scoreTitleLabel.text = title
        scoreTitleLabel.colorBlendFactor = 1.0
        scoreTitleLabel.color = UIColor.red
        scoreTitleLabel.fontSize = 50
    //    print("BG FRAME:",scoreBg_.frame)
        scoreTitleLabel.position = scoreTitleLabelPos_
        scoreTitleLabel.name = "scoreTitleLabel"
        KTF_SCALE().ScaleMyNode(nodeToScale: scoreTitleLabel)
        scoreTitleLabel.zPosition = gameZorder.statusBar_scoreTitle.rawValue//statusBarZpos_ + 2
        scene_.addChild(scoreTitleLabel)
        
        //SCORE LABEL
         var score = KTF_DISK().getInt(forKey: SAVED_GAME_SCORE)
        if !includeSavedScore
        {
            score = 0
        }
        scoreLabel_ = SKLabelNode(fontNamed: "Avenir-Black")
        scoreLabel_.text = String(score)
        scoreLabel_.colorBlendFactor = 1.0
        scoreLabel_.color = UIColor.red
        scoreLabel_.fontSize = 80
        scoreLabel_.position = scorePos_
        scoreLabel_.name = "score"
        KTF_SCALE().ScaleMyNode(nodeToScale: scoreLabel_)
        scoreLabel_.zPosition = gameZorder.statusBar_score.rawValue//statusBarZpos_ + 3
        scene_.addChild(scoreLabel_)
    }

    func addLevelToBar(title:String) {
        //LEVEL BG
        KTF_SCALE().ScaleMyNode(nodeToScale: levelBg_)
        levelBg_.position =  levelBgPos_
        levelBg_.zPosition = gameZorder.statusBar_levelBg.rawValue//statusBarZpos_ + 1
        scene_.addChild(levelBg_)
        
        //LEVEL TITLE LABEL
        let levelTitleLabel = SKLabelNode(fontNamed: "Avenir-Black")
        levelTitleLabel.text = title
        levelTitleLabel.colorBlendFactor = 1.0
        levelTitleLabel.color = UIColor.red
        levelTitleLabel.fontSize = 50
        levelTitleLabel.position = levelTitleLabelPos_
        levelTitleLabel.name = "levelTitleLabel"
        KTF_SCALE().ScaleMyNode(nodeToScale: levelTitleLabel)
        levelTitleLabel.zPosition = gameZorder.statusBar_levelTitle.rawValue//statusBarZpos_ + 2
        scene_.addChild(levelTitleLabel)
        
        //LEVEL LABEL
        
        levelLabel_ = SKLabelNode(fontNamed: "Avenir-Black")
        levelLabel_.text = String(gameSelectedLevel_)+"-"+String(gameSelectedStage_)
        levelLabel_.colorBlendFactor = 1.0
        levelLabel_.color = UIColor.red
        levelLabel_.fontSize = 80
        levelLabel_.position = levelPos_
        levelLabel_.name = "level"
        KTF_SCALE().ScaleMyNode(nodeToScale: levelLabel_)
        levelLabel_.zPosition = gameZorder.statusBar_level.rawValue//statusBarZpos_ + 3
        scene_.addChild(levelLabel_)
    }
    
    func addCoinsToBar(title:String, includeSavedScore:Bool) {
        //COINS BG
        KTF_SCALE().ScaleMyNode(nodeToScale: coinsBg_)
        coinsBg_.position =  coinsBgPos_
        coinsBg_.zPosition = gameZorder.statusBar_coinsBg.rawValue//statusBarZpos_ + 1
        scene_.addChild(coinsBg_)
        
        //COINS IMAGE
        KTF_SCALE().ScaleMyNodeRelatively(nodeToScale: coinsImage_)
        coinsImage_.xScale = coinsImage_.xScale*0.8
        coinsImage_.yScale = coinsImage_.yScale*0.8
        coinsImage_.position =  coinsImagePos_
        coinsImage_.zPosition = gameZorder.statusBar_coinsImage.rawValue//statusBarZpos_ + 1
        scene_.addChild(coinsImage_)
        
        //COINS TITLE LABEL
        let coinsTitleLabel = SKLabelNode(fontNamed: "Avenir-Black")
        coinsTitleLabel.text = title
        coinsTitleLabel.colorBlendFactor = 1.0
        coinsTitleLabel.color = UIColor.red
        coinsTitleLabel.fontSize = 50
        coinsTitleLabel.position = coinsTitleLabelPos_
        coinsTitleLabel.name = "coinsTitleLabel"
        KTF_SCALE().ScaleMyNode(nodeToScale: coinsTitleLabel)
        coinsTitleLabel.zPosition = gameZorder.statusBar_coinsTitle.rawValue//statusBarZpos_ + 2
        scene_.addChild(coinsTitleLabel)
        
        //COINS LABEL
        var coins = KTF_DISK().getInt(forKey: SAVED_GAME_COINS)
        if !includeSavedScore
        {
            coins = 0
        }
        coinsLabel_ = SKLabelNode(fontNamed: "Avenir-Black")
        coinsLabel_.text = String(coins)
        coinsLabel_.colorBlendFactor = 1.0
        coinsLabel_.color = UIColor.red
        coinsLabel_.fontSize = 80
      //  print("CHECK THIS",coinsBg_.yScale, coinsLabel_.fontSize)
        coinsLabel_.position = coinsPos_
        coinsLabel_.name = "coins"
        KTF_SCALE().ScaleMyNode(nodeToScale: coinsLabel_)
        coinsLabel_.zPosition = gameZorder.statusBar_coins.rawValue//statusBarZpos_ + 3
        scene_.addChild(coinsLabel_)
    }
    
    func updateStageScore(score:Int)
    {
        scoreLabel_.text = String(score)
        var addToScore = KTF_DISK().getInt(forKey: SAVED_GAME_SCORE)
        addToScore += score
        KTF_DISK().saveInt(number: addToScore, forKey: SAVED_GAME_SCORE)
   }
    
    func updateScoreAndSave(addToScore:Int)
    {
        var score = KTF_DISK().getInt(forKey: SAVED_GAME_SCORE)
        score += addToScore
        KTF_DISK().saveInt(number: score, forKey: SAVED_GAME_SCORE)
        scoreLabel_.text = String(score)
    }
    
    func updatelevel()
    {
  // lower level or lower stage in game level
        if gameSelectedLevel_ < gameLevel_ || gameSelectedLevel_ == gameLevel_ && gameSelectedStage_ < gameStage_
        {    // last stage - need to move to next selected level
            if gameSelectedStage_ == stagesPerLevel_
            {
                gameSelectedLevel_ += 1
                gameSelectedStage_ = 1
            } // NOT last stage - need to update stage
            else
            {
                gameSelectedStage_ += 1
            }
        } // selected is the actual game level & stage
        else if gameSelectedLevel_ == gameLevel_ && gameSelectedStage_ == gameStage_
        {
            // last stage - need to move to next level
            if gameSelectedStage_ == stagesPerLevel_
            {
                gameLevel_ += 1
                gameStage_ = 1
            } // NOT last stage - need to update stage
            else
            {
                gameStage_ += 1
            }
            gameSelectedLevel_ = gameLevel_
            gameSelectedStage_ = gameStage_
        }
        KTF_DISK().saveInt(number: gameLevel_, forKey: SAVED_GAME_FINISHED_LEVEL)
        KTF_DISK().saveInt(number: gameSelectedLevel_, forKey: SAVED_GAME_SELECTED_LEVEL)
        KTF_DISK().saveInt(number: gameStage_, forKey: SAVED_GAME_FINISHED_STAGE)
        KTF_DISK().saveInt(number: gameSelectedStage_, forKey: SAVED_GAME_SELECTED_STAGE)
   
        levelLabel_.text = String(gameSelectedLevel_) + "-" + String(gameSelectedStage_)
     }

    func updateStageCoins(coins:Int, amountToUpdate:Int)
    {
        coinsLabel_.text = String(coins)
        var savedCoins = KTF_DISK().getInt(forKey: SAVED_GAME_COINS)
        savedCoins += amountToUpdate
        //save new coins
        KTF_DISK().saveInt(number: savedCoins, forKey: SAVED_GAME_COINS)
        
    }

    
    func updateCoinsAndSave(addToCoins:Int, shouldUpdateStatusBar:Bool, animated:Bool)
    {
        // get saved coins
        let coins = KTF_DISK().getInt(forKey: SAVED_GAME_COINS)
        if animated {
            KTF_StatusBar.statusBar_.updateCoinsAnimation(from: coins, to: coins+addToCoins)
            return
        }
        //add to coins
        gameCoins_ += addToCoins
        //save new coins
        KTF_DISK().saveInt(number: gameCoins_, forKey: SAVED_GAME_COINS)
        // update coins label
        // DISABLE THIS LINE WHEN BUYING LIFE DURING GAME TO PREVENT SHOWING SAVED COINS
        if shouldUpdateStatusBar
        {
            coinsLabel_.text = String(gameCoins_)
       }
    }

    
    func updateCoinsAnimation(from:Int, to:Int) {
        if from == to
        {
            KTF_DISK().saveInt(number: to, forKey: SAVED_GAME_COINS)
            return
        }

        var newFrom = from
        if from < to {
            newFrom += 1
        }
        else
        {
            newFrom -= 1
        }
        run(SKAction.sequence([
            SKAction.wait(forDuration: 0.05),
            SKAction.run{KTF_StatusBar.statusBar_.updateCoinsAnimation(from: newFrom, to: to)}
            ]
        ))
    }
}
