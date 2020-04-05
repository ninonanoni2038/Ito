//
//  CustomTextField.swift
//  Ito
//
//  Created by 二宮啓 on 2020/04/05.
//  Copyright © 2020 二宮啓. All rights reserved.
//


import UIKit

class CustomTextField: UITextField {

    private let padding: CGFloat = 8

    //入力したテキストの余白
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding))
    }

    //編集中のテキストの余白
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding))
    }

    //プレースホルダーの余白
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding))
    }
}
