//
//  ElectricWaterViewController.swift
//  QuanTro
//
//  Created by Flint Pham on 5/27/19.
//  Copyright © 2019 Le Nguyen Quoc Cuong. All rights reserved.
//

import UIKit
import TextFieldEffects

class ElectricWaterViewController: UIViewController {

    @IBOutlet weak var ngayGhi: AkiraTextField!
    @IBOutlet weak var dienThangTruoc: AkiraTextField!
    @IBOutlet weak var dienThangNay: AkiraTextField!
    @IBOutlet weak var tienDien: AkiraTextField!
    @IBOutlet weak var nuocThangTruoc: AkiraTextField!
    @IBOutlet weak var nuocThangNay: AkiraTextField!
    @IBOutlet weak var tienNuoc: AkiraTextField!
    @IBOutlet weak var btnThanhToan: UIButton!
    
    var datePicker:UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 200))
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "vi")
        
        btnThanhToan.layer.masksToBounds = true
        btnThanhToan.layer.borderWidth = 1.0
        btnThanhToan.layer.borderColor = UIColor.red.cgColor
        
        dienThangTruoc.delegate = self
        dienThangNay.delegate = self
        nuocThangTruoc.delegate = self
        nuocThangNay.delegate = self
        ngayGhi.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ngayGhi.becomeFirstResponder()
        ngayGhi.resignFirstResponder()
        if (userDefault.string(forKey: "ngayGhi") != nil) && (userDefault.string(forKey: "dienThangTruoc") != nil) && (userDefault.string(forKey: "nuocThangTruoc") != nil) {
            ngayGhi.text = userDefault.string(forKey: "ngayGhi")
            dienThangTruoc.text = userDefault.string(forKey: "dienThangTruoc")
            nuocThangTruoc.text = userDefault.string(forKey: "nuocThangTruoc")
        }
        else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            ngayGhi.text = dateFormatter.string(from: datePicker.date)
        }
    }
    
    private func setupToolBar()->UIToolbar{
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 199/255, green: 90/255, blue: 90/255, alpha: 1)
        toolBar.sizeToFit()
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Chọn", style: .plain, target: self, action: #selector(self.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Huỷ", style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
    
    private func tinhTienDien(soDien: Double) -> Double {
        var money: Double = 0.0
        if soDien<51 {
            money = soDien*1678.0
        }
        else if soDien<101 {
            money = 50*1678.0+(soDien-50.0)*1734.0
        }
        else if soDien < 201 {
            money = 50*1678.0 + 50*1734.0 + (soDien-100)*2014
        }
        else if soDien<301 {
            let subMoney: Double = 50*1678.0+50*1734.0+100*2014
            money = subMoney+(soDien-200)*2536
        }
        else if soDien<401 {
            let subMoney: Double = 50*1678.0+50*1734.0+100*2014+100*2536
            money = subMoney+(soDien-300)*2834
        }
        else {
            let subMoney: Double = 50*1678.0+50*1734.0+100*2014+100*2536+100*2834
            money = subMoney+(soDien-400)*2927
        }
        return money
    }
    private func tinhTienNuoc(soNuoc: Double) -> Double {
        var money: Double = 0
        if soNuoc <= 4 {
            money = soNuoc*6095
        }
        else if soNuoc > 4 && soNuoc <= 6 {
            money = 4*6095 + (soNuoc-4)*11730
        }
        else {
            money = 4*6095 + 2*11730 + (soNuoc-6)*13110
        }
        return money
    }
    
    
    @IBAction func NgayGhiBeginEditing(_ sender: Any) {
        ngayGhi.inputView = datePicker
        ngayGhi.inputAccessoryView = setupToolBar()
    }
    
    @IBAction func TapGesture(_ sender: Any) {
        ngayGhi.resignFirstResponder()
        dienThangTruoc.resignFirstResponder()
        dienThangNay.resignFirstResponder()
        nuocThangTruoc.resignFirstResponder()
        nuocThangNay.resignFirstResponder()
    }
    
    @IBAction func didTapThanhToan(_ sender: Any) {
        if tienDien.text!.isEmpty || tienNuoc.text!.isEmpty {
            let alert = UIAlertController.init(title: "Thông báo", message: "Xin hãy điền đầy đủ thông tin hợp lệ", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "Đóng", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        else {
            let alert = UIAlertController.init(title: "Thành công", message: "Bạn đã thu phí tiền điện nước", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "Đóng", style: .default, handler: nil))
            self.present(alert, animated: true) {
                userDefault.set(self.ngayGhi.text!, forKey: "ngayGhi")
                userDefault.set(self.dienThangNay.text!, forKey: "dienThangTruoc")
                userDefault.set(self.nuocThangNay.text!, forKey: "nuocThangTruoc")
            }
            return
        }
    }
    
    @objc func doneClick(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        switch true {
        case ngayGhi.isEditing:
            ngayGhi.text = dateFormatter.string(from: datePicker.date)
            break
        default:
            break
        }
        cancelClick()
        
    }
    
    @objc func cancelClick(){
        ngayGhi.resignFirstResponder()
        dienThangNay.resignFirstResponder()
        dienThangTruoc.resignFirstResponder()
        tienDien.resignFirstResponder()
        nuocThangNay.resignFirstResponder()
        nuocThangTruoc.resignFirstResponder()
        tienNuoc.resignFirstResponder()
    }
    
}

extension ElectricWaterViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if ngayGhi.text!.isEmpty == false {
            if !dienThangTruoc.text!.isEmpty && !dienThangNay.text!.isEmpty {
                let dienTruoc: Double = NumberFormatter().number(from: dienThangTruoc.text!)!.doubleValue
                let dienNay: Double = NumberFormatter().number(from: dienThangNay.text!)!.doubleValue
                let tienD: Double = tinhTienDien(soDien: (dienNay-dienTruoc))
                if dienNay > dienTruoc {
                    tienDien.text = String.init(format: "%.0f", tienD)
                }
                else {
                    tienDien.text = ""
                }
            }
            else {
                tienDien.text = ""
            }
            
            if !nuocThangTruoc.text!.isEmpty && !nuocThangNay.text!.isEmpty {
                let nuocTruoc: Double = NumberFormatter().number(from: nuocThangTruoc.text!)!.doubleValue
                let nuocNay: Double = NumberFormatter().number(from: nuocThangNay.text!)!.doubleValue
                let tienN: Double = tinhTienNuoc(soNuoc: (nuocNay-nuocTruoc))
                if nuocNay > nuocTruoc {
                    tienNuoc.text = String.init(format: "%.0f", tienN)
                }
                else {
                    tienNuoc.text = ""
                }
            }
            else {
                tienNuoc.text = ""
            }
        }
        else {
            return
        }
    }
}
