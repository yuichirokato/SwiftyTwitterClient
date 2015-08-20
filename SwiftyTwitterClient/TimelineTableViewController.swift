//
//  TimelineTableViewController.swift
//  SwiftyTwitterClient
//
//  Created by yuichiro_t on 2015/08/16.
//  Copyright (c) 2015年 yuichiro_t. All rights reserved.
//

import UIKit

class TimelineTableViewController: UITableViewController {
  
  @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
  
  private let kCellIdentifier = "TimelineCell"
  private let kCellName = "TimelineCell"
  
  private let twitterManager = TwitterManager.sharedManager
  
  // MARK: - life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    twitterManager.updateTimelineHandler = { [unowned self] in
      self.tableView.reloadData()
      self.hideLadingIndicator()
    }
    
    initTableView()
    
    loadingIndicator.startAnimating()
    twitterManager.requestTimeline()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - table view data source
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return twitterManager.timeline?.count ?? 0
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as! TimelineCell
    let tweet = twitterManager.timeline?[indexPath.row]
    
    cell.tweet = tweet
    
    return cell
  }
  
  // MARK: - table view delegate
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let tweet = twitterManager.timeline?[indexPath.row]
    
    let vc = storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
    vc.tweet = tweet
    
    navigationController?.pushViewController(vc, animated: true)
  }
  
  // MARK: - private method
  private func initTableView() {
    tableView.registerNib(UINib(nibName: kCellName, bundle: nil), forCellReuseIdentifier: kCellIdentifier)
    
    // Cellの高さを自動計算
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 145
  }
  
  private func hideLadingIndicator() {
    loadingIndicator.stopAnimating()
    loadingIndicator.hidden = true
  }
}
