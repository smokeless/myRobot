//
//  ViewController.swift
//  myRobot
//
//  Created by Ross Russell on 4/20/16.
//  Copyright © 2016 com.orangemelt. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
  @IBOutlet weak var monsterImg: MonsterImg!
  @IBOutlet weak var foodImg: DragImg!
  @IBOutlet weak var heartImg: DragImg!
  
  @IBOutlet weak var penalty1: UIImageView!
  
  @IBOutlet weak var penalty2: UIImageView!
  
  @IBOutlet weak var penalty3: UIImageView!
  
  
  let DIM_ALPHA:CGFloat = 0.2
  let OPAQUE: CGFloat = 1.0
  let MAX_PENALTY = 3
  let NEEDY:Double = 10.0
  var penalties = 0
  var timer: NSTimer!
  var monsterHappy = false
  var currentItem:UInt32 = 0
  
  //adding sfx
  var musicPlayer: AVAudioPlayer!
  var sfxBite: AVAudioPlayer!
  var sfxHeart: AVAudioPlayer!
  var sfxDeath: AVAudioPlayer!
  var sfxSkull: AVAudioPlayer!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    foodImg.dropTarget = monsterImg
    heartImg.dropTarget = monsterImg
    penalty1.hidden = false
    penalty2.hidden = false
    penalty3.hidden = false
    penalty1.alpha = DIM_ALPHA
    penalty2.alpha = DIM_ALPHA
    penalty3.alpha = DIM_ALPHA
    
    
    NSNotificationCenter.defaultCenter().addObserver( self, selector: #selector(ViewController.itemDroppedOnCharacter(_:)), name: "onTargetDropped", object: nil)
    
    do {
      try musicPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("music", ofType: "mp3" )!))
    
      try sfxBite = AVAudioPlayer(contentsOfURL: NSURL( fileURLWithPath: NSBundle.mainBundle().pathForResource("Robot_blip1", ofType: "wav")!))
      try sfxHeart = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("robot_blip2", ofType: "wav")!))
      try sfxDeath = AVAudioPlayer( contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("robodeath", ofType: "wav")!))
      try sfxSkull = AVAudioPlayer(contentsOfURL: NSURL( fileURLWithPath: NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!))
      
      musicPlayer.prepareToPlay()
      musicPlayer.play()
      sfxSkull.prepareToPlay()
      sfxDeath.prepareToPlay()
      sfxHeart.prepareToPlay()
      sfxBite.prepareToPlay()
      
    } catch let err as NSError{
      print(err.debugDescription)
    }
    
    startTime()
    
  }
  
  func itemDroppedOnCharacter( notif: AnyObject ){
    monsterHappy = true
    startTime()
    foodImg.alpha = DIM_ALPHA
    foodImg.userInteractionEnabled = false
    heartImg.alpha = DIM_ALPHA
    heartImg.userInteractionEnabled = false
    if currentItem == 0 {
      sfxHeart.play()
    } else {
      sfxBite.play()
    }
}
  
  
  
  func startTime(){
    if timer != nil{
      timer.invalidate()
    }
    timer = NSTimer.scheduledTimerWithTimeInterval(NEEDY, target: self, selector: #selector(ViewController.changeGameState), userInfo: nil, repeats: true)
  }
  
  
  
  
  
  func changeGameState(){
    
    if !monsterHappy{
      penalties += 1
      sfxSkull.play()
      if penalties == 1 {
        penalty1.alpha = OPAQUE
        penalty2.alpha = DIM_ALPHA
      }else if penalties == 2{
        penalty2.alpha = OPAQUE
        penalty3.alpha = DIM_ALPHA
      }else if penalties >= 3{
        penalty3.alpha = OPAQUE
      }else{
        penalty1.alpha = DIM_ALPHA
        penalty2.alpha = DIM_ALPHA
        penalty3.alpha = DIM_ALPHA
      }
    }
    
    
    if penalties >= MAX_PENALTY{
      gameOver()
    }
    
    let rand = arc4random_uniform(2) // 0 or 1
    if rand == 0 {
      foodImg.alpha = DIM_ALPHA
      foodImg.userInteractionEnabled = false
      
      heartImg.alpha = OPAQUE
      heartImg.userInteractionEnabled = true
    } else {
      heartImg.alpha = DIM_ALPHA
      heartImg.userInteractionEnabled = false
      foodImg.alpha = OPAQUE
      foodImg.userInteractionEnabled = true
    }
    currentItem = rand
    monsterHappy = false
  }
  func gameOver(){
    timer.invalidate()
    monsterImg.playDeathAnimation()
    sfxDeath.play()
  }
  
  
}

