//
//  CommonDataClass.swift
//  TestSwiftGame
//
//  Created by EKT DIGIDESIGN on 12/15/17.
//  Copyright © 2017 EKT DIGIDESIGN. All rights reserved.
//

import Foundation
import SpriteKit

let SAVED_GAME_SCORE = "_score" // INT
let SAVED_GAME_COINS = "_coins" // INT
let SAVED_GAME_FINISHED_LEVEL = "finished_level" // INT
let SAVED_GAME_FINISHED_STAGE = "finished_stage" // INT
let SAVED_GAME_SELECTED_LEVEL = "selected_level" // INT
let SAVED_GAME_SELECTED_STAGE = "selected_stage" // INT
let SAVED_GAME_UFO = "_ufo_index" // INT
let SAVED_GAME_BOUGHT_UFO_LIST = "_my_ufo_array" // ARRAY
let SAVED_IS_CHANGING_STAGE = "is_changing_stage" // INT

var gameLevel_ = KTF_DISK().getInt(forKey: SAVED_GAME_FINISHED_LEVEL)
var gameStage_ = KTF_DISK().getInt(forKey: SAVED_GAME_FINISHED_STAGE)
var gameSelectedLevel_ = KTF_DISK().getInt(forKey: SAVED_GAME_SELECTED_LEVEL)
var gameSelectedStage_ = KTF_DISK().getInt(forKey: SAVED_GAME_SELECTED_STAGE)
var gameCoins_ = KTF_DISK().getInt(forKey: SAVED_GAME_COINS)

let maxLevelsInGame_ = 13
let stagesPerLevel_ = 4
let roundsPerStage_ = 4
let priceFactor_ = 600

enum CATEGORIES: Int
{
    case NUMBERS = 0
    case SHAPES
    case FRUITS
    case COLORS
    case LETTERS
    case VEGETABLES
    case WILD
    case FARM
}

let ITEMS_SCALE_PER_CATEGORY:[CGFloat] = [
    1.4,    //NUMBERS
    1.2,    //SHAPES
    1.2,    //FRUITS
    1.5,    //COLORS
    1.5,    //LETTERS
    1.1,    //VEGETABLES
    1.0,    //WILD
    1.0    //FARM
]

