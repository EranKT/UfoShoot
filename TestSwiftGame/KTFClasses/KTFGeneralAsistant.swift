//
//  KTFGeneralAsistant.swift
//  TestSwiftGame
//
//  Created by EKT DIGIDESIGN on 12/14/17.
//  Copyright © 2017 EKT DIGIDESIGN. All rights reserved.
//

import Foundation
import SpriteKit

class KTFGeneralAsistant: SKScene {

    

}

class KTF_WIN_SIZE {
    
    func getWinSize() -> CGSize {
        
        let screenSize = UIScreen.main.bounds.size
       
        return screenSize
    }
}


class KTF_POS
{
    
    func posInPrc(PrcX: CGFloat ,PrcY: CGFloat) -> CGPoint {
        
        let screenSize = UIScreen.main.bounds.size

        let x = screenSize.width * PrcX / 100;
        let y = screenSize.height * PrcY / 100;
        
        let point = CGPoint(x:x, y:y)
        
        return point
    }
    
    func posInNodePrc(node: SKNode, isParentFullScreen:Bool, PrcX: CGFloat ,PrcY: CGFloat) -> CGPoint {
       
        let screenSize = CGSize.init(width: node.frame.size.width, height: node.frame.size.height)

        var x: CGFloat
        var y: CGFloat
        
        if isParentFullScreen
        {
            x = screenSize.width * PrcX / 100 / node.xScale
            y = screenSize.height * PrcY / 100 / node.yScale
        }
        else
        {
            x = screenSize.width * PrcX / 100 * node.xScale / 100
            y = screenSize.height * PrcY / 100 * node.yScale / 100
            
        }
        
        let point = CGPoint(x:x, y:y)
        
        return point
        
    }
    
    func posInRelativeScalesNodePrc(node: SKNode, PrcX: CGFloat ,PrcY: CGFloat) -> CGPoint {
        
        let screenSize = CGSize.init(width: node.frame.size.width, height: node.frame.size.height)
        
        var x: CGFloat
        var y: CGFloat
        let winSize = UIScreen.main.bounds

        if winSize.width > winSize.height
        {
            x = screenSize.width * PrcX / 100 * node.xScale / 100
            y = screenSize.height * PrcY / 100 * node.yScale / 100
        }
        else
        {
            x = screenSize.width * PrcX / 100 * node.xScale / 100
            y = screenSize.height * PrcY / 100 / node.yScale / 2
            
        }
        
        let point = CGPoint(x:x, y:y)
        
        return point
        
    }
}

class KTF_SCALE
{
    func ScaleMyNode(nodeToScale:SKNode) {
        
        let winSize = UIScreen.main.bounds
        
        if winSize.width > winSize.height
        {
            nodeToScale.xScale = winSize.width / 2048
            nodeToScale.yScale = winSize.height / 1536
        }
        else
        {
            nodeToScale.xScale = winSize.width / 1536
            nodeToScale.yScale = winSize.height / 2048
        }
    }
    
    func ScaleMyNodeRelatively(nodeToScale:SKNode) {
        
        let winSize = UIScreen.main.bounds
        
        if winSize.width > winSize.height
        {
            nodeToScale.xScale = winSize.height / 1536
            nodeToScale.yScale = winSize.height / 1536
        }
        else
        {
            nodeToScale.xScale = winSize.width / 2048
            nodeToScale.yScale = winSize.width / 2048
        }
    }
    
}

class KTF_DeviceType {
    
    func isiPhone() -> Bool {
        //iPhone or iPad
        let model = UIDevice.current.model
        
      //  print("device type=\(model)")
if model == "iPhone"
{
        return true
        }
        else
{
    return false
        }
    }
}

class KTF_CONVERT
{
    func degreesToRadians(degrees:CGFloat) -> CGFloat {
        let radians = degrees * 0.0174533
        return radians
    }
}


class KTF_FILES_COUNT {
    
    func countGroupOfFiles(prefix: String, sufix: String, firstNumber: Int) -> Int {
        var itemFileName: String
        var foundAllFiles = false
        var index = firstNumber
        var count = 0
        
        while !foundAllFiles {
            
            itemFileName = prefix
            itemFileName.append(String(index))
            if (Bundle.main.path(forResource: itemFileName, ofType: sufix) != nil)
            {
                index += 1
                count += 1
            }
            else
            {
                foundAllFiles = true
            }
        }
        return count
    }
    
    func removeAllChildrenForScene(scene:SKNode) {
        scene.removeAllChildren()
    }
}


class KTF_DISK {
    
    let defaults: UserDefaults = UserDefaults.standard
    var identity = "MyArchivedFilePath"
    
    // SAVE STRING
    func saveString(itemToSave:String, forKey:String) {
        
        var key = identity
        key.append(forKey)
        
        defaults.set(itemToSave, forKey: key)
        defaults.synchronize()
    }
    
    // GET STRING
    func getString(forKey:String) -> String{
        
        let item: String!
        var key = identity
        key.append(forKey)
        
        if defaults.value(forKey: key) != nil
        {
         item = defaults.value(forKey: key) as! String
            return item
        }
        else
        {
        return ""
            
        }
    }
    
    // SAVE INT
    func saveInt(number:Int, forKey:String) {
        
        
        var key = identity
            key.append(forKey)
      //  print("SAVE KEY", key)
        defaults.set(number, forKey: key)
        defaults.synchronize()
    }
    
    // GET INT
    func getInt(forKey:String) -> Int{
        
        let item: Int!
        var key = identity
      //  print("GET KEY", key)

        key.append(forKey)
            item = defaults.integer(forKey: key)
            return item
        
    }
    
    // SAVE BOOL
    func saveBool(isTrue:Bool, forKey:String) {
        
        var key = identity
        key.append(forKey)
        
        defaults.set(isTrue, forKey: key)
        defaults.synchronize()
    }
    
    // GET BOOL
    func getBool(forKey:String) -> Bool{
        
        let item: Bool!
        var key = identity
        key.append(forKey)
        
            item = defaults.bool(forKey: key)
            return item
    }
    
    // SAVE ARRAY
    func saveArray(array:Any, forKey:String) {
        
        var key = identity
        key.append(forKey)
        
        defaults.set(array, forKey: key)
        defaults.synchronize()
    }
    
    // GET ARRAY
    func getArray(forKey:String) -> Any{
        
        let item: Any!
        var key = identity
        key.append(forKey)
        
        if defaults.value(forKey: key) != nil
        {
            item = defaults.array(forKey: key)
            return item
        }
        else
        {
            return []
        }
    }

}

class KTF_GRAY_IMAGE: UIImage {
    func convertImageToGrayScale(image:UIImage) -> UIImage
    {
    
    // Create image rectangle with current image width/height
        let imageRect = CGRect.init(x: 0, y: 0, width: image.size.width, height: image.size.height)
    
    // Grayscale color space
        let colorSpace:CGColorSpace = CGColorSpaceCreateDeviceGray()
    
    // Create bitmap content with current image size and grayscale colorspace
        let context:CGContext = CGContext(data: nil, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.none.rawValue)!
    // Draw image into current context, with specified rectangle
    // using previously defined context (with grayscale colorspace)
   // CGContextDrawImage(context, imageRect, image.cgImage)
        context.draw(image.cgImage!, in: imageRect)
    // Create bitmap image info from pixel data in current context
        let imageRef = context.makeImage()
    
    // Create a new UIImage object
        let newImage = UIImage.init(cgImage: imageRef!)
    // Return the new grayscale image
    return newImage;
    }

}


////////BEZIER
// Bezier cubic formula:
//    ((1 - t) + t)3 = 1
// Expands to…
//   (1 - t)3 + 3t(1-t)2 + 3t2(1 - t) + t3 = 1

 extension CGFloat {
    static func bezierat(a: CGFloat, b: CGFloat, c: CGFloat, d: CGFloat, t: TimeInterval) -> CGFloat {
        
        let time = Float(t)
        let first = CGFloat(powf(1-time,3)) * a
        let secondFloat = CGFloat(powf(1-time,2))
        let timeCGFloat = CGFloat(time)
        let second = 3*timeCGFloat*secondFloat*b
        let thirdCGFloat = CGFloat(powf(time,2))
        let third = 3*thirdCGFloat*(1-timeCGFloat)*c
        let forthFloat = CGFloat(powf(time,3))
        let forth = forthFloat*d
        
        return (first + second + third + forth);
    }
    
}


public struct _ktfBezierConfig {
    //! end position of the bezier
    var endPosition: CGPoint
    //! Bezier control point 1
    var controlPoint_1: CGPoint
    //! Bezier control point 2
    var controlPoint_2: CGPoint
}

class KTF_BEZIER_BY
{
    var timer: Timer?
    var _withConfig: _ktfBezierConfig!
    var _andTarget: SKNode!
    var _withTime: TimeInterval!
    var _startPos: CGPoint!
    
    
    
    
    func startTimer(withConfig:_ktfBezierConfig, andTarget:SKNode, withTime: CGFloat) {
        
        
        _andTarget = andTarget
        _withConfig = withConfig
        _withTime = TimeInterval(withTime)
        _startPos = andTarget.position
        
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(withTime),
                                         target: self,
                                         selector: #selector(self.loop),
                                         userInfo: nil,
                                         repeats: true)
        }
    
    }
    
    func stopTimer() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    @objc func loop()
    {
        self.update(target_: _andTarget, startPosition_: _startPos, config_: _withConfig, t: _withTime)
        
    }

  //  var config_: _ktfBezierConfig!
   // var target_: SKNode!
   // var startPosition_: CGPoint!
    
    
    func startBezier(withConfig:_ktfBezierConfig, andTarget:SKNode)
    {
        //  config_ = withConfig
      //  target_ = andTarget
    //  let startPosition = andTarget.position
        KTF_BEZIER_BY().startTimer(withConfig: withConfig, andTarget: andTarget, withTime: 0.2)
      /*  KTF_BEZIER_BY().startTimer(forMethod: KTF_BEZIER_BY().update(target_: andTarget,
                                                                     startPosition_: startPosition,
                                                                     config_: withConfig,
                                                                     t: 0.2),
                                   withTime: 0.2)
        */
      //  KTF_BEZIER_BY().startTimer(forMethod: KTF_BEZIER_BY().update(config_: withConfig, t: 0.2), withTime: 0.2)
    }
 
    
    func update(target_:SKNode, startPosition_:CGPoint, config_:_ktfBezierConfig, t:TimeInterval)
    {
//print("updatePos")
        let xa = CGFloat(0);
    let xb = config_.controlPoint_1.x;
    let xc = config_.controlPoint_2.x;
    let xd = config_.endPosition.x;
    
    let ya = CGFloat(0);
    let yb = config_.controlPoint_1.y;
    let yc = config_.controlPoint_2.y;
    let yd = config_.endPosition.y;
    
        let x = CGFloat.bezierat(a: xa, b: xb, c: xc, d: xd, t: t);
        let y = CGFloat.bezierat(a: ya, b: yb, c: yc, d: yd, t: t);
        let currentPos = CGPoint.init(x: x, y: y)
    //    print(x, y)
        target_.position = CGPoint.init(x: startPosition_.x + currentPos.x, y: startPosition_.y + currentPos.y)
   }
}
