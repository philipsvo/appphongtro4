//
//  Screen_Tabar_ChitietPhong.swift
//  QuanTro
//
//  Created by Flint Pham on 5/10/19.
//  Copyright © 2019 Le Nguyen Quoc Cuong. All rights reserved.
//

import UIKit
import TextFieldEffects

class Screen_Tabar_ChitietPhong: UIViewController {

    @IBOutlet weak var tenPhong: AkiraTextField!
    @IBOutlet weak var dienTich: AkiraTextField!
    @IBOutlet weak var giaPhong: AkiraTextField!
    @IBOutlet weak var toiDa: AkiraTextField!
    @IBOutlet weak var moTa: AkiraTextField!
    @IBOutlet weak var diaChi: AkiraTextField!
    
    var chitietPhong: Chitietphong!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Thông tin phòng trọ"
        
        tenPhong.text = chitietPhong.tenphong
        dienTich.text = chitietPhong.dientich
        giaPhong.text = String.init(format: "%d", chitietPhong.gia!)
        toiDa.text = String.init(format: "%d", chitietPhong.songuoitoida!)
        moTa.text = chitietPhong.motaphong
        diaChi.text = chitietPhong.diachi
        // Do any additional setup after loading the view.
    }
}
