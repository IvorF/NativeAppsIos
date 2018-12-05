import UIKit

class CustomTabBarController:  UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.delegate = self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        print("BOE")
        if viewController.isKind(of: CategorieTableViewController.self) {
            print("binnen BOE2")
            let vc =  CategorieTableViewController()
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("digt?")
        print(self.selectedIndex)
        print(item.tag)
        if (self.selectedViewController?.isKind(of: UINavigationController.self))!
        {
            if item.tag == 2 {
                print("hier")
                let nav = self.selectedViewController as! UINavigationController
//                nav.popToRootViewController(animated: false)
            }
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("BOE2")
    }
}
