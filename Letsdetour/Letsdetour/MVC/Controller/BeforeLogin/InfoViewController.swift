//
//  InfoViewController.swift
//  Letsdetour
//
//  Created by Jaypreet on 24/08/21.
//

import UIKit

class InfoViewController: UIViewController {
    @IBOutlet weak var pageController: UIPageControl!
    
    @IBOutlet weak var CollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func Skip(_ sender: Any) {
        self.PushToSelectOption()
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
extension InfoViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let img = cell.viewWithTag(1) as! UIImageView
        let lbl1 = cell.viewWithTag(2) as! UILabel
        let lbl2 = cell.viewWithTag(3) as! UILabel
        switch indexPath.row {
        case 0:
            img.image = #imageLiteral(resourceName: "info_first")
            lbl1.text = "Explore new places."
            lbl2.text = "Search for restaurants, local attractions, and accommodations with access to others’ feedback and ratings."
        case 1:
            img.image = #imageLiteral(resourceName: "info_second_iphone_11")
            lbl1.text = "Create your own travel plan."
            lbl2.text = "Create your own travel plan by saving your favorite restaurants, accommodations, and tourist attractions in your travel space and share your itinerary with friends and family."
        case 2:
            img.image = #imageLiteral(resourceName: "info_third_iphone_11")
            lbl1.text = "Add your posts."
            lbl2.text = "Share pictures on your travel timeline for likes and comments."
        default:
            break
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return view.bounds.size
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        pageController.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {

        pageController.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
}
