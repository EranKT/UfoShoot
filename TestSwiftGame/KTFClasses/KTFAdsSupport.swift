//
//  KTFAdsSupport.swift
//  TestSwiftGame
//
//  Created by EKT DIGIDESIGN on 12/15/17.
//  Copyright © 2017 EKT DIGIDESIGN. All rights reserved.
//

import Foundation
import SpriteKit
import GoogleMobileAds

enum KTF_Ads_Position: Int
{
    case KTF_Ads_Position_bottom_middle = 0
    case KTF_Ads_Position_top_middle
}

enum KTF_Ads_Type: Int
{
    case KTF_Ads_Type_Banner = 0
    case KTF_Ads_Type_Inter
    case KTF_Ads_Type_Rewarded
}
/*
 //PRELOAD REWARD AND INTER ADS
 KTF_DISK().saveInt(number: 0, forKey: SAVED_GAME_UFO)

 HANDLE ADS:
 //BANNER:
//// KTF_Ads_Banner_Support().showAds(myView: self, atPos:KTF_Ads_Position.KTF_Ads_Position_bottom_middle)
//// KTF_Ads_Banner_Support().setAdsPos(atPos: KTF_Ads_Position.KTF_Ads_Position_bottom_middle)
 REWARDED:
 KTF_Ads_Rewarded_Support().preloadRewardAds(myView: self) - in viewController
 //   KTF_Ads_Rewarded_Support().presentRewardAdFor(scene: self) - from any scene
 INTER:
 KTF_Ads_Inter_Support().preloadInterAds(myView: self) - in viewController
//     KTF_Ads_Inter_Support().presentInterAds() - from any class
 */

class KTF_Ads_Banner_Support: SKNode, GADBannerViewDelegate {
    
   static var myViewController: GameViewController!
   static var bannerAdsPointer: KTF_Ads_Banner_Support!
    static var adBannerView: GADBannerView!
    
 //////////////////////////////////////////////<< BANNER ADS CODE ////////////////////////////////////////////
// FIRST ACCESS TO CREATE POINTER
    func showAds(myView: UIViewController, atPos: KTF_Ads_Position) {
        
        if KTF_Ads_Banner_Support.bannerAdsPointer == nil {
            
            KTF_Ads_Banner_Support.bannerAdsPointer = KTF_Ads_Banner_Support.init(myView: myView, atPos: atPos)
        }
        else
        {
            print("show ads bannerAdsPointer ALIVE")
            self.setAdsPos(atPos: atPos)

        }
    }
 
    //INIT BANNER ADS
    convenience init(myView: UIViewController, atPos: KTF_Ads_Position) {
    self.init()

        KTF_Ads_Banner_Support.myViewController = myView as! GameViewController
       // adsPos = atPos
        var kGADAdbannerSize: GADAdSize!
        
        if KTF_DeviceType().isiPhone()
        {
            kGADAdbannerSize = kGADAdSizeBanner
        }
        else
        {
            kGADAdbannerSize = kGADAdSizeLeaderboard;
        }
        KTF_Ads_Banner_Support.adBannerView = GADBannerView(adSize: kGADAdbannerSize)
        KTF_Ads_Banner_Support.adBannerView.adUnitID = KTF_Ads_Sub_Class().getAdUnitID(adsType: KTF_Ads_Type.KTF_Ads_Type_Banner)
        KTF_Ads_Banner_Support.adBannerView.delegate = self
        KTF_Ads_Banner_Support.adBannerView.rootViewController = KTF_Ads_Banner_Support.myViewController
        self.setAdsPos(atPos: atPos)
        KTF_Ads_Banner_Support.adBannerView.load(KTF_Ads_Sub_Class().loadAdRequest())

        KTF_Ads_Banner_Support.myViewController.view.addSubview(KTF_Ads_Banner_Support.adBannerView)
 }
 

    // SET BANNER ADS POS BETWEEN SCENES
    func setAdsPos(atPos: KTF_Ads_Position) {
  
        if KTF_Ads_Banner_Support.bannerAdsPointer == nil {return}
      
        var kGADAdbannerSize: GADAdSize!
        var bannerSize: CGSize!
        
        if KTF_DeviceType().isiPhone()
        {
            kGADAdbannerSize = kGADAdSizeBanner
        }
        else
        {
            kGADAdbannerSize = kGADAdSizeLeaderboard;
        }
        
        bannerSize = CGSize.init(width: kGADAdbannerSize.size.width, height: kGADAdbannerSize.size.height)
        
        KTF_Ads_Banner_Support.adBannerView.center = self.getAdsPosition(bannerSize: bannerSize, posIndex: atPos)
        
    }
    // RETURNS ADS POSITION
    func getAdsPosition(bannerSize:CGSize, posIndex:KTF_Ads_Position) -> CGPoint{
        
        var adPosition: CGPoint!
        let posIndexInt = posIndex.rawValue
        
        switch posIndexInt {
        case KTF_Ads_Position.KTF_Ads_Position_bottom_middle.rawValue:
            adPosition = CGPoint.init(x: KTF_WIN_SIZE().getWinSize().width / 2,
                                      y: KTF_WIN_SIZE().getWinSize().height - bannerSize.height/2)
            break
        case KTF_Ads_Position.KTF_Ads_Position_top_middle.rawValue:
            adPosition = CGPoint.init(x: KTF_WIN_SIZE().getWinSize().width / 2,
                                      y: bannerSize.height/2)
            break
            
        default:
            adPosition = CGPoint.init(x: KTF_WIN_SIZE().getWinSize().width / 2,
                                      y: KTF_WIN_SIZE().getWinSize().height - bannerSize.height/2)
            
        }
        return adPosition
    }
    
    //<< BANNER ADS OVERRIDE METHODS
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner loaded successfully")
        
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("Fail to receive ads")
        print(error)
    }
    
    //>> BANNER ADS OVERRIDE METHODS
}
//////////////////////////////////////////////>> BANNER ADS CODE ////////////////////////////////////////////


//////////////////////////////////////////////<< INTER ADS CODE ////////////////////////////////////////////
protocol KTF_Ads_Inter_SupportDelegate: class{
    func interAdClosed()
    func didNotReceiveInterAd()
}

class KTF_Ads_Inter_Support: SKNode, GADInterstitialDelegate {
    
    static var myInterViewController: GameViewController!
    static var interAdsPointer: KTF_Ads_Inter_Support!
    static var adInterView: GADInterstitial!
    weak var delegate: KTF_Ads_Inter_SupportDelegate?
    static var didReceiveInterAd = false

    func preloadInterAds(myView: UIViewController) {
        
        KTF_Ads_Inter_Support.interAdsPointer = KTF_Ads_Inter_Support.init(myView: myView)
    }
    
    convenience init(myView: UIViewController) {
        self.init()
        KTF_Ads_Inter_Support.myInterViewController = myView as! GameViewController
        KTF_Ads_Inter_Support.adInterView = GADInterstitial.init(adUnitID: KTF_Ads_Sub_Class().getAdUnitID(adsType: KTF_Ads_Type.KTF_Ads_Type_Inter))
    
    KTF_Ads_Inter_Support.adInterView.delegate = self
        
        KTF_Ads_Inter_Support.adInterView.load(KTF_Ads_Sub_Class().loadAdRequest())
    }
    
    func presentInterAds() -> KTF_Ads_Inter_Support
    {
        if KTF_Ads_Inter_Support.didReceiveInterAd
        {
            KTF_Ads_Inter_Support.adInterView.present(fromRootViewController: KTF_Ads_Inter_Support.myInterViewController)
        }
        else
        {
            print("NO INTER TO SHOW")
            delegate?.didNotReceiveInterAd()
        }
        
        return KTF_Ads_Inter_Support.interAdsPointer
    }

    func interstitialWillDismissScreen(_ ad: GADInterstitial)
    {
        print("INTER - will close")
        delegate?.interAdClosed()
       let tempviewController = KTF_Ads_Inter_Support.myInterViewController
        KTF_Ads_Inter_Support.myInterViewController = nil
        KTF_Ads_Inter_Support.interAdsPointer = nil
        KTF_Ads_Inter_Support.adInterView = nil
        KTF_Ads_Inter_Support.didReceiveInterAd = false
      KTF_Ads_Inter_Support().preloadInterAds(myView: tempviewController!)
  }
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        KTF_Ads_Inter_Support.didReceiveInterAd = true
        print("INTER - received ad")
    }

}
//////////////////////////////////////////////>> INTER ADS CODE ////////////////////////////////////////////



//////////////////////////////////////////////<< REWARDED ADS CODE ////////////////////////////////////////////

 protocol KTF_Ads_Rewarded_SupportDelegate: class{
    func rewardedFinishSuccessfuly()
    func rewardedAdClosed()
 //   func thereIsNoRewardAdToPresent()
}

class KTF_Ads_Rewarded_Support: SKNode, GADRewardBasedVideoAdDelegate {
    
    
    static var myRewardedViewController: GameViewController!
    static var rewardedAdsPointer: KTF_Ads_Rewarded_Support?
    static var adRewardedView: GADRewardBasedVideoAd!
    static var _scene: SKScene!
    weak var delegate: KTF_Ads_Rewarded_SupportDelegate?
    var interAd: KTF_Ads_Inter_Support!


    func preloadRewardAds(myView: UIViewController) {
    
        KTF_Ads_Rewarded_Support.rewardedAdsPointer = KTF_Ads_Rewarded_Support.init(myView: myView)
    }
    
    convenience init(myView: UIViewController) {
        self.init()
        KTF_Ads_Rewarded_Support.myRewardedViewController = myView as! GameViewController
        KTF_Ads_Rewarded_Support.adRewardedView = GADRewardBasedVideoAd.sharedInstance()
        
        KTF_Ads_Rewarded_Support.adRewardedView.delegate = self
        
        KTF_Ads_Rewarded_Support.adRewardedView.load(KTF_Ads_Sub_Class().loadAdRequest(), withAdUnitID: KTF_Ads_Sub_Class().getAdUnitID(adsType: KTF_Ads_Type.KTF_Ads_Type_Rewarded))
    }

    func presentRewardAdFor(scene:SKScene) -> KTF_Ads_Rewarded_Support
    {
       if KTF_Ads_Rewarded_Support.adRewardedView.isReady
        {
            KTF_Ads_Rewarded_Support.adRewardedView.present(fromRootViewController: KTF_Ads_Rewarded_Support.myRewardedViewController)
       }
        else
        {
            KTF_Ads_Rewarded_Support.rewardedAdsPointer?.reloadRewardedAd()
            interAd = KTF_Ads_Inter_Support().presentInterAds()
            interAd.delegate = scene as? KTF_Ads_Inter_SupportDelegate
        }
        return KTF_Ads_Rewarded_Support.rewardedAdsPointer!
    }
     
    func reloadRewardedAd()
    {
      let tempView = KTF_Ads_Rewarded_Support.myRewardedViewController
        KTF_Ads_Rewarded_Support.myRewardedViewController = nil
        KTF_Ads_Rewarded_Support.rewardedAdsPointer = nil
        KTF_Ads_Rewarded_Support.adRewardedView = nil
        KTF_Ads_Rewarded_Support().preloadRewardAds(myView: tempView!)
    }
    
    //OVERRIDE METHODS
   func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didFailToLoadWithError error: Error) {
       print("REWARD - FAIL TO LOAD")

    }
    func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
       print("REWARD - RECEIVE AD")

    }
    func rewardBasedVideoAdDidOpen(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
       print("REWARD - AD OPEN")

    }
    func rewardBasedVideoAdDidStartPlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
  print("REWARD - AD START PLAY")

    }
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWith reward: GADAdReward) {
        delegate?.rewardedFinishSuccessfuly()
        print("USER RECEIVED REWARD")
    }
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
       delegate?.rewardedAdClosed()
        print("REWARD - AD CLOSED")
    }
}
    
    
class KTF_Ads_Sub_Class
{
    /////////////////////////////////// GENERAL METHODS /////////////////////////////////////
    //GET ADS UNIT ID
    func getAdUnitID(adsType:KTF_Ads_Type) -> String {
        
        let adTypeIndex = adsType.rawValue
        let adsID: String!
        
        switch adTypeIndex {
        case KTF_Ads_Type.KTF_Ads_Type_Banner.rawValue:
            if KTF_DeviceType().isiPhone()
            {
                adsID = AdmobKeys().iPHONE_ID()
            }
            else
            {
                adsID = AdmobKeys().iPAD_ID()
            }
            break
        case KTF_Ads_Type.KTF_Ads_Type_Inter.rawValue:
            adsID = AdmobKeys().INTER_ID()
            break
        case KTF_Ads_Type.KTF_Ads_Type_Rewarded.rawValue:
            adsID = AdmobKeys().REWARDED_ID()
            break
            
        default:
            if KTF_DeviceType().isiPhone()
            {
                adsID = AdmobKeys().iPHONE_ID()
            }
            else
            {
                adsID = AdmobKeys().iPAD_ID()
            }
        }
        
        
        return adsID
    }
    
    // LOADS AD REQUEST INCLUDING TEST DEVICES
    func loadAdRequest() -> GADRequest{
        
        let request = GADRequest()
      
        #if DEBUG

        request.testDevices = ["acc8f37f622185236d1f09abd03f2b5d",
                               "df9dfa5edaf80f86ba79f3ad4b8787d9",
                               "9f7ea1062afad6bf37c91212c5e228c4159e26a6",
                               "461383f79e6c870f0b8ff22d30d1368b",
                               "b0438b8c5bcb180bc6e70a0590e9bf01"]
            #endif
            return request
    }
    
}
