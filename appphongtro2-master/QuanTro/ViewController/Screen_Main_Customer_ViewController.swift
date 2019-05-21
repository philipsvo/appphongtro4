//
//  Screen_Main_Customer_ViewController.swift
//  QuanTro
//
//  Created by vuminhtam on 4/18/19.
//  Copyright © 2019 Le Nguyen Quoc Cuong. All rights reserved.
//

import UIKit
import Firebase
import PopupDialog

class Screen_Main_Customer_ViewController: UIViewController{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var avatar0: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//cell.avatar.loadavatar(link: currenUser.linkAvatar)
        avatar0.loadavatar(link: currenUser.linkAvatar)
        setupLeftButton()
    }
    
    func isLogOut()  {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    @IBAction func bt_chucnang_timkiem(_ sender: Any) {
        self.chucnang_timkiem()
    }
    
    @IBAction func bt_loguot_0(_ sender: Any) {
        let alert:UIAlertController = UIAlertController(title: "Bạn chắc chắn muốn đăng xuất !", message: "Xin chọn", preferredStyle: .alert)
        // tao ra 2 button
        let bt_1:UIAlertAction = UIAlertAction(title: "Đăng Xuất", style: .default) { (UIAlertAction) in
            // nho man hinh chinh truy cap den no
            self.isLogOut()
            self.navigationController?.popToRootViewController(animated: false)
        }
        let bt_2:UIAlertAction = UIAlertAction(title: "Huỷ", style: .cancel, handler: nil)
        
        alert.addAction(bt_1)
        alert.addAction(bt_2)
        self.present(alert, animated: true, completion: nil)
    }
    
    func chucnang_timkiem()  {
        let scr = storyboard?.instantiateViewController(withIdentifier: "MH_Customer_seach")
        navigationController?.pushViewController(scr!, animated: true)
    }
    
    func setupLeftButton(){
        let infoImage = UIImage(named: "logout")
        let imgWidth = infoImage?.size.width
        let imgHeight = infoImage?.size.height
        let button:UIButton = UIButton(frame: CGRect(x: 0,y: 0,width: imgWidth!, height: imgHeight!))
        button.setBackgroundImage(infoImage, for: .normal)
        button.addTarget(self, action: #selector(logOut), for: UIControl.Event.touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    @objc func logOut(){
        let alert = UIAlertController(title: "Đăng xuất", message: "Bạn chắc chắn muốn đăng xuất?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Có", style: .destructive, handler: { (action) in
            //            GIDSignIn.sharedInstance()?.signOut()
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            
            ListOfMotel.shared.removeAll()
            self.navigationController?.popViewController(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Không", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}
