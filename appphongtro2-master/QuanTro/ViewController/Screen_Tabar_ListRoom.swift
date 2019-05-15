
import UIKit
import Firebase

class Screen_Tabar_ListRoom: UIViewController {

    @IBOutlet weak var tblListRoom: UITableView!

    let ref = Database.database().reference()
    
    var currentUser: NewUser = NewUser.init(userID: vistor.id, Quanlydaytro: [], Quanlythongtincanhan: Quanlythongtincanhan.init(email: vistor.email, linkAvatar: vistor.linkAvatar, quyen: "2", sdt: "", ten: ""))
    
    var phongtro: [Quanlyphong] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Danh sách phòng trọ"
        
        tblListRoom.register(RoomCell.self,
                           forCellReuseIdentifier: "RoomCell")
        let xib = UINib(nibName: "RoomCell", bundle: nil)
        tblListRoom.register(xib, forCellReuseIdentifier: "RoomCell")
        tblListRoom.rowHeight = 110
        self.tblListRoom.dataSource = self
        self.tblListRoom.delegate = self
        // Do any additional setup after loading the view.
        
        
        Helper.shared.fetchData(tableName: ref.child("User/User2"), currentUserId: vistor.id) { (curUser, err) in
            if err != "" {
                print(err)
            }
            else {
                self.currentUser = curUser
                for item in curUser.quanlydaytro! {
                    if item.quanlyphong!.count > 0 {
                        for item2 in item.quanlyphong! {
                            let a: Quanlyphong = Quanlyphong.init(idPhong: item2.iDphong!, chitietphong: item2.chitietphong!, thanhvien: item2.thanhvien ?? [])
                            self.phongtro.append(a)
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.tblListRoom.reloadData()
                }
            }
        }
    }

}

extension Screen_Tabar_ListRoom: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return phongtro.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblListRoom.dequeueReusableCell(withIdentifier: "RoomCell") as! RoomCell
        
        let cellSize = tableView.getSizeCell()
        
        cell.contentView.addSubview(cellSize)
        cell.contentView.sendSubviewToBack(cellSize)
        
        cell.name.text = phongtro[indexPath.row].chitietphong?.tenphong
        cell.numberOfRoomer.text = String.init(format: "%d", phongtro[indexPath.row].chitietphong!.songuoidangthue!)
        cell.imageV.image = UIImage(named: "opened")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "User1ToListRoomUser2", sender: tableView.cellForRow(at: indexPath))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = tblListRoom.indexPath(for: (sender as! UITableViewCell))
        if segue.identifier == "User1ToListRoomUser2" {
            let vc = segue.destination as! Screen_Tabar_ChitietPhong
            vc.chitietPhong = phongtro[(indexPath?.row)!].chitietphong
        }
    }
}
