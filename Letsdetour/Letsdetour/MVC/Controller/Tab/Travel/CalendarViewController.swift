//
//  CalendarViewController.swift
//  Letsdetour
//
//  Created by Jaypreet on 11/10/21.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController {
    fileprivate weak var calendar: FSCalendar!

    @IBOutlet weak var viewCalendar: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        let calendar = FSCalendar(frame:viewCalendar.frame)
        calendar.dataSource = self
        calendar.delegate = self
        viewCalendar.addSubview(calendar)
        
        self.calendar = calendar
    }
    @IBAction func Back(_ sender: Any) {
        Dismiss()
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
extension CalendarViewController :  FSCalendarDataSource, FSCalendarDelegate{
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        
       
        self.view.layoutIfNeeded()
    }
}
