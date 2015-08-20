//
//  TimelineCell.swift
//  SwiftyTwitterClient
//
//  Created by yuichiro_t on 2015/08/16.
//  Copyright (c) 2015年 yuichiro_t. All rights reserved.
//

import UIKit

class TimelineCell: UITableViewCell {
  
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var screenNameLabel: UILabel!
  @IBOutlet weak var tweeTextLabel: UILabel!
  @IBOutlet weak var userIcon: UIImageView!
  
  var tweet: Tweet? {
    didSet {
      setTweetData()
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  // MARK: - private method
  private func setTweetData() {
    let defaultStr = "hogehoge"
    userNameLabel.text = tweet?.userName ?? defaultStr
    screenNameLabel.text = "@\(tweet?.screenName ?? defaultStr)"
    tweeTextLabel.text = tweet?.tweet ?? defaultStr
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
      let url = NSURL(string: self.tweet?.userIconUrl ?? "")
      let imageData = NSData(contentsOfURL: url!)
      
      dispatch_async(dispatch_get_main_queue()) {
        self.userIcon.image = UIImage(data: imageData!)
      }
    }
  }
}
