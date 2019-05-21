//
//  InformationViewController.swift
//  QuanTro
//
//  Created by Flint Pham on 5/19/19.
//  Copyright © 2019 Le Nguyen Quoc Cuong. All rights reserved.
//

import UIKit
import TextFieldEffects
import Firebase
import MobileCoreServices
import Kingfisher

class InformationViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var container: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var txtName: AkiraTextField!
    @IBOutlet weak var txtPhone: AkiraTextField!
    @IBOutlet weak var txtEmail: AkiraTextField!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var btnImage: UIButton!
    @IBOutlet weak var btnUpdateInfor: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    
    @objc var image: UIImage?
    @objc var lastChosenMediaType: String?
    
    let thongtin: Quanlythongtincanhan = Store.shared.userMotel.quanlythongtincanhan!
    let indicator: UIActivityIndicatorView = UIActivityIndicatorView.init(frame: CGRect(x: 0, y: 0, width: 75, height: 75))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpComponents()
        setData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setUpComponents() {
        // set up container view
        container.frame = CGRect(x: screenWidth/10, y: screenHeight/5-30, width: screenWidth*4/5, height: screenHeight*4/5-10)
        let originalWidth: CGFloat = container.bounds.width
        let originalHeight: CGFloat = container.bounds.height
        
        // set up lblTitle
        lblTitle.frame = CGRect(x: 10, y: 10, width: originalWidth-20, height: originalHeight/10)
        lblTitle.text = "Thông tin cá nhân"
        lblTitle.textAlignment = .center
        lblTitle.font = UIFont.systemFont(ofSize: 25.0, weight: .semibold)
        
        // set up lblName and txtName
        lblName.frame = CGRect(x: 10, y: lblTitle.frame.origin.x+lblTitle.bounds.height+40, width: originalWidth/3, height: 40)
        lblName.text = "Họ tên:"
        lblName.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
        lblName.textAlignment = .left
        
        txtName.frame = CGRect(x: lblName.frame.origin.x+lblName.bounds.width+10, y: lblName.frame.origin.y-10, width: originalWidth-lblName.bounds.width-10-20, height: 50)
        
        // set up lblPhone and txtPhone
        lblPhone.frame = CGRect(x: 10, y: lblName.frame.origin.y+lblName.bounds.height+15, width: originalWidth/3, height: 40)
        lblPhone.text = "Số điện thoại:"
        lblPhone.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
        lblPhone.textAlignment = .left
        
        txtPhone.frame = CGRect(x: lblPhone.frame.origin.x+lblPhone.bounds.width+10, y: lblPhone.frame.origin.y-10, width: originalWidth-lblName.bounds.width-10-20, height: 50)
        
        // set up lblEmail and txtEmail
        lblEmail.frame = CGRect(x: 10, y: lblPhone.frame.origin.y+lblPhone.bounds.height+15, width: originalWidth/3, height: 40)
        lblEmail.text = "Email:"
        lblEmail.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
        lblEmail.textAlignment = .left
        
        txtEmail.frame = CGRect(x: lblEmail.frame.origin.x+lblEmail.bounds.width+10, y: lblEmail.frame.origin.y-10, width: originalWidth-lblName.bounds.width-10-20, height: 50)
        
        // set up imgAvatar and btnImage
        imgAvatar.frame = CGRect(x: originalWidth/4, y: txtEmail.frame.origin.y+txtEmail.bounds.height+20, width: originalWidth/2, height: originalWidth/3)
        imgAvatar.image = UIImage.init(named: "person")
        imgAvatar.layer.masksToBounds = true
        imgAvatar.layer.borderColor = UIColor.blue.cgColor
        imgAvatar.layer.borderWidth = 1.0
        imgAvatar.layer.cornerRadius = 10.0
        
        btnImage.frame = imgAvatar.frame
        btnImage.setTitle("", for: .normal)
        
        // set up btnUpdateInfo
        btnUpdateInfor.frame = CGRect(x: originalWidth/2-originalWidth/6, y: imgAvatar.frame.origin.y+imgAvatar.bounds.height+35, width: originalWidth/3, height: 35)
        btnUpdateInfor.setTitle("Cập nhật", for: .normal)
        btnUpdateInfor.titleLabel!.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
        btnUpdateInfor.backgroundColor = UIColor.orange
        
        // set up btnCLose
        btnClose.frame = CGRect(x: originalWidth-30, y: 0, width: 30, height: 30)
        btnClose.backgroundColor = UIColor.lightGray
        btnClose.setTitle("X", for: .normal)
        btnClose.setTitleColor(UIColor.white, for: .normal)
    }
    
    private func showActionSheet(){
        let actionSheet = UIAlertController(title: "Chọn ảnh", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Thư viện ảnh", style: .default, handler: { (action) in
            self.pickMediaFromSource(UIImagePickerController.SourceType.photoLibrary)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Chụp ảnh", style: .default, handler: { (action) in
            self.pickMediaFromSource(UIImagePickerController.SourceType.camera)
        }))
        actionSheet.addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    private func setData() {
        txtName.text = thongtin.ten
        txtPhone.text = thongtin.sdt
        txtEmail.text = thongtin.email
        let urlAvatar: URL = URL.init(string: thongtin.linkAvatar!)!
        imgAvatar.kf.setImage(with: urlAvatar)
    }
    
    private func handleUpdateUserInfo(linkAva: String) {
        let NewInfo: Quanlythongtincanhan = Quanlythongtincanhan.init(email: txtEmail.text!, linkAvatar: linkAva, quyen: thongtin.quyen!, sdt: txtPhone.text!, ten: txtName.text!)
        
        Store.shared.userMotel.quanlythongtincanhan = NewInfo
        
        let uid = Auth.auth().currentUser?.uid
        
        let data: [String:Any] = [
            "Email": NewInfo.email!,
            "LinkAvatar": NewInfo.linkAvatar!,
            "Quyen": NewInfo.quyen!,
            "Sdt": NewInfo.sdt!,
            "Ten": NewInfo.ten!
        ]
        Database.database().reference().child("User/User2/\(uid!)/Quanlythongtincanhan").setValue(data)
        
        let alert = UIAlertController(title: "Cập nhật thông tin thành công", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Đóng", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true) {
            self.indicator.stopAnimating()
        }
    }

    @IBAction func didTapAvatar(_ sender: Any) {
        showActionSheet()
    }
    @IBAction func didTapUpdate(_ sender: Any) {
        let indicatorView = UIView.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        indicatorView.backgroundColor = #colorLiteral(red: 0.6273961067, green: 0.6228634715, blue: 0.6308681369, alpha: 0.4008307658)
        self.view.addSubview(indicatorView)
        indicatorView.addSubview(indicator)
        indicator.center = indicatorView.center
        indicator.style = .whiteLarge
        indicator.startAnimating()
        
        if txtName.text == "" || txtName.text == "..." || txtPhone.text == "..." || txtPhone.text == "" || txtEmail.text == "" {
            let alert = UIAlertController(title: "Xin hãy điền đầy đủ thông tin và chọn hình đại diện", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Đóng", style: .default, handler: nil))
            self.present(alert, animated: true) {
                self.indicator.stopAnimating()
            }
            return
        }
        
        let currentUserLogin = Auth.auth().currentUser
        let EmailString: String = (currentUserLogin?.email!)!
        let Avatar_Ref = storageRef.child("images/\(EmailString).jpg")
        let imgData: Data = (imgAvatar.image?.jpegData(compressionQuality: 0.3))!
        let uploadTask = Avatar_Ref.putData(imgData, metadata: nil) { (metaData, error) in
            guard let _ = metaData else {
                print("Put Image Data Failed")
                return
            }
            Avatar_Ref.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    print("Get image URL  ")
                    return
                }
                let changeRequest = currentUserLogin?.createProfileChangeRequest()
                changeRequest?.photoURL = downloadURL
                changeRequest?.commitChanges(completion: { (error) in
                    if let _ = error {
                        print("Co loi khi update hinh avatar")
                        return
                    }
                    else {
                        self.handleUpdateUserInfo(linkAva: downloadURL.absoluteString)
                    }
                })
            }
        }
        uploadTask.resume()
    }
    @IBAction func didTapCloseButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func pickMediaFromSource(_ sourceType:UIImagePickerController.SourceType) {
        let mediaTypes =
            UIImagePickerController.availableMediaTypes(for: sourceType)!
        if UIImagePickerController.isSourceTypeAvailable(sourceType)
            && mediaTypes.count > 0 {
            let picker = UIImagePickerController()
            
            picker.mediaTypes = mediaTypes
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = sourceType
            present(picker, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title:"Error accessing media",
                                                    message: "Unsupported media source.",
                                                    preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "OK",
                                         style: UIAlertAction.Style.cancel, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    }
}

extension InformationViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        lastChosenMediaType = info[UIImagePickerController.InfoKey.mediaType] as? String
        if let mediaType = lastChosenMediaType {
            if mediaType == (kUTTypeImage as NSString) as String {
                image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
                imgAvatar.image = self.image
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion:nil)
    }
}
