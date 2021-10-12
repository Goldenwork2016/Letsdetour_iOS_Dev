//
//  TravelRouteViewController.swift
//  Letsdetour
//
//  Created by Jaypreet on 02/09/21.
//

import UIKit
import MapKit

class TravelRouteViewController: UIViewController , MKMapViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var lblName: UILabel!
    var SelectedHeader : Int = 0
    var PlanDetail : M_Plan_Detail_data!

    override func viewDidLoad() {
        super.viewDidLoad()
        CreateRoute()
        // Do any additional setup after loading the view.
    }
    func CreateRoute()  {
        super.viewDidLoad()
   
        for annotation in self.mapView.annotations  {
            
            self.mapView.removeAnnotation(annotation)
            
        }
        for annotation in self.mapView.overlays  {
            
            self.mapView.removeOverlay(annotation)
            
        }
        
        
        
        mapView.delegate = self
        // 2.
        let sourceLocation = CLLocationCoordinate2D(latitude: Double(PlanDetail.dates[SelectedHeader].routes.first?.lat ?? "0") ?? 0.0, longitude: Double(PlanDetail.dates[SelectedHeader].routes.first?.lng ?? "0") ?? 0.0)
        
        

        
        var source = [MKPointAnnotation()]
        var locationCoordinates = [CLLocationCoordinate2D]()

        for i in PlanDetail.dates[SelectedHeader].routes{
            
            let sLocation = CLLocationCoordinate2D(latitude: Double(i.lat) ?? 0.0, longitude: Double(i.lng) ?? 0.0)
            let sPlacemark = MKPlacemark(coordinate: sLocation, addressDictionary: nil)
            let sAnnotation = MKPointAnnotation()
            sAnnotation.title = i.name
            sAnnotation.subtitle = i.address
            
            if let location = sPlacemark.location {
                sAnnotation.coordinate = location.coordinate
            }
            locationCoordinates.append(sLocation)

            source.append(sAnnotation)

        }
        self.mapView.showAnnotations(source, animated: true )

        let polyline = MKPolyline.init(coordinates: locationCoordinates, count: PlanDetail.dates[SelectedHeader].routes.count)
        mapView.addOverlay(polyline, level: MKOverlayLevel.aboveRoads)

//        let rect = polyline.boundingMapRect
//        print(rect)
//        self.mapView.setCameraBoundary(MKMapView.CameraBoundary.init(mapRect: rect), animated: true)
        
        let region = MKCoordinateRegion( center: sourceLocation, latitudinalMeters: CLLocationDistance(exactly: 5000)!, longitudinalMeters: CLLocationDistance(exactly: 5000)!)
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
        
        
    }
    @IBAction func Back(_ sender: Any) {
        Dismiss()
    }
    @IBAction func Share(_ sender: Any) {
        buildFDLLink(RequestID: "\(PlanDetail.id)", text: "Check Travel Plan", type: 3)

    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
            renderer.lineWidth = 4.0
        
            return renderer
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
extension TravelRouteViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PlanDetail.dates.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderCell", for: indexPath)
        let lbl = cell.viewWithTag(1) as! UILabel
        let lbl1 = cell.viewWithTag(2) as! UILabel
        lbl1.isHidden = true
        lbl.textColor = .Primary
  
        lbl.text = PlanDetail.dates[indexPath.row].plan_date
        
        if SelectedHeader == indexPath.row{
            lbl1.isHidden = false
            lbl.textColor = .Secondary
        }
        

        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        SelectedHeader = indexPath.row
        collectionView.reloadData()
        CreateRoute()
    }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 80
                           , height: 30
        )
    }
}
