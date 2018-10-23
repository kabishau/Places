import UIKit
import MapKit
import QuadratTouch

class PlacesViewController: UIViewController, CLLocationManagerDelegate {
    
    var client: Client?
    var session: Session?
    
    var places: [[String: Any]]()
    
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
        
        setupFoursquare()
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
    
    func setupFoursquare() {
        
        client = Client(
            clientID: "LP4EKTZGVWT3D2RZ44LKPNZ4SQYFP0RJR5GMYW5PEPYJWTWO",
            clientSecret: "XT10HP3WEBOKIPP0JPE1PYKUJSZNPCAKCAHJXFHELXP34P1T",
            redirectURL: "")
        
        if client != nil {
            var configuration = Configuration(client: client!)
            Session.setupSharedSessionWithConfiguration(configuration)
        }
        session = Session.sharedSession()
    }
    
    func queryFoursquare(location: CLLocation) {
        if session == nil || hasFinishedQuery == false {
            return
        }
        
        places.removeAll()
        
        var parameters = location.parameters()
        parameters += [Parameter.categoryId: "4d4b7105d754a06374d81259"]
        parameters += [Parameter.radius: "100"]
        
        let searchTask = session!.venues.search(parameters) { (result) -> Void in
            if let response = result.response {
                print(response)
            }
            self.hasFinishedQuery = true
        }
    }
    searchTask.start()
}

