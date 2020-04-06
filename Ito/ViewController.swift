//
//  ViewController.swift
//  Ito
//
//  Created by 二宮啓 on 2020/04/03.
//  Copyright © 2020 二宮啓. All rights reserved.
//

//参考にした記事→https://www.cloverfield.co.jp/2018/05/08/mac-5/（Realmに画像保存）
//参考にした記事→https://qiita.com/saku/items/29c7fa20a62cc2f366fa（画像丸く表示）
//参考にした記事→https://yuu.1000quu.com/use_ui_tap_gesture_recognizer（Viewタップ時のイベント）
//参考にした記事→https://qiita.com/fummicc1-sub/items/a30e3cbfbf1148b0ec84（modalのDismiss時のイベント）
//参考にした記事→https://qiita.com/wadaaaan/items/d75b67ef712d49b2399e（日付の差分）
//参考にした記事→https://qiita.com/tojo/items/3189867605d3b1c5816e（通知）
//参考にした記事→https://capibara1969.com/1391/（NavBarButton）
import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    var friends:Results<Friend>!
    
    @IBOutlet var table:UITableView!
    
    //会ったときに押すボタン
    var metBarButtonItem: UIBarButtonItem!
    
    //会う頻度に合わせた日付を宣言する変数（通知作成時に使用）
    var passedDay:Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
        
        // 複数選択を有効にする
        table.allowsMultipleSelection = true
        
        let realm = try! Realm()
        friends = realm.objects(Friend.self)
        table.reloadData()
        
        metBarButtonItem = UIBarButtonItem(title: "会った", style: .done, target: self, action: #selector(metBarButtonTapped))
        
        self.navigationItem.rightBarButtonItems = [metBarButtonItem]
        
        
    }
    
    
    
}

//modalを消した時の挙動
extension ViewController: UIAdaptivePresentationControllerDelegate {
    //画面遷移の挙動
    @IBAction func transitionToModalViewController() {
        let modalViewController = storyboard?.instantiateViewController(identifier: "ModalViewController") as! AddFriendViewController
        modalViewController.presentationController?.delegate = self
        present(modalViewController, animated: true, completion: nil)
    }
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        table.reloadData()
    }
}

//tableViewまわり
extension ViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell :UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        
        let userImageView = cell.viewWithTag(1) as! UIImageView
        userImageView.image = friends[indexPath.row].imagePhotos
        
        let nameLabel = cell.viewWithTag(2) as! UILabel
        nameLabel.text = friends[indexPath.row].userName
        
        let lastDateLabel = cell.viewWithTag(3) as! UILabel
        lastDateLabel.text = convertPassedDays(lastDate: friends[indexPath.row].lastDate)
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
    //cell選択時の挙動
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select - \(indexPath)")
        let cell = tableView.cellForRow(at: indexPath)
        let checkImageView = cell!.viewWithTag(4) as! UIImageView
        checkImageView.image = UIImage(named: "check")
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("deselect - \(indexPath)")
        let cell = tableView.cellForRow(at: indexPath)
        let checkImageView = cell!.viewWithTag(4) as! UIImageView
        checkImageView.image = UIImage(named: "uncheck")
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        table.isEditing = editing
    }

}

//いつ会ったかを表記する部分
extension ViewController{
    
    func resetTime(date: Date) -> Date {
        let calendar: Calendar = Calendar(identifier: .gregorian)
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)

        components.hour = 0
        components.minute = 0
        components.second = 0

        return calendar.date(from: components)!
    }
    
    func calcDateRemainder(firstDate: Date, secondDate: Date? = nil) -> Int{

        var retInterval:Double!
        let firstDateReset = resetTime(date: firstDate)

        if secondDate == nil {
            let nowDate: Date = Date()
            let nowDateReset = resetTime(date: nowDate)
            retInterval = firstDateReset.timeIntervalSince(nowDateReset)
        } else {
            let secondDateReset: Date = resetTime(date: secondDate!)
            retInterval = firstDate.timeIntervalSince(secondDateReset)
        }

        let ret = retInterval/86400

        return Int(floor(ret))  // n日
    }
    
    func convertPassedDays(lastDate:Date) -> String{
        let now = Date()
        let passedDays = calcDateRemainder(firstDate: now, secondDate: lastDate)
        var passedDaysText :String = "ついさっき"
        if passedDays == 0 {
            passedDaysText = "ついさっき"
        }else if passedDays <= 1{
            passedDaysText = "1日前"
        }else if passedDays <= 2{
            passedDaysText = "2日前"
        }else if passedDays <= 3{
            passedDaysText = "3日前"
        }else if passedDays <= 4{
            passedDaysText = "4日前"
        }else if passedDays <= 5{
            passedDaysText = "5日前"
        }else if passedDays <= 6{
            passedDaysText = "6日前"
        }else if passedDays <= 10{
            passedDaysText = "1週間前"
        }else if passedDays <= 17{
            passedDaysText = "2週間前"
        }else if passedDays <= 24{
            passedDaysText = "3週間前"
        }else if passedDays <= 45{
            passedDaysText = "1ヶ月前"
        }else if passedDays <= 75{
            passedDaysText = "2ヶ月前"
        }else if passedDays <= 105{
            passedDaysText = "2ヶ月前"
        }else{
            passedDaysText = "ずっと前"
        }
        
        return passedDaysText
    }
}

//metBarButtonを押した時の挙動（会った時に最後に会った日を更新する）
extension ViewController{
    
    @objc func metBarButtonTapped(){
        let realm: Realm = try! Realm()
        if table.indexPathsForSelectedRows != nil {
            for indexPathForSelectedRow in table.indexPathsForSelectedRows!{
                print(indexPathForSelectedRow)
                
                let selectedIndex = indexPathForSelectedRow[1]

                try! realm.write {
                    friends[selectedIndex].lastDate = Date()
                }
                createNotification(userName: friends[selectedIndex].userName, frequencyIndex: friends[selectedIndex].frequency, lastDate: friends[selectedIndex].lastDate)

                table.reloadData()
                                
                table.deselectRow(at: indexPathForSelectedRow, animated: true)
                let cell = table.cellForRow(at: indexPathForSelectedRow)
                let checkImageView = cell!.viewWithTag(4) as! UIImageView
                checkImageView.image = UIImage(named: "uncheck")
                print("deselectした")
            }
        }
        
        print("met")
        
        
    }
}

//通知を用意する
extension ViewController{
    func createNotification(userName:String!,frequencyIndex: Int, lastDate:Date){
        

        switch frequencyIndex {
        case 0:
            passedDay = 7
        case 1:
            passedDay = 14
        case 2:
            passedDay = 21
        case 3:
            passedDay = 30
        case 4:
            passedDay = 60
        default:
            passedDay = 0
        }
        
        // 通知許可ダイアログを表示
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            // エラー処理
        }
        // 通知内容の設定
        let content = UNMutableNotificationContent()

        content.title = NSString.localizedUserNotificationString(forKey: "そろそろ約束の頃合い…？", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "\(String(userName))とこの間遊んでから\(String(passedDay))日経ったよ", arguments: nil)
        content.sound = UNNotificationSound.default

        //let nextDayTimeInterval = passedDay * 86400
        let nextDayTimeInterval = passedDay * 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(nextDayTimeInterval), repeats: false)

        let request = UNNotificationRequest(identifier: "\(userName)", content: content, trigger: trigger)

        // 通知を登録
        center.add(request) { (error : Error?) in
            if error != nil {
                // エラー処理
            }
        }
        
    }
}
