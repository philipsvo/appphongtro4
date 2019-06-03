
import UIKit
import Firebase
import CodableFirebase

let storage = Storage.storage()
let storageRef = storage.reference(forURL: "gs://appphongtro1.appspot.com")
let ref = Database.database().reference()
// vua dang nhap hoac dang ky thanh cong thi lay thong tin user ra
var currenUser:User!
var chuphongs:[ChuPhong] = DSChuPhong
class LoginController: UIViewController{
    
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var btnExit: UIButton!
    //    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!
//    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var loginButton: UIButton!
    var array_user:Array<User> = Array<User>()
    
    let indicator: UIActivityIndicatorView = UIActivityIndicatorView.init(frame: CGRect(x: 0, y: 0, width: 75, height: 75))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupView()
        //addBackGround()
        // set up duong dan cho firebase
        let tablename = ref.child("danhsachphongcosan")
        let phongs = tablename.child("ChuPhongID")
        // khoi tao 1 phong de up len fire base
        let p:Dictionary<String,String> = ["ten":"vu ",
                                            "linkAvatar":"https://newimageasia.vn/image/catalog/newimage/Home3-091.png",
                                             "diachi":"123/s DQH ",
                                            "gia":"1000 $",
                                            "motacongphong":"làm việc toàn thời gian, độ tuổi: lớn hơn 17 nhỏ hơn 31, siêng năng, có tinh thần học hỏi, biết tiếng anh. ",
                                            "email":"vu@gmail.com",
                                            "sdt":"0956211155"
            
        ]
        // luu len firebase
        phongs.setValue(p)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.isLogOut()
        usernameField.text = ""
        passwordField.text = ""
        print("view will appear .......\n")
    }
    

    override func viewDidAppear(_ animated: Bool) {
         print("view did appear .......\n")
        usernameField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         print("view will ( Dis ) appear .......\n")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("view did ( Dis ) appear .......\n")
    }
    
    @IBAction func bt_login(_ sender: Any) {
        let indicatorView = UIView.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        indicatorView.backgroundColor = #colorLiteral(red: 0.6273961067, green: 0.6228634715, blue: 0.6308681369, alpha: 0.4008307658)
        self.view.addSubview(indicatorView)
        indicatorView.addSubview(indicator)
        indicator.center = indicatorView.center
        indicator.style = .whiteLarge
        indicator.startAnimating()
        
        if(usernameField.text == "" || passwordField.text == "")
        {
            let alert  = UIAlertController(title: "Thông báo", message: "Vui lòng nhập đủ thông tin !", preferredStyle: .alert)
            let btn_ok:UIAlertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(btn_ok)
            present(alert, animated: true) {
                self.indicator.stopAnimating()
                indicatorView.removeFromSuperview()
            }
        }
        else
        {
            Auth.auth().signIn(withEmail: usernameField.text!, password: passwordField.text!) { [weak self] user, error in
                if error == nil
                {
//                                    print("....... dang nhap thanh cong ............")
                    let user = Auth.auth().currentUser
                    let avatar: String = user?.photoURL?.absoluteString ?? ""
                    currenUser = User.init(id: user!.uid, email: (user!.email!), linkAvatar: avatar, quyen: 0)
                    
                    let u = "User1"
                    // ref.child de truy van table trong database , lay ra ID current USER hien tai
                    var tablename = ref.child("User").child("\(u)")
                    // Listen for new comments in the Firebase database
                    tablename.observe(.childAdded, with: { (snapshot) in
                        // nếu lấy được dữ liệu postDict từ sever về và id của user có trong postDict
                        if let postDict = snapshot.value as? [String : AnyObject], currenUser.id == snapshot.key
                        {
                            let User_current = (postDict["Quanlythongtincanhan"]) as! NSMutableDictionary
                            let email:String = (User_current["Email"])! as? String ?? "taolao@gmail.com"
                            let quyen:String = (User_current["Quyen"])! as? String ?? "taolao"
                            let linkAvatar:String = (User_current["LinkAvatar"])! as? String ?? "taolao"
                            
                            let user:User = User(id: snapshot.key, email: email, linkAvatar: linkAvatar, quyen: Int(quyen)!)
                            currenUser = user
                            
                            if(Int(currenUser.quyen) == 1)
                            {
                                print("---------------- Chuyen man hinh cho user voi quyen la 1 ---------------")
                                self?.indicator.stopAnimating()
                                indicatorView.removeFromSuperview()
                                self?.goto_Screen_Main_khach_hang()
                                return
                            }
                            else {
                                
                            }
                        }
                        else {
                            
                        }
                    })
                    
                    print("KHONG CO POSTDICT HOAC ID USER KHONG CO TRONG TABLE USER1")
                    
                    // ref.child de truy van table trong database , lay ra ID current USER hien tai
                    tablename = ref.child("User/User2")
                    // Listen for new comments in the Firebase database
                    Helper.shared.fetchData(tableName: tablename, currentUserId: currenUser.id, completion: { (newUser,error) in
                        if error == "" {
                            Store.shared.userMotel = newUser
                            self?.indicator.stopAnimating()
                            indicatorView.removeFromSuperview()
                            self?.performSegue(withIdentifier: "FromLoginToListMotel", sender: self)
                        }
                        else {
                            print(error)
                        }
                    })
                }
                else
                {
                    // dang nhap khong thanh cong
                    let alert = UIAlertController(title: "Thông Báo", message: "Email hoac password không chính xác", preferredStyle: .alert)
                    let btn_ok:UIAlertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(btn_ok)
                    self?.present(alert, animated: true) {
                        self?.indicator.stopAnimating()
                        indicatorView.removeFromSuperview()
                    }
                    
                }
            }
        }
    }
    
    
    @IBAction func bt_Register(_ sender: Any) {
        let scr  = storyboard?.instantiateViewController(withIdentifier: "MH_dangky")
        navigationController?.pushViewController(scr!, animated: true)
    }
    
    @IBAction func btnExit(_ sender: Any) {
        exit(0)
    }
    
    func goto_Screen_Main_chu_phong() {
        let scr = self.storyboard?.instantiateViewController(withIdentifier: "Screen_Chat_Roon_With_Rent_01") as! Screen_Chat_Roon_With_Rent_01_ViewController
        //        present(scr!, animated: true, completion: nil)
        navigationController?.pushViewController(scr, animated: true)
    }
    
    

    func setupView(){
        
        self.title = "Quan Tro"
        
        loginButton.layer.cornerRadius = 5
        loginButton.layer.shadowOpacity = 2
        registerButton.layer.cornerRadius = 4
        registerButton.layer.shadowOpacity = 2
//        btnExit.layer.masksToBounds = true
        btnExit.layer.cornerRadius = 4
        btnExit.layer.shadowOpacity = 2
        usernameField.setupUI()
        passwordField.setupUI()
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background2")
        backgroundImage.alpha = 0.8
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    

    func isLogin()
    {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil
            {
                // da dang nhap
                self.goto_Screen_Main_khach_hang()
            }
            else
            {
                print("chua dang nhap !..........")
            }
        }
    }
    
    func isLogOut()  {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }

    func goto_Screen_Main_khach_hang() {
//        let scr = self.storyboard?.instantiateViewController(withIdentifier: "MH_chucnang_khachhang") as! Screen_Main_Customer_ViewController
//        present(scr!, animated: true, completion: nil)
//        navigationController?.pushViewController(scr, animated: true)
        self.performSegue(withIdentifier: "screen_main_kh", sender: Any?.self)
    }
    
    
    func set_data_QLphong(){
        let tableUser = ref.child("User").child("User2").child(currenUser.id).child("Quanlyphong").childByAutoId().child("Chitietphong")
        
        let tt:Dictionary<String,String> = [
            "Diachi": "2459/7 BT",
            "Dientich": "90/8",
            "Gia":"800",
            "Hinhphong":"...",
            "Motachitietphong":"...",
            "Trangthai":"1"
        ]
        
        tableUser.setValue(tt)
    }
}


extension UITextField{
    func setupUI(){
        self.layer.shadowOpacity = 0.1
    }
    
    func noneBorder(){
        self.layer.borderWidth = 0
    }
}
