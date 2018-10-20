import UIKit
import MapKit

class PlacesViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        if locationManager != nil {
            
            locationManager!.requestAlwaysAuthorization()
            locationManager!.delegate = self
            locationManager!.startUpdatingLocation()
            
            // accuracy of the updates
            locationManager!.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager!.distanceFilter = 50.0
        }
    }
    
    
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let newLocation = locations.last {
            print(newLocation)
            
            let region = MKCoordinateRegion(center: newLocation.coordinate, latitudinalMeters: 100, longitudinalMeters: 100)
            let adjestedRegion = mapView.regionThatFits(region)
            //mapView.setCenter(newLocation.coordinate, animated: true)
            mapView.setRegion(adjestedRegion, animated: true)
        }
    }
    
}

