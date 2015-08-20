//
//  TwitterManager.swift
//  SwiftyTwitterClient
//
//  Created by yuichiro_t on 2015/08/16.
//  Copyright (c) 2015年 yuichiro_t. All rights reserved.
//

import UIKit
import Social
import Accounts

typealias TweetJSON = [String: AnyObject]

// 結構ボリューミーだけどstructで良いのか・・？
struct Tweet {
  let tweetId: String
  let userName: String
  let screenName: String
  let tweet: String
  let userIconUrl: String
  let date: String
  
  init(json: TweetJSON) {
    let userData = json["user"] as? TweetJSON
    
    tweetId = json["id_str"] as? String ?? ""
    tweet = json["text"] as? String ?? ""
    date = json["created_at"] as? String ?? ""
    userName = userData?["name"] as? String ?? ""
    screenName = userData?["screen_name"] as? String ?? ""
    userIconUrl = userData?["profile_image_url"] as? String  ?? ""
  }
}

class TwitterManager {
  
  static let sharedManager = TwitterManager()
  
  private let accountStore = ACAccountStore()
  private let timelineUrl = "https://api.twitter.com/1.1/statuses/user_timeline.json"
  
  var updateTimelineHandler: () -> Void = {}
  
  var timeline: [Tweet]? {
    didSet {
      updateTimelineHandler()
    }
  }
  
  var account: ACAccount?
  
  // MARK: - initializer
  init() {
    setAccount()
  }
  
  // MARK: - twitter api
  func requestTimeline() {
    let url = NSURL(string: timelineUrl)
    
    let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .GET, URL: url, parameters: nil)
    request.account = account
    request.performRequestWithHandler { responseData, urlResponse, error in
      
      if let error = error {
        println("Error Something happend.")
        return
      }
      
      let tweetJSON = NSJSONSerialization.JSONObjectWithData(responseData, options: .AllowFragments, error: nil) as? [TweetJSON]
      
      dispatch_async(dispatch_get_main_queue()) {
        // tweetJSON.flatMap { $0.map { Tweet(json: $0) } } ← のほうが良い？？
        self.timeline = tweetJSON?.map { Tweet(json: $0) }
      }
    }
  }
  
  // MARK: - private method
  private func setAccount() {
    let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
    
    accountStore.requestAccessToAccountsWithType(accountType, options: nil) {
      granted, error in
      
      if let error = error {
        println("Error: \(error)")
        return
      }
      
      if granted == false {
        println("Error! Twitterアカウントの利用が許可されていません")
        return
      }
      
      let accounts = self.accountStore.accountsWithAccountType(accountType) as! [ACAccount]
      if accounts.count == 0 {
        println("Error! 設定画面からアカウントを設定してください")
        return
      }
      
      self.account = accounts[0]
    }
  }
  
}
