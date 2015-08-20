//
//  ViewController.swift
//  SwiftyTwitterClient
//
//  Created by yuichiro_t on 2015/08/16.
//  Copyright (c) 2015年 yuichiro_t. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

  @IBOutlet weak var userImageView: UIImageView!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var userScreenNameLabel: UILabel!
  @IBOutlet weak var tweetLabel: UILabel!
  
  var tweet: Tweet?

  // MARK: - life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setTweetData()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - private method
  private func setTweetData() {
    userNameLabel.text = tweet?.userName
    userScreenNameLabel.text = tweet?.screenName
    tweetLabel.text = tweet?.tweet
    
    // クラス or メソッドに切り分けるべき？
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
      let url = NSURL(string: self.tweet?.userIconUrl ?? "")
      let imageData = NSData(contentsOfURL: url!)
      
      dispatch_async(dispatch_get_main_queue()) {
        self.userImageView.image = UIImage(data: imageData!)
      }
    }
  }
}

