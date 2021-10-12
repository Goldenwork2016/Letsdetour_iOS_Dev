//
//  ChatDetailViewController.swift
//  Letsdetour
//
//  Created by Jaypreet on 09/09/21.
//

import UIKit

class ChatDetailViewController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func Back(_ sender: Any) {
        Dismiss()
    }
    
    @IBAction func MOre(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChatMoreViewController") as! ChatMoreViewController
          vc.view.backgroundColor = UIColor.clear
          vc.modalPresentationStyle = .popover
      
              vc.preferredContentSize = CGSize(width: 200, height: 280)
         
          let ppc = vc.popoverPresentationController
          ppc?.permittedArrowDirections = .any
          ppc?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
          ppc?.delegate = self
          ppc?.sourceView = sender
          present(vc, animated: true, completion: nil)
    }
    @IBAction func AddUser(_ sender: Any) {
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
extension ChatDetailViewController :  UIPopoverPresentationControllerDelegate {
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        
    }
    
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        
    }
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    func setAlphaOfBackgroundViews(alpha: CGFloat) {
        let statusBarWindow = UIApplication.shared.value(forKey: "statusBarWindow") as? UIWindow
        UIView.animate(withDuration: 0.2) {
            statusBarWindow?.alpha = alpha;
            self.view.alpha = alpha;
            self.navigationController?.navigationBar.alpha = alpha;
        }
    }
}
