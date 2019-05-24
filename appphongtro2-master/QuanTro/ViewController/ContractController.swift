
import UIKit
import TextFieldEffects
import Firebase

class ContractController: UIViewController {

    @IBOutlet weak var contractSigningDateField:AkiraTextField!
    @IBOutlet weak var dayStartAtField:AkiraTextField!
    @IBOutlet weak var dayEndAtField:AkiraTextField!
    @IBOutlet weak var despoistField:AkiraTextField!
    @IBOutlet weak var rentalPriceField:AkiraTextField!
    @IBOutlet weak var nameFirstRoomer:AkiraTextField!
    @IBOutlet weak var txtCMND: AkiraTextField!
    @IBOutlet weak var txtSDT: AkiraTextField!
    @IBOutlet weak var cancleContractButton: UIButton!
    
    let phongtro = Store.shared.userMotel.quanlydaytro![Store.shared.indexDaytro].quanlyphong?[Store.shared.indexPhongtro]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cancleContractButton.layer.cornerRadius = 3
        cancleContractButton.layer.shadowOpacity = 1
        if phongtro?.hopdong?.tenNguoiHopDong == "" {
            cancleContractButton.setTitle("Tạo hợp đồng", for: .normal)
            let alert = UIAlertController(title: "Phòng này chưa làm hợp đồng", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Đóng", style: .default, handler: { (true) in
                self.contractSigningDateField.isUserInteractionEnabled = true
                self.dayStartAtField.isUserInteractionEnabled = true
                self.dayEndAtField.isUserInteractionEnabled = true
                self.despoistField.isUserInteractionEnabled = true
                self.rentalPriceField.text = String.init(format: "%d", (self.phongtro?.chitietphong!.gia)!)
                self.nameFirstRoomer.isUserInteractionEnabled = true
                self.txtSDT.isUserInteractionEnabled = true
                self.txtCMND.isUserInteractionEnabled = true
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        else {
            cancleContractButton.setTitle("Huỷ hợp đồng", for: .normal)
            setupInfo()
        }
    }
    
    func setupInfo(){
        guard let contract = phongtro?.hopdong else{return}
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        contractSigningDateField.text = contract.ngayLamHopDong
        dayStartAtField.text = contract.ngayBatDauO
        dayEndAtField.text = contract.ngayKetThucHopDong
        despoistField.text = String.init(format: "%.0f", contract.tienDatCoc ?? 0.0)
        rentalPriceField.text = String.init(format: "%d", (phongtro?.chitietphong!.gia)!)
        nameFirstRoomer.text = contract.tenNguoiHopDong
        txtCMND.text = String.init(format: "%.0f", contract.CMND ?? 0.0)
        txtSDT.text = String.init(format: "%.0f", contract.SDT ?? 0.0)
    }

    @IBAction func cancelContract(_ sender: Any) {
        let uid: String = Auth.auth().currentUser!.uid
        let idDaytro: String = Store.shared.userMotel.quanlydaytro![Store.shared.indexDaytro].iDdaytro!
        let idPhong: String = self.phongtro!.iDphong!
        
        if cancleContractButton.titleLabel?.text == "Huỷ hợp đồng" {
            let actionSheet = UIAlertController(title: "Bạn muốn huỷ hợp đồng?", message: "Dữ liệu về người trọ của phòng này sẽ bị xoá", preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Huỷ hợp đồng", style: .destructive, handler: { (action) in
                let alert = UIAlertController(title: "Huỷ hợp đồng thành công", message: "Số tiền cọc cần trả cho người trọ: \(self.despoistField.text!)", preferredStyle: .alert)
                Database.database().reference().child("User/User2/\(uid)/Quanlydaytro/\(idDaytro)/Quanlyphong/\(idPhong)/Hopdong").removeValue()
                
                Database.database().reference().child("User/User2/\(uid)/Quanlydaytro/\(idDaytro)/Quanlyphong/\(idPhong)/Quanlythanhvien").removeValue()
                
                alert.addAction(UIAlertAction(title: "Đóng", style: .default, handler: {(action) in
                    let indexDay: Int = Store.shared.indexDaytro
                    let indexPhong: Int = Store.shared.indexPhongtro
                    Store.shared.userMotel.quanlydaytro![indexDay].quanlyphong![indexPhong].hopdong = HopDong.init()
                    Store.shared.userMotel.quanlydaytro![indexDay].quanlyphong![indexPhong].thanhvien = []
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }))
            actionSheet.addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler: nil))
            present(actionSheet, animated: true, completion: nil)
        }
        else {
            if contractSigningDateField.text == "" || dayStartAtField.text == "" || dayEndAtField.text == "" || despoistField.text == "" || rentalPriceField.text == "" || nameFirstRoomer.text == "" || txtCMND.text == "" || txtSDT.text == "" {
                let alert = UIAlertController(title: "Xin hãy nhập đầy đủ thông tin", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Đóng", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            let actionSheet = UIAlertController(title: "Bạn muốn tạo hợp đồng?", message: "Lưu ý: Sau khi tạo thành công bạn mới có thể thêm người ở trọ", preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Tạo hợp đồng", style: .default, handler: { (action) in
                let alert = UIAlertController(title: "Tạo hợp đồng thành công", message: "", preferredStyle: .alert)
                
                let hopdong: HopDong = HopDong.init(ngayLamHopDong: self.contractSigningDateField.text!, ngayBatDauO: self.dayStartAtField.text!, ngayKetThucHopDong: self.dayEndAtField.text!, tenNguoiHopDong: self.nameFirstRoomer.text!, CMND: NumberFormatter().number(from: self.txtCMND.text!)!.doubleValue, SDT: NumberFormatter().number(from: self.txtSDT.text!)!.doubleValue, tienDatCoc: NumberFormatter().number(from: self.despoistField.text!)!.doubleValue)
                
                let data: [String:Any] = [
                    "Ngaylamhopdong": hopdong.ngayLamHopDong!,
                    "Ngayketthuchopdong": hopdong.ngayKetThucHopDong!,
                    "Ngaybatdauo": hopdong.ngayBatDauO!,
                    "Tennguoihopdong": hopdong.tenNguoiHopDong!,
                    "CMND": hopdong.CMND!,
                    "SDT": hopdong.SDT!,
                    "Tiendatcoc": hopdong.tienDatCoc!
                ]
                Database.database().reference().child("User/User2/\(uid)/Quanlydaytro/\(idDaytro)/Quanlyphong/\(idPhong)/Hopdong").setValue(data)
                
                alert.addAction(UIAlertAction(title: "Đóng", style: .default, handler: {(action) in
                    let indexDay: Int = Store.shared.indexDaytro
                    let indexPhong: Int = Store.shared.indexPhongtro
                    Store.shared.userMotel.quanlydaytro![indexDay].quanlyphong![indexPhong].hopdong = hopdong
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }))
            actionSheet.addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler: nil))
            present(actionSheet, animated: true, completion: nil)
        }
    }
    
}
