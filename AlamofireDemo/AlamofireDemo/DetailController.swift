//
//  DetailController.swift
//  AlamofireDemo
//
//  Created by Andrew on 16/5/25.
//  Copyright © 2016年 Andrew. All rights reserved.
//

import UIKit
import Alamofire

class DetailController: UITableViewController {
    
    enum Sections:Int {
        case Headers,Body
    }

    var titleString:String?
    
    var request:Alamofire.Request?{
        didSet{
            oldValue?.cancel()
            
            title = request?.description
            refreshControl?.endRefreshing()
            headers.removeAll()
            body = nil
            elapsedTime = nil
        }
    }
    
    var headers: [String:String] = [:]
    var body: String?
    var elapsedTime: NSTimeInterval?
    
    static let numberFormatter:NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        return formatter
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.whiteColor()
        
        
        
        print("tableview.frame:\(self.tableView.frame)")
    }
    
   
    
     init(){
        super.init(style: .Grouped)
        refreshControl?.addTarget(self, action: #selector(refresh), forControlEvents: .ValueChanged);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        refresh()
    }
    
    func refresh() -> Void {
        guard let request = request else{
          return
        }
        refreshControl?.beginRefreshing()
        
        let start = CACurrentMediaTime();
        request.responseString { (response) in
            let end = CACurrentMediaTime()
            self.elapsedTime = end - start
            
            if let response = response.response{
                for (field, value) in response.allHeaderFields{
                 self.headers["\(field)"] = "\(value)"
                }
            }
            
            self.body = response.result.value
            
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
   
    }
}


//MARK: - UITableViewDataSource
extension DetailController{
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Sections(rawValue: section)! {
        case .Headers:
            return headers.count
        case .Body:
            return body == nil ? 0 : 1
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch Sections(rawValue:indexPath.section)! {
        case .Headers:
            var cell = tableView.dequeueReusableCellWithIdentifier("Header")
            
            if(cell==nil){
               cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "Header")
            }
            let field = headers.keys.sort(<)[indexPath.row]
            let value = headers[field]
            cell?.textLabel?.text = field
            cell?.detailTextLabel?.text = value
            return cell!
        case .Body:
             var cell = tableView.dequeueReusableCellWithIdentifier("Body")
             if(cell==nil){
                cell = UITableViewCell(style: .Default, reuseIdentifier: "Body")
             }
             cell!.textLabel?.text=body
            return cell!
       
     }
    }
}

//MARK: - UITableViewDelegate

extension DetailController{

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2;
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if self.tableView(tableView,numberOfRowsInSection: section)==0 {
           return ""
        }
        
        switch Sections(rawValue:section)! {
        case .Headers:
            return "Headers"
        case .Body:
            return "Body"
        }
    
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch Sections(rawValue:indexPath.section)! {
        case .Body:
            return 300
        default:
            return tableView.rowHeight
        }
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if Sections(rawValue: section) == .Body,let elapsedTime = elapsedTime{
         let elapsedTimeText = DetailController.numberFormatter.stringFromNumber(elapsedTime) ?? "???"
            
            return "耗费时间:\(elapsedTimeText)"
        }
        
        return ""
    }
    
    
    
}







