//
//  HopDong.swift
//  QuanTro
//
//  Created by Flint Pham on 5/22/19.
//  Copyright © 2019 Le Nguyen Quoc Cuong. All rights reserved.
//

import Foundation
class HopDong : Codable {
    var ngayLamHopDong : String?
    var ngayBatDauO : String?
    var ngayKetThucHopDong: String?
    var tenNguoiHopDong: String?
    var CMND: Double?
    var SDT: Double?
    var tienDatCoc: Double?
    
    init(ngayLamHopDong: String = "", ngayBatDauO: String = "", ngayKetThucHopDong: String = "", tenNguoiHopDong: String = "", CMND: Double = 0.0, SDT: Double = 0.0, tienDatCoc: Double = 0.0) {
        self.ngayLamHopDong = ngayLamHopDong
        self.ngayBatDauO = ngayBatDauO
        self.ngayKetThucHopDong = ngayKetThucHopDong
        self.tenNguoiHopDong = tenNguoiHopDong
        self.CMND = CMND
        self.SDT = SDT
        self.tienDatCoc = tienDatCoc
    }
}

