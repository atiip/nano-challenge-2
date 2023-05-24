//
//  LocationManager.swift
//  GridPuzzleChallenge
//
//  Created by Muhammad Athif on 23/05/23.
//

import Foundation
import CoreLocation
import CloudKit

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    private let locationManager = CLLocationManager()
//    @Published var locationStatus: CLAuthorizationStatus?
//    @Published var location: CLLocationCoordinate2D?
    @Published var lastLocation: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus?
    
    override init() {
        super.init()
        locationManager.delegate = self
//        locationManager.startUpdatingLocation()
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
           switch manager.authorizationStatus {
           case .authorizedWhenInUse:  // Location services are available.
               // Insert code here of what should happen when Location services are authorized
               authorizationStatus = .authorizedWhenInUse
               locationManager.requestLocation()
               break
               
           case .restricted:  // Location services currently unavailable.
               // Insert code here of what should happen when Location services are NOT authorized
               authorizationStatus = .restricted
               break
               
           case .denied:  // Location services currently unavailable.
               // Insert code here of what should happen when Location services are NOT authorized
               authorizationStatus = .denied
               break
               
           case .notDetermined:        // Authorization not determined yet.
               authorizationStatus = .notDetermined
               manager.requestWhenInUseAuthorization()
               break
               
           default:
               break
           }
       }
    

//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        switch manager.authorizationStatus {
//                case .authorizedWhenInUse:  // Location services are available.
//                    // Insert code here of what should happen when Location services are authorized
//                    break
//
//                case .restricted, .denied:  // Location services currently unavailable.
//                    // Insert code here of what should happen when Location services are NOT authorized
//                    break
//
//                case .notDetermined:        // Authorization not determined yet.
//                    manager.requestWhenInUseAuthorization()
//                    break
//
//                default:
//                    break
//                }
//    }
    
    
//    var statusString: String {
//            guard let status = locationStatus else {
//                return "unknown"
//            }
//
//            switch status {
//            case .notDetermined: return "notDetermined"
//            case .authorizedWhenInUse: return "authorized"
//            case .authorizedAlways: return "authorized"
//            case .restricted: return "restricted"
//            case .denied: return "denied"
//            default: return "unknown"
//            }
//    }
//    func requestLocationPermission() {
//        locationManager.requestWhenInUseAuthorization()
//    }
//
    func requestLocation() {
        locationManager.requestLocation()
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) async {
//
////        let database = CKContainer.default().publicCloudDatabase
//        guard let location = locations.last else { return }
//
//        do {
////            let dataUser = try await fetchDataWithRecordID(recordID: recordID)
//////            DataUserModel.fetchDataWithRecordID(recordID: recordID, completion: <#(DataUserModel?) -> Void#>)
////            var record = try await database.record(for: recordID)
////            let dataUser = DataUserModel(
////                status: "Online",
////                name: "John Doe",
////                highscore: 0,
////                longitude: location.coordinate.longitude,
////                latitude: location.coordinate.latitude
////            )
//            print("latitude")
//            print(location.coordinate.latitude)
//            print("longitude")
//            print(location.coordinate.longitude)
////            location.coordinate.longitude
////            location.coordinate.latitude
////            await record?.saveNewDataUserToCloudKit()
//            // how to save a record to cloudkit
//        }catch{
//            print("Error retrieving data user from CloudKit: \(error.localizedDescription)")
//        }
//    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        lastLocation = location
        // locationManager.startUpdatingLocation()
        
        // Gunakan lokasi saat ini (latitude dan longitude)
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        // Lakukan sesuatu dengan lokasi saat ini
        // Misalnya, tampilkan atau simpan ke CloudKit
        print("Latitude: \(latitude), Longitude: \(longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager error: \(error.localizedDescription)")
    }
    
}
