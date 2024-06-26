//
//  ConfigureView.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/4/15.
//  Copyright © 2020 李京珂. All rights reserved.
//

import UIKit

protocol ConfigureViewDelegate: NSObjectProtocol {
    func valueChanged<T>(sender: T)
}

class ConfigureView: UIScrollView {
    @IBOutlet var showTakePhotoBtnSwitch: UISwitch!

    @IBOutlet var sortAscendingSwitch: UISwitch!

    @IBOutlet var allowPickingVideoSwitch: UISwitch!

    @IBOutlet var allowPickingOriginalPhotoSwitch: UISwitch!

    @IBOutlet var allowPickingImageSwitch: UISwitch!

    @IBOutlet var allowPickingGifSwitch: UISwitch!

    @IBOutlet var showSheetSwitch: UISwitch!

    @IBOutlet var maxCountTF: UITextField!

    @IBOutlet dynamic var columnNumberTF: UITextField!

    @IBOutlet var allowCropSwitch: UISwitch!

    @IBOutlet var allowPickingMuitlpleVideoSwitch: UISwitch!

    @IBOutlet var needCircleCropSwitch: UISwitch!

    @IBOutlet var showTakeVideoBtnSwitch: UISwitch!

    @IBOutlet var showSelectedIndexSwitch: UISwitch!

    weak var eventDelegate: ConfigureViewDelegate?

    var observation: NSKeyValueObservation?

    @objc dynamic var name: String?

    override func awakeFromNib() {
        super.awakeFromNib()

        maxCountTF.text = "9"
        columnNumberTF.text = "4"

        // 对maxCountTF添加观察者
//        maxCountTF.addObserver(self, forKeyPath: "text", options: [.old, .new], context: nil)

        observation = maxCountTF.observe(\.text, options: [.old, .new], changeHandler: { ob, changed in
            print(ob)
            print(changed)
        })

        for subView in subviews[0].subviews {
            if let view = subView as? UISwitch {
                view.addTarget(self, action: #selector(switchAction(sender:)), for: .valueChanged)
            }
            if let view = subView as? UITextField {
                view.delegate = self
                view.addTarget(self, action: #selector(textFieldAction(sender:)), for: .editingChanged)
            }
        }
    }

    // KVO方法
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if let change = change {
//            if let oldValue = change[.oldKey] as? String {
//                print("old Value:\(oldValue)")
//            }
//            if let newValue = change[.newKey] as? String {
//                print("new Value:\(newValue)")
//            }
//        }
//
//    }

    @objc private func switchAction(sender: UISwitch) {
        if sender == showTakePhotoBtnSwitch && sender.isOn {
            allowPickingImageSwitch.setOn(true, animated: true)
        }

        if sender == showTakeVideoBtnSwitch && sender.isOn {
            allowPickingVideoSwitch.setOn(true, animated: true)
        }

        if sender == showSheetSwitch && sender.isOn {
            allowPickingImageSwitch.setOn(true, animated: true)
        }

        if sender == allowPickingOriginalPhotoSwitch && sender.isOn {
            allowPickingImageSwitch.setOn(true, animated: true)
            needCircleCropSwitch.setOn(false, animated: true)
            allowCropSwitch.setOn(false, animated: true)
        }

        if sender == allowPickingImageSwitch && !sender.isOn {
            allowPickingOriginalPhotoSwitch.setOn(false, animated: true)
            allowPickingVideoSwitch.setOn(true, animated: true)
            allowPickingGifSwitch.setOn(false, animated: true)
        }

        if sender == allowPickingGifSwitch {
            if sender.isOn {
                allowPickingImageSwitch.setOn(true, animated: true)
            } else {
                allowPickingMuitlpleVideoSwitch.setOn(false, animated: true)
            }
        }

        if sender == allowPickingVideoSwitch && !sender.isOn {
            allowPickingImageSwitch.setOn(true, animated: true)
            if !allowPickingGifSwitch.isOn {
                allowPickingMuitlpleVideoSwitch.setOn(true, animated: true)
            }
        }

        if sender == allowCropSwitch {
            if sender.isOn {
                maxCountTF.text = "1"
                // 手动给textField赋值不会触发UIControl事件，所以要么用KVO要么手动调方法
                textFieldAction(sender: maxCountTF)
                allowPickingOriginalPhotoSwitch.setOn(false, animated: true)
            } else {
                if maxCountTF.text == "1" {
                    maxCountTF.text = "9"
                    textFieldAction(sender: maxCountTF)
                }
                needCircleCropSwitch.setOn(false, animated: true)
            }
        }

        if sender == needCircleCropSwitch && sender.isOn {
            allowCropSwitch.setOn(true, animated: true)
            maxCountTF.text = "1"
            textFieldAction(sender: maxCountTF)
            allowPickingOriginalPhotoSwitch.setOn(false, animated: true)
        }

        eventDelegate?.valueChanged(sender: sender)
    }

    @objc private func textFieldAction(sender: UITextField) {
        eventDelegate?.valueChanged(sender: sender)
    }
}

extension ConfigureView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
