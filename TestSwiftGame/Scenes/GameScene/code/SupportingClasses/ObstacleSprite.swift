
//
//  ObstacleSprite.swift
//  TestSwiftGame
//
//  Created by EKT DIGIDESIGN on 12/27/17.
//  Copyright © 2017 EKT DIGIDESIGN. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

let OBSTACLE_FILES_PREFIX = "obstacle_"


class ObstacleSprite: KTF_Sprite {
    
    
    var _timer: Timer!
    
    var _speed: CGFloat!
    var _speedDelta: CGFloat!
    let _maxSpeed = CGFloat(7.0)
    var _obstacleFilesCount: Int!
    
    // GENERATE FILE NAME FOR OBSTACLE
    func getFileName() -> String {
        _obstacleFilesCount = KTF_FILES_COUNT().countGroupOfFiles(prefix: OBSTACLE_FILES_PREFIX,
                                                                  sufix: "png",
                                                                  firstNumber: 0);
        
        let obstacleIndex = Int(arc4random()%UInt32(_obstacleFilesCount))
        
        let fileName = OBSTACLE_FILES_PREFIX + String(obstacleIndex)+".png"
        return fileName
    }
    //INIT OBSTACLE POS AND SCROLL
    func initObstacle()
    {
        self.setScrollSpeed(speed: 4.0, speedDeltaBetweenLayers: 0.5)

        let startXpoint = CGFloat(arc4random()%80) + 10
        self.position = KTF_POS().posInPrc(PrcX: startXpoint, PrcY: 110)
        self.tag = 1
        _timer = Timer.scheduledTimer(timeInterval: 1.0/60.0,
                                      target: self,
                                      selector: #selector(ObstacleSprite.obstacleAnimation),
                                      userInfo: nil,
                                      repeats: true)
    }
    
   @objc func obstacleAnimation()
    {
        var delta = CGFloat(1.0);
        var newPos_1 = self.position

            newPos_1.y -= _speed * delta
            delta += _speedDelta
            
            self.position = newPos_1;

            if (newPos_1.y <= 0)
            {
           self.stopScrolling()
              self.tag = -1
                self.removeAllActions()
                self.removeFromParent()
              //  }
        }
    }
    
    func stopScrolling()
    {
        if _timer != nil
        {
            _timer.invalidate()
            _timer = nil
        }
    }
    
    func setScrollSpeed(speed:CGFloat, speedDeltaBetweenLayers delta:CGFloat)
    {
        if (KTF_DeviceType().isiPhone()) {
            _speed = speed * 0.3;
            _speedDelta = delta * 0.3;
        }else{
            _speed = speed;
            _speedDelta = delta;
        }
    }
    func setScrollSpeedByPRC(speedPRC:CGFloat)
    {
        let newSpeed = _maxSpeed  *  (speedPRC / 100);
        _speed = newSpeed;
    }
    
}
