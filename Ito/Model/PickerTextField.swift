//
//  PickerTextField.swift
//  Ito
//
//  Created by 二宮啓 on 2020/04/03.
//  Copyright © 2020 二宮啓. All rights reserved.
//

import UIKit

class PickerTextField: UITextField, UIPickerViewDelegate, UIPickerViewDataSource {
   
    
    var dataList = [String]()


    func setup(dataList: [String]) {
        self.dataList = dataList

        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self

        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: Selector(("done")))
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(Progress.cancel))
        toolbar.setItems([cancelItem, doneItem], animated: true)

        self.inputView = picker
        self.inputAccessoryView = toolbar
    }

     func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
       }

    // UIPickerViewの行数、要素の全数
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return dataList.count
    }

    // UIPickerViewに表示する配列
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        
        return dataList[row]
    }

    // UIPickerViewのRowが選択された時の挙動
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        self.text = dataList[row]
    }
    func cancel() {
        self.endEditing(true)
    }

    func done() {
        self.endEditing(true)
    }
}
