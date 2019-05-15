//
//  Screen_Tabar_Controller.swift
//  QuanTro
//
//  Created by Flint Pham on 5/14/19.
//  Copyright © 2019 Le Nguyen Quoc Cuong. All rights reserved.
//

import UIKit

class Screen_Tabar_Controller: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapRootView(_ sender: Any) {
        print(self.navigationController?.viewControllers)
        for controller in self.navigationController?.viewControllers as! Array<UIViewController> {
            if controller.isKind(of: Screen_Tabar_Controller_00.self) {
                self.navigationController?.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
