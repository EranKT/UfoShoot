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
//var gameScore_ = KTF_DISK().getInt(forKey: SAVED_GAME_SCORE)

let maxLevelsInGame_ = 13
let stagesPerLevel_ = 4
let roundsPerStage_ = 4
let priceFactor_ = 600

var isFirstTimeToday_ = false
var dailyBonus_: Int!


enum gameZorder: CGFloat
{
    //bg - 0.000
    case animatedBg = 0.000
    // MAIN MENU SCENE - 10.000
    case main_menu_z_bg = 10.000
    
    // MAP SCENE - 20.000
    case map_scene_z_bg = 20.000
    case map_scene_z_root_lines = 20.021
    case map_scene_z_planets = 20.022
    
    // GAME SCENE - 30.000
    case rush_scene_z_bg = 30.000

    case coins = 40.000
    case obstacles = 45.000

    case bonus_image = 50.000
    case bonus_bubble = 0.051

    case GENERAL_bullets = 60.000
    
    case enemy = 70.000

    case enemy_ship = 80.000
    case enemy_ship_lights = 0.081
    case enemy_ship_lifeBarBg = 0.082
    case enemy_ship_lifeBar = 0.083
    
    // ufo - 90.000
    case ufo_base = 90.000
    // under ufo base
    case ufo_jet = -0.095
    case ufo_baseBack = -0.094
    case ufo_shield = -0.093
    case ufo_driver = -0.092
    case ufo_gun = -0.091
   // above ufo base
    case ufo_hood = 0.097
    case ufo_lights = 0.098
    
    // BUTTONS - 100.000
    case GENERAL_buttons = 100.000
    case GENERAL_buttons_image = 0.101
    case GENERAL_title = 100.002
    case GENERAL_particles = 100.003
    
    //scroll menu - 110.000
    case scroll_menu_bg = 110.000
    case scroll_menu = 110.001
    case scroll_menu_items = 110.002
    case scroll_menu_lock = 110.003
    case scroll_menu_top_label = 110.004
    case scroll_menu_bottom_label = 110.005
    case scroll_menu_nav_buttons = 110.006


    // status bar - 120.000
    case statusBar_bg = 120.000
    
     case statusBar_scoreBg = 120.121
    case statusBar_levelBg = 120.122
    case statusBar_coinsBg = 120.123
    case statusBar_score = 120.124
    case statusBar_level = 120.125
    case statusBar_coins = 120.126
    case statusBar_scoreTitle = 120.127
    case statusBar_levelTitle = 120.128
    case statusBar_coinsTitle = 120.129
    case statusBar_coinsImage = 120.130

    case round_label = 125.000
    
    //popup window - 130.000
    case popup_window_bg = 130.000
    case popup_window_label = 0.131
    case popup_window_button_bg = 0.132
    case popup_window_button_image = 0.133
    case popup_window_image = 0.134
    case popup_window_close_button = 0.135
}

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

