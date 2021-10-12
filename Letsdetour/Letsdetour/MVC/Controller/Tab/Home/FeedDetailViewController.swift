//
//  FeedDetailViewController.swift
//  Letsdetour
//
//  Created by Jaypreet on 26/08/21.
//

import UIKit
import GooglePlaces

class FeedDetailViewController: UIViewController {

    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var imgRate: UIImageView!
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var tableVew: UITableView!
    @IBOutlet weak var lblDistance: UILabel!
    var ImageCollection  = [UIImage]()

    var TiitleName : String = ""
    var Place_id : String = ""
    var Detail : M_Google_Nearby!
    var Photos : GMSPlace!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        lblType.text = ""
        lblName.text = ""
        lblTitle.text = ""
        lblAddress.text = ""
        lblDistance.text = ""
        collectionView.RegisterTableCell("ImageCollectionViewCell")
        pageController.hidesForSinglePage = true
        tableVew.RegisterTableCell("ReviewTableViewCell")
        lblTitle.text = "Detail"
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        Get_Google_Data()

    }
    func Get_Google_Data()  {
        let header = ["" : ""]
        DataModelCode().GetApiJson(Url: "https://maps.googleapis.com/maps/api/place/details/json?location=\(Current_lat),\(Current_lng)&place_id=\(Place_id)&key=\(Config.googleMapKey)", method: .get, params: header, headers: header, storyBoard: storyboard!, navigation: self) { (data, error, status) in
            if status == 200{
                print(data)
                self.Detail = M_Google_Nearby.init(dict: data.value(forKey: "result") as! [String : Any])
                self.SetDetail()
            }
        }
    }
    func SetDetail()  {
        lblName.text = Detail.name
        lblAddress.text = Detail.vicinity
        lblRate.text = "\(Detail.rating)/\(Detail.user_ratings_total)"
        lblDistance.text = Detail.business_status
        lblType.text = Detail.types.componentsJoined(by: ",")
        collectionView.dataSource = self
        collectionView.delegate = self
        let placesClient = GMSPlacesClient()
        GooglePlaceImages(id: Detail.place_id) { (places) in
            if (places.photos != nil){
                for i in places.photos!{
                    let photoMetadata: GMSPlacePhotoMetadata = i
                    // Call loadPlacePhoto to display the bitmap and attribution.
                    placesClient.loadPlacePhoto(photoMetadata, callback: { (photo, error) -> Void in
                      if let error = error {
                        // TODO: Handle the error.
                        print("Error loading photo metadata: \(error.localizedDescription)")
                        return
                      } else {
                        print("Items")
                        self.ImageCollection.append(photo!)
                        self.collectionView.reloadData()
                        self.pageController.numberOfPages = self.ImageCollection.count
                        print(self.ImageCollection.count)
                        // Display the first image and its attributions.
                      }
                    })
                }
            }
              // Get the metadata for the first photo in the place photo metadata list.
        }
        tableVew.reloadData()
    }
    @IBAction func Direction(_ sender: Any) {
        self.ShowDirection(lat: "\(Detail.lat)", lng: "\(Detail.lng)")
    }
    @IBAction func Back(_ sender: Any) {
        Dismiss()
    }
    @IBAction func Like(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "CreateTravelPlanViewController") as! CreateTravelPlanViewController
        vc.modalPresentationStyle = .fullScreen
        vc.PostLat = "\(Detail.lat)"
        vc.PostLng = "\(Detail.lng)"
        vc.Address = Detail.vicinity
        vc.isFromDetail = true

        present(vc, animated: true, completion: nil)
    }
    @IBAction func AddReview(_ sender: Any) {
//        let vc = storyboard?.instantiateViewController(identifier: "AddReviewViewController") as! AddReviewViewController
//        vc.modalPresentationStyle = .fullScreen
//        vc.Place_id = Place_id
//        present(vc, animated: true, completion: nil)
    }
    func ApiLike(status : Int)  {
        let dict = ["status" : status,
                    "place_id" : Place_id,
                    ] as [String : Any]
        

        APIClients.POST_user_addFollowPlace(parems: dict, storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)
                Constants.Toast.MyToast(message: response.message   )

                let when = DispatchTime.now() + 0
                DispatchQueue.main.asyncAfter(deadline: when)
                {
//                    self.GetPlaceDetail()

                }

            case .failure(let error):
                print(error)
            }
            
        } failure: { (error) in
            
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
extension FeedDetailViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Detail == nil{
            return 0
        }
        return Detail.reviews.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell", for: indexPath) as! ReviewTableViewCell
        cell.selectionStyle = .none
        cell.lblComment.text = Detail.reviews[indexPath.row].text
        cell.viewRate.rating = Double(Detail.reviews[indexPath.row].rating)
        cell.lblDetail.text = Detail.reviews[indexPath.row].relative_time_description
        cell.imgUser.getImage(url: Detail.reviews[indexPath.row].profile_photo_url)
        cell.lblName.text =  Detail.reviews[indexPath.row].author_name
        return cell
    }
}
extension FeedDetailViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return ImageCollection.count
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        cell.img.image = ImageCollection[indexPath.row]
        
            return cell
       
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(identifier: "ImagesViewController") as! ImagesViewController
        vc.modalPresentationStyle = .fullScreen
        vc.ImageCollection = ImageCollection
        vc.SelectedIndex = indexPath.row
        present(vc, animated: true, completion: nil)
    }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.frame.width, height: collectionView.frame.height)

       
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSet = scrollView.contentOffset.x
        let width = scrollView.frame.width
        let horizontalCenter = width / 2
        if (scrollView.viewWithTag(11) != nil){
            pageController.currentPage = Int(offSet + horizontalCenter) / Int(width)
        }
    }
}
