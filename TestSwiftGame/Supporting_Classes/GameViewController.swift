//
//  GameViewController.swift
//  TestSwiftGame
//
//  Created by EKT DIGIDESIGN on 12/6/17.
//  Copyright © 2017 EKT DIGIDESIGN. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GoogleMobileAds

//var gridCollectionView_: UICollectionView!
//var gridLayout_: KTFMenu!


class GameViewController: UIViewController {

  //  var _cellCounter = 0

    override func loadView() {
        self.view = SKView()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
     
     
        //LOAD BANNER ADS
        KTF_Ads_Banner_Support().showAds(myView: self, atPos:KTF_Ads_Position.KTF_Ads_Position_bottom_middle)
        //PRELOAD REWARD AND INTER ADS
       KTF_Ads_Rewarded_Support().preloadRewardAds(myView: self)
        KTF_Ads_Inter_Support().preloadInterAds(myView: self)
        
        let scene:SKScene = MainScene(size: UIScreen.main.bounds.size)
            scene.scaleMode = .resizeFill


        if let view = self.view as! SKView? {

            let transition:SKTransition = SKTransition.fade(withDuration: 1)

            view.presentScene(scene, transition: transition)
            view.ignoresSiblingOrder = true
}
        }


   /*
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        var frame = gridCollectionView_.frame
        frame.size.height = self.view.frame.size.height/2
        frame.size.width = self.view.frame.size.width/2
        frame.origin.x = 0//self.view.frame.size.width/2  - self.view.frame.size.width/2
        frame.origin.y = 0//self.view.frame.size.height/2 - self.view.frame.size.height/2
        gridCollectionView_.frame = frame
        gridLayout_.scrollDirection = .horizontal

        // THIS LINE IS FOR ARROWS BUTTONS
       //   gridCollectionView_.scrollToItem(at: a, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)

    }
 */   override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
     return .portrait
     
        /*   if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
   */ }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

}
/*
 extension GameViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 13
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! KTFMenuImageCell
       var Str = "ufo_top_base_" + String(_cellCounter)
        cell.imageView.image = UIImage.init(named: Str)
        _cellCounter += 1
        return cell
    }


}
*/
