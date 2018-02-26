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

    func moreButtonPressed()
    {  UIApplication.shared.openURL(URL.init(string:"itms-apps://itunes.apple.com/artist/eran-tager/id903651784")!)
    }
    
    func rateMeButtonPressed()
    {
        var urlStr: URL
    
    if #available(iOS 7.0, *)
    {
  //  urlStr = "itms-apps://itunes.apple.com/app/id"
        urlStr = URL.init(string:"itms-apps://itunes.apple.com/app/id"+APP_ID)!
      //  urlStr.appendingPathComponent("itms-apps://itunes.apple.com/app/id"+APP_ID)
    }
    else
    {
        urlStr = URL.init(string:"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id="+APP_ID+"&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software")!
    }
    UIApplication.shared.openURL(urlStr)
    }
}

let WIN_SIZE = KTF_WIN_SIZE().getWinSize

class KTF_WIN_SIZE {
    //return win size
    func getWinSize() -> CGSize {
        
        let screenSize = UIScreen.main.bounds.size
       
        return screenSize
    }
}


class KTF_POS
{
    // return pos in screen (use precentage input)
    func posInPrc(PrcX: CGFloat ,PrcY: CGFloat) -> CGPoint {
        
        let screenSize = UIScreen.main.bounds.size

        let x = screenSize.width * PrcX / 100;
        let y = screenSize.height * PrcY / 100;
        
        let point = CGPoint(x:x, y:y)
        
        return point
    }
    
    // return relative pos inside parent node
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
            let a = screenSize.width * PrcX * node.xScale / 200
            let b = screenSize.height * PrcY * node.yScale / 200
            print("X&Y:", x, y)
            print("A&B:", a, b)
        }
        
        let point = CGPoint(x:x, y:y)
        
        return point
        
    }
    
  // return relative pos inside parent node
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
    // scale node relatively to screen size
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
  
     // scale node relatively to screen's shorter screen side
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
    
    
    func scaleFloat(floatToScale:CGFloat, isX:Bool) -> CGFloat {
        
        var screenDefultSize: CGPoint
        var myFloat: CGFloat
        var prc: CGFloat
        
        if WIN_SIZE().width > WIN_SIZE().height
        {
            screenDefultSize = CGPoint(x:2048, y:1536)
        }
        else
        {
            screenDefultSize = CGPoint(x:1536, y:2048)
        }
        if isX
        {
         prc = floatToScale / (screenDefultSize.x / 100.0);
        myFloat = WIN_SIZE().width / 100 * prc
        }
        else
        {
            prc = floatToScale / (screenDefultSize.y / 100.0);
            myFloat = WIN_SIZE().height / 100 * prc
        }
        return myFloat
    }
}

class KTF_DeviceType {
    // return bool - true for iPhone
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
    // convert input of degrees and return the radians value
    func degreesToRadians(degrees:CGFloat) -> CGFloat {
        let radians = degrees * 0.0174533
        return radians
    }
}


class KTF_FILES_COUNT {
    // count group of files with the same prefix when last character is running number
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

//handle saved data using UserDefault
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
    
    // SAVE DATE
    func saveDate(date:Date, forKey:String) {
        
        var key = identity
        key.append(forKey)
        
        defaults.set(date, forKey: key)
        defaults.synchronize()
    }
    
    // GET DATE
    func getDate(forKey:String) -> Date{
        
        var item = Date()
        var key = identity
        key.append(forKey)
        
        if defaults.value(forKey: key) != nil
        {
            item = defaults.object(forKey: key) as! Date
        }
            return item
       }

}

class KTF_GRAY_IMAGE: UIImage {
    //get UIImage and return the image in gray scale (returned image does not have transparancy - transparent area return black)
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

let BEIZER_ARC_SIZE_X = KTF_SCALE().scaleFloat(floatToScale: 10, isX: true)
let BEIZER_ARC_SIZE_Y = KTF_SCALE().scaleFloat(floatToScale: 150, isX: true)

class KTF_BEZIER
{
    func beizerNode(node:SKNode, to:CGPoint)
    {
        // create a bezier path that defines our curve
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 16,y: 239))
        path.addCurve(to:CGPoint(x: 301, y: 239),
                      controlPoint1: CGPoint(x: 136, y: 373),
                      controlPoint2: CGPoint(x: 178, y: 110))
        
        // use the beizer path in an action
        node.run(SKAction.follow(path.cgPath,
                                        asOffset: false,
                                        orientToPath: true,
                                        speed: 30.0))
    }

    func beizerNode(node:SKNode,endPoint:CGPoint, shouldRotate:Bool, andSpeed:Float)
    {
        // create a bezier path that defines our curve
        
        let firstControlPoint = self.calculateFirstBeizerCheckPoint(startPoint: node.position, endPoint: endPoint)
        let secondControlPoint = self.calculateSecondBeizerCheckPoint(startPoint: node.position, endPoint: endPoint)

        let path = UIBezierPath()
        path.move(to: node.position)// CGPoint(x: 16,y: 239))
        path.addCurve(to:endPoint,//CGPoint(x: 301, y: 239),
                      controlPoint1: firstControlPoint,//CGPoint(x: 136, y: 373),
                      controlPoint2: secondControlPoint)
        
        // use the beizer path in an action
        node.run(SKAction.follow(path.cgPath,
                                        asOffset: false,
                                        orientToPath: shouldRotate,
                                        speed: CGFloat(andSpeed)))
    }

    func calculateFirstBeizerCheckPoint(startPoint:CGPoint, endPoint:CGPoint) -> CGPoint {
    
        var firstCheckPoint: CGPoint!
        var distX: CGFloat
        var distY: CGFloat
    
    if (startPoint.x > endPoint.x)
    {
    distX = (startPoint.x - endPoint.x) / 4;
    
    if (startPoint.y > endPoint.y)
    {
    firstCheckPoint.x = startPoint.x - distX - BEIZER_ARC_SIZE_X;
    }
    else
    {
    firstCheckPoint.x = startPoint.x - distX - BEIZER_ARC_SIZE_X;
    }
    }
    else
    {
    distX = (endPoint.x - startPoint.x) / 4;
    
    if (startPoint.y < endPoint.y)
    {
    firstCheckPoint.x = startPoint.x + distX - BEIZER_ARC_SIZE_X;
    }
    else
    {
    firstCheckPoint.x = startPoint.x + distX + BEIZER_ARC_SIZE_X;
    }
    }
    
    if (startPoint.y > endPoint.y)
    {
    distY = (startPoint.y - endPoint.y) / 4;
    
    firstCheckPoint.y = startPoint.y - distY + BEIZER_ARC_SIZE_Y;
    }
    else
    {
    distY = (endPoint.y - startPoint.y) / 4;
    
    firstCheckPoint.y = startPoint.y + distY + BEIZER_ARC_SIZE_Y;
    }
    
    return firstCheckPoint;
    }

    func calculateSecondBeizerCheckPoint(startPoint:CGPoint, endPoint:CGPoint) -> CGPoint {
        
        var secondCheckPoint: CGPoint!
        var distX: CGFloat
        var distY: CGFloat
        
        if (startPoint.x > endPoint.x)
        {
            distX = (startPoint.x - endPoint.x) / 4;
            
            if (startPoint.y > endPoint.y)
            {
                secondCheckPoint.x = startPoint.x - distX - BEIZER_ARC_SIZE_X;
            }
            else
            {
                secondCheckPoint.x = startPoint.x - distX - BEIZER_ARC_SIZE_X;
            }
        }
        else
        {
            distX = (endPoint.x - startPoint.x) / 4;
            
            if (startPoint.y < endPoint.y)
            {
                secondCheckPoint.x = startPoint.x + distX - BEIZER_ARC_SIZE_X;
            }
            else
            {
                secondCheckPoint.x = startPoint.x + distX + BEIZER_ARC_SIZE_X;
            }
        }
        
        if (startPoint.y > endPoint.y)
        {
            distY = (startPoint.y - endPoint.y) / 4;
            
            secondCheckPoint.y = startPoint.y - distY + BEIZER_ARC_SIZE_Y;
        }
        else
        {
            distY = (endPoint.y - startPoint.y) / 4;
            
            secondCheckPoint.y = startPoint.y + distY + BEIZER_ARC_SIZE_Y;
        }
        
        return secondCheckPoint;
    }
}
////////>> BEZIER - not working need to fix

