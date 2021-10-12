//
//  ImagesViewController.swift
//  Letsdetour
//
//  Created by Jaypreet on 20/09/21.
//

import UIKit

class ImagesViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblTitle: UILabel!
    var ImageCollection = [UIImage]()
    var ImagesURL = [String]()
    var isURL : Bool = true
    var SelectedIndex : Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        collectionView.scrollToItem(at: IndexPath.init(row: SelectedIndex, section: 0), at: .centeredHorizontally, animated: false)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func Back(_ sender: Any) {
        Dismiss()
    }
    
    @IBAction func Download(_ sender: Any) {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func DownloadImage(imagestring : String)  {
        if let url = URL(string: imagestring),
            let data = try? Data(contentsOf: url),
            let image = UIImage(data: data) {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }

}
extension ImagesViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isURL{
            return ImagesURL.count
        }
            return ImageCollection.count
       
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imgCell", for: indexPath)
            let lbl = cell.viewWithTag(1) as! UIImageView
        if isURL{
            lbl.getImage(url: ImagesURL[indexPath.row])
        }
        else{
            lbl.image = ImageCollection[indexPath.row]
        }
            return cell
       
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize.init(width: collectionView.frame.width, height: collectionView.frame.height)

        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSet = scrollView.contentOffset.x
        let width = scrollView.frame.width
        let horizontalCenter = width / 2
//        if (scrollView.viewWithTag(11) != nil){
//            lblPageController.currentPage = Int(offSet + horizontalCenter) / Int(width)
//        }
    }
}
