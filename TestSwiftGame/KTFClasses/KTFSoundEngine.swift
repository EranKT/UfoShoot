//
//  KTGSoundEngine.swift
//  TestSwiftGame
//
//  Created by EKT DIGIDESIGN on 12/15/17.
//  Copyright © 2017 EKT DIGIDESIGN. All rights reserved.
//

import Foundation
import AVFoundation
import SpriteKit

// TO PLAY SFX:
//   audio.playSound(fileName: "smily_sfx")
//OR (for sequence action)//    _learnButton.run(audio.playSound(fileName: "smily_sfx")!)


class KTF_Sound_Engine: NSObject {
    
   static var player: AVAudioPlayer!
    
 //<<<<< PLAY SFX
    
    func playSound(fileName:String)
    {
        self.playSoundWithVolume(fileName: fileName, volume: 1.0)
    }
    
    func playSoundWithVolume(fileName:String, volume: Float) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") else { return }
     //   print(url)
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            KTF_Sound_Engine.player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            guard let player = KTF_Sound_Engine.player else { return }
            player.volume = volume
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    

    
    func stopSound(pointer:KTF_Sound_Engine) {
        if KTF_Sound_Engine.player != nil{
            KTF_Sound_Engine.player?.stop()
            KTF_Sound_Engine.player = nil
        }
    }
   //>>>> PLAY SFX
    
}

/* TO USE:
 //create Instance
 let audio = KTF_MusicPlayer.sharedInstance()

 //to play the file:
 audio.playMusic("bg_music")

 //to stop the file:
 audio.stopMusic()

 //to play sfx on a sprite:
 sunNode.run(audio.playSound(fileName: "smily_sfx")!)

 
 */
//<<< PLAY BG MUSIC
/**Manages a shared instance of KTF_MusicPlayer.*/
private let KTF_MusicPlayer_Instance = KTF_MusicPlayer()

/**Provides an easy way to play sounds and music. Use sharedInstance method to access a single object for the entire game to manage the sound and music.*/
public class KTF_MusicPlayer {
    
    /**Used to access music.*/
    var musicPlayer: AVAudioPlayer!
    
    /** Allows the audio to be shared with other music (such as music being played from your music app). If this setting is false, music you play from your music player will stop when this app's music starts. Default set by Apple is false. */
    static var canShareAudio = false {
        didSet {
            canShareAudio ? try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient) : try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategorySoloAmbient)
        }
    }
    
    /**Creates an instance of the JAAudio class so the user doesn't have to make their own instance and allows use of the functions. */
    public class func sharedInstance() -> KTF_MusicPlayer {
        return KTF_MusicPlayer_Instance
    }
    
    /**Plays music. You can ignore the "type" property if you include the full name with extension in the "filename" property. Set "canShareAudio" to true if you want other music to be able to play at the same time (default by Apple is false).*/
    public func playMusic(fileName: String, withExtension type: String = "m4a") {
       
        if let url = Bundle.main.url(forResource: fileName, withExtension: type) {
   musicPlayer = try? AVAudioPlayer(contentsOf: url)
            musicPlayer.numberOfLoops = -1
            musicPlayer.prepareToPlay()
            musicPlayer.play()
 }
    }
    
    func setMusicVolume(volume:Float) {
        self.setMusicVolumeWithFade(volume: volume, fadeDuration: 0.01)
    }
    
    func setMusicVolumeWithFade(volume: Float, fadeDuration:TimeInterval) {
        if #available(iOS 10.0, *) {
            musicPlayer.setVolume(volume, fadeDuration: fadeDuration)
        } else {
            // Fallback on earlier versions
            musicPlayer.volume = volume
        }
    }
    /**Stops the music. Use the "resumeMusic" method to turn it back on. */
    public func stopMusic() {
        if musicPlayer != nil && musicPlayer!.isPlaying {
            musicPlayer.currentTime = 0
            musicPlayer.stop()
        }
    }
    
    /**Pauses the music. Use the "resumeMusic" method to turn it back on. */
    public func pauseMusic() {
        if musicPlayer != nil && musicPlayer!.isPlaying {
            musicPlayer.pause()
        }
    }
    
    /**Resumes the music after being stopped or paused. */
    public func resumeMusic() {
        if musicPlayer != nil && !musicPlayer!.isPlaying {
            musicPlayer.play()
        }
    }
    
    /**Plays a sound only once. Must be used inside a runAction(...) method.*/
    public func playSound(fileName: String) -> SKAction? {
        return SKAction.playSoundFileNamed(fileName, waitForCompletion: false)
    }
}
//>>> PLAY BG MUSIC
