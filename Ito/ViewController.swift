//
//  ViewController.swift
//  Ito
//
//  Created by 二宮啓 on 2020/04/03.
//  Copyright © 2020 二宮啓. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var friends:[Friend] = []
    
    @IBOutlet var table:UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        table.delegate = self
        table.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell :UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let userImageView = cell.viewWithTag(1) as! UIImageView
        userImageView.image = friends[indexPath.row].userImage
        let nameLabel = cell.viewWithTag(2) as! UILabel
        nameLabel.text = friends[indexPath.row].userName
        let lastDateLabel = cell.viewWithTag(3) as! UILabel
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.string(from: friends[indexPath.row].lastDate)
        lastDateLabel.text = formatter.string(from: friends[indexPath.row].lastDate)
        return cell
    }
    

}

