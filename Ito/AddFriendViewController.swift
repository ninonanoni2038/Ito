//
//  AddFriendViewController.swift
//  Ito
//
//  Created by 二宮啓 on 2020/04/03.
//  Copyright © 2020 二宮啓. All rights reserved.
//

import UIKit

class AddFriendViewController: UIViewController ,UIPickerViewDelegate,UIPickerViewDataSource ,UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var userImage:UIImageView!
    @IBOutlet var userNameTextField:CustomTextField!
    @IBOutlet var frequencyTextField:CustomTextField!
    // @IBOutlet var frequencyTextField:PickerTextField = PickerTextField()
    @IBOutlet var lastDayTextField:CustomTextField!
    
    //画像を表示するView
    @IBOutlet var userImageView:UIImageView!
    
    //画像とテキストを包含したView
    @IBOutlet var userImageBoxView:UIView!
    
    //会う頻度を定義するためのPicker
    var frequencyPickerView = UIPickerView()
    let frequencyDataList = ["1週間に一度","2週間に一度","3週間に一度","1ヶ月に一度","2ヶ月に一度"]
    
    //UIDatePickerを定義するための変数
    var datePicker: UIDatePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
    }
    
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
    
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[.originalImage] 

        
        self.dismiss(animated: false)
    }
    
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
    }
    
    @objc func lastDayDone() {
        self.lastDayTextField.endEditing(true)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        self.lastDayTextField.text = "\(formatter.string(from: datePicker.date))"
    }
    
    
    
    @IBAction func save(){
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
}
