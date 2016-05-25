//
//  ViewController.swift
//  AlamofireDemo
//
//  Created by Andrew on 16/5/23.
//  Copyright © 2016年 Andrew. All rights reserved.
//

import UIKit
import Alamofire



class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var tableView:UITableView!
    var arrayData:Array<String>!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.whiteColor()
        self.title="Alamofire例子"
        initData()
        initTable()
    
        print("hello world");
        //Alamofire.request(.GET, "https://httpbin.org/get");
        
    }
    
    
    func initData() -> Void {
        arrayData=["Making a Request(GET)"]
    }
    
    func initTable() -> Void {
        tableView=UITableView(frame: CGRectMake(0, 64, ScreenWidth, ScreentHeight-64))
        tableView.delegate=self;
        tableView.dataSource=self;
        self.view.addSubview(tableView)
    }

}

extension ViewController{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId:String = "cellId"
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellId)
        if(cell == nil){
          cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
        }
        
        cell?.textLabel?.text=arrayData[indexPath.row]
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detail=DetailController()
        detail.titleString = arrayData[indexPath.row];
        
        func createRequest()->Request?{
          return Alamofire.request(.GET, "https://httpbin.org/get")
        }
        
        if let request = createRequest(){
            detail.request=request;
        }
        self.navigationController?.pushViewController(detail, animated: true)
    }
}

