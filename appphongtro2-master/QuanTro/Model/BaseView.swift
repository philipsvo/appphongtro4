//
//  BaseView.swift
//  QuanTro
//
//  Created by vuminhtam on 4/18/19.
//  Copyright © 2019 Le Nguyen Quoc Cuong. All rights reserved.
//

import Foundation
import UIKit
extension UIImageView
{
    // trong bai 12 app chat co nha
    func loadavatar(link:String)  {
        
        let queue:DispatchQueue = DispatchQueue(label: "loadimage", attributes: DispatchQueue.Attributes.concurrent,target: nil)
        
        let activity:UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        // tao ra 1 cai xoay xoay
        activity.frame = CGRect(x: self.frame.size.width/2, y: self.frame.size.height/2, width: 0, height: 0)
        activity.color = UIColor.blue
        // gan xoay xoay vao trong tam hinh
        self.addSubview(activity)
        queue.async {
            // lay link cua tam hinh
            let url:URL = URL(string: link)!
            do
            {
                // lay du lieu ve
                let data:Data = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    // dung viec xoay xoay lai
                    activity.stopAnimating()
                    // hien thi tam hinh ra
                    self.image = UIImage(data: data)
                }
                
            }
            catch
            {
                // dung viec xoay xoay lai
                DispatchQueue.main.async {
                    activity.stopAnimating()
                }
                print("loi load hinh avatar")
            }
        }
        activity.startAnimating()
        
    }
}

