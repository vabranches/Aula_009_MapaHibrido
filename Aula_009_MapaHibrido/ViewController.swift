
import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var mapa: MKMapView!
    
    
    //MARK: Propriedades
    var gerenciadorGPS = CLLocationManager()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Configurando a precisão a ser utilizada no GPS
        gerenciadorGPS.desiredAccuracy = kCLLocationAccuracyBest
        
        //Determinando a regiao a ser inicializada no mapa
        //Ibirapuera: -23.587082,-46.6611527
        let coordenadasIbira = CLLocationCoordinate2DMake(-23.587082, -46.6611527)
        let zoomMapa = MKCoordinateSpanMake(0.02, 0.02)
        let regiaoMapa = MKCoordinateRegionMake(coordenadasIbira, zoomMapa)
        mapa.setRegion(regiaoMapa, animated: true)
        mapa.setCenter(coordenadasIbira, animated: true)
        
        
        //Criando um Pino para a localização
        let pinoIbira = MKPointAnnotation()
        pinoIbira.title = "Parque do Ibirapuera"
        pinoIbira.subtitle = "Chegamos ao Parque"
        pinoIbira.coordinate = coordenadasIbira
        
        mapa.addAnnotation(pinoIbira)

    }

    //MARK: Actions
    @IBAction func atualizar(_ sender: UIBarButtonItem) {
        if CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedWhenInUse && CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedAlways{
            
            gerenciadorGPS.requestWhenInUseAuthorization()
        } else {
            mapa.showsUserLocation = true
            gerenciadorGPS.delegate = self
            gerenciadorGPS.startUpdatingLocation()
        }
    }
    
    @IBAction func mudarMapa(_ sender: UISegmentedControl) {
        
        let indice = sender.selectedSegmentIndex
        switch indice {
        case 0:
            mapa.mapType = MKMapType.standard
        case 1:
            mapa.mapType = MKMapType.satellite
        case 2:
            mapa.mapType = MKMapType.hybrid
        default:
            mapa.mapType = MKMapType.standard
        }
    }
    
    //MARK: Metodos de CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let localizacao = locations.last
        let zoom = MKCoordinateSpanMake(0.01, 0.01)
        let regiao = MKCoordinateRegionMake(localizacao!.coordinate, zoom)
        mapa.setRegion(regiao, animated: true)

    }

}

