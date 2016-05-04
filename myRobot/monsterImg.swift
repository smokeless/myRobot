//
//  monsterImg.swift
//  myRobot
//
//  Created by Ross Russell on 4/20/16.
//  Copyright © 2016 com.orangemelt. All rights reserved.
//

import Foundation
import UIKit

class MonsterImg: UIImageView {
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  required init?(coder aDecoder: NSCoder) {
    super.init( coder: aDecoder)
    playIdleAnimation()
  }
  //just giving uiimageview what it wants
  func playIdleAnimation(){
    var imgArray = [UIImage]()
    
    self.image = UIImage(named: "happy1" )
    self.animationImages = nil
    
    for var x = 1; x <= 2; x += 1 {
      let img = UIImage(named: "happy\(x)")
      imgArray.append(img!)
      self.animationImages = imgArray
      self.animationDuration = 0.8
      self.animationRepeatCount = 0
      self.startAnimating()
    }
  }
  
  func playDeathAnimation(){
    var imgArray = [UIImage]()
    
    self.image = UIImage(named: "dying4" )
    self.animationImages = nil
    
    for var x = 1; x <= 4; x += 1 {
      let img = UIImage(named: "dying\(x)")
      imgArray.append(img!)
      self.animationImages = imgArray
      self.animationDuration = 0.8
      self.animationRepeatCount = 1
      self.startAnimating()
  }
}
}