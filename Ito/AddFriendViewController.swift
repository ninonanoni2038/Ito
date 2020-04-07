//
//  AddFriendViewController.swift
//  Ito
//
//  Created by 二宮啓 on 2020/04/03.
//  Copyright © 2020 二宮啓. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class AddFriendViewController: UIViewController , UINavigationControllerDelegate {
    
    @IBOutlet var userImage:UIImageView!
    @IBOutlet var userNameTextField:CustomTextField!
    @IBOutlet var frequencyTextField:CustomTextField!
    // @IBOutlet var frequencyTextField:PickerTextField = PickerTextField()
    @IBOutlet var lastDayTextField:CustomTextField!
    
    //画像を表示するView
    @IBOutlet var userImageView:UIImageView!
    
    //画像とテキストを包含したView
    @IBOutlet var userImageBoxView:UIView!
    
    @IBOutlet var errorTextLabel:UILabel!
    
    //会う頻度を定義するためのPickerなど
    var frequencyPickerView = UIPickerView()
    let frequencyDataList = ["1週間に一度","2週間に一度","3週間に一度","1ヶ月に一度","2ヶ月に一度"]
    var frequencyIndex:Int = 0
    var nextDay :Int = 0
    var passedDay :Int = 0 //通知で何日たったかを表示するための変数
    
    //UIDatePickerを定義するための変数
    var datePicker: UIDatePicker = UIDatePicker()
    var lastDate: Date!
    
    //編集ボタンを押して画面遷移してきた時の値受け渡し用
    var editingFriend:Friend!
    var originalUserName:String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 通知許可ダイアログを表示
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("AddFriendVCの通知許可",granted)
            if granted == false{
                DispatchQueue.main.async {
                    
                    self.dismiss(animated: true)
                }
                
            }
        }
        
        
        
        setFrequencyPickerView(pickerView: frequencyPickerView, textField: frequencyTextField)
        setLastDayPickerView(datePicker: datePicker, textField: lastDayTextField)
        userNameTextField.delegate = self
        lastDayTextField.delegate = self
        
        setBorder(textField: userNameTextField)
        setBorder(textField: frequencyTextField)
        setBorder(textField: lastDayTextField)
        
        // タップを定義
        let tap = UITapGestureRecognizer(target: self, action: #selector(AddFriendViewController.viewTap))
        
        // viewにタップを登録
        self.userImageBoxView.addGestureRecognizer(tap)
        
        //編集モードの時に編集中の情報を表示する
        if editingFriend != nil{
            originalUserName = editingFriend.userName
            userNameTextField.text = editingFriend.userName
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy年MM月dd日"
            formatter.locale = Locale(identifier: "ja_JP")
            lastDayTextField.text = "\(formatter.string(from: editingFriend.lastDate))"
            lastDate = editingFriend.lastDate
            frequencyTextField.text = String(frequencyDataList[editingFriend.frequency])
            //Realmで取得したUIImageのデータサイズを90％カットする。
            let resizedImage = editingFriend.imagePhotos?.resized(withPercentage: 0.1)
            userImageView.image = resizedImage
        }
        
    }
    
}

//画像サイズを小さくする。
extension UIImage {
    //データサイズを変更する
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        return UIGraphicsImageRenderer(size: canvas, format: imageRendererFormat).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
}

//通知を用意する
extension AddFriendViewController{
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
        
        //今日を定義
        let now = Date()
        
        //最後に会った日が今日じゃなかった時の調整
        nextDay = passedDay - calcDateRemainder(firstDate: now, secondDate: lastDate)
        if nextDay <= 0{
            nextDay = 1
        }
        // 通知許可ダイアログを表示
        let center = UNUserNotificationCenter.current()

        // 通知内容の設定
        let content = UNMutableNotificationContent()
        
        content.title = NSString.localizedUserNotificationString(forKey: "そろそろ約束の頃合い…？", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "\(String(userName))とこの間遊んでから\(String(passedDay))日経ったよ", arguments: nil)
        content.sound = UNNotificationSound.default
        
        //let nextDayTimeInterval = nextDay * 86400
        let nextDayTimeInterval = nextDay * 1
        print("あやしみ",nextDayTimeInterval)
        
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

//modalを閉じた時にtableViewのデータを更新するためにpresentationControllerDidDismissを呼ぶ
extension AddFriendViewController {
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        guard let presentationController = presentationController else {
            return
        }
        presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
    }
}

//日付の差分を取る
extension AddFriendViewController {
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
}

//image変更について
extension AddFriendViewController:UIImagePickerControllerDelegate{
    /// viewをタップされた時の処理
    @objc func viewTap(sender: UITapGestureRecognizer){
        print("タップされました")
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let pickedImage = info[.originalImage] as! UIImage
        
        //pickerで取得したUIImageのサイズを90％カットする。
        let resizedImage = pickedImage.resized(withPercentage: 0.1)
        self.userImageView.image = resizedImage
        
        self.dismiss(animated: false)
    }
}

//Picker周り
extension AddFriendViewController:UIPickerViewDelegate,UIPickerViewDataSource ,UITextFieldDelegate{
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return frequencyDataList.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        let pickerLabel = UILabel()
        pickerLabel.textAlignment = NSTextAlignment.center
        pickerLabel.text = String(frequencyDataList[row])
        return pickerLabel
    }
    
    func setBorder(textField:UITextField){
        textField.borderStyle = .none
        textField.layer.cornerRadius = 8
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth  = 1
        textField.layer.masksToBounds = true
    }
    
    func setFrequencyPickerView(pickerView:UIPickerView,textField:UITextField){
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let toolbar = UIToolbar(frame: CGRect(x:0, y:0, width:0, height:35))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(AddFriendViewController.frequecyDone))
        toolbar.setItems([spacelItem, doneItem], animated: true)
        
        textField.inputView = pickerView
        textField.inputAccessoryView = toolbar
    }
    
    func setLastDayPickerView(datePicker:UIDatePicker,textField:UITextField){
        // datePicker設定
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = NSLocale(localeIdentifier: "ja_JP") as Locale
        
        // 決定バーの生成
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(AddFriendViewController.lastDayDone))
        toolbar.setItems([spacelItem, doneItem], animated: true)
        
        // インプットビュー設定(紐づいているUITextfieldへ代入)
        textField.inputView = datePicker
        textField.inputAccessoryView = toolbar
    }
    
    @objc func frequecyDone() {
        self.frequencyTextField.endEditing(true)
        self.frequencyTextField.text = String(frequencyDataList[frequencyPickerView.selectedRow(inComponent: 0)])
        frequencyIndex = frequencyPickerView.selectedRow(inComponent: 0)
    }
    
    @objc func lastDayDone() {
        self.lastDayTextField.endEditing(true)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        formatter.locale = Locale(identifier: "ja_JP")
        self.lastDayTextField.text = "\(formatter.string(from: datePicker.date))"
        
        lastDate = datePicker.date
    }
    
    
}


//値の保存
extension AddFriendViewController{
    
    @IBAction func save(){
        if userNameTextField.text != "" && frequencyTextField.text != "" && lastDayTextField.text != "" && userImageView.image != nil{
            //編集中と新規追加で挙動をわける
            if editingFriend != nil{
                let realm = try! Realm()
                try! realm.write {
                    let results = realm.objects(Friend.self).filter("userName == '\(originalUserName!)'").first
                    results?.userName = userNameTextField.text!
                    results?.frequency = frequencyIndex
                    results?.lastDate = lastDate
                    results?.imagePhotos = userImageView.image!
                }
                
                self.dismiss(animated: true, completion: nil)
                
            }else{
                let realm = try! Realm()
                
                let friend = Friend()
                friend.userName = userNameTextField.text!
                friend.frequency = frequencyIndex
                friend.lastDate = lastDate
                friend.imagePhotos = userImageView.image!
                try! realm.write {
                    realm.add(friend)
                }
                print(friend)
                createNotification(userName: friend.userName,frequencyIndex:friend.frequency  ,lastDate:friend.lastDate)
                
                self.dismiss(animated: true, completion: nil)
            }
            
        }else {
            errorTextLabel.text = "未入力、未選択の項目があります。"
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
