//
//  ContentView.swift
//  GridPuzzleChallenge
//
//  Created by Muhammad Athif on 19/05/23.
//

import SwiftUI
import AuthenticationServices
import CloudKit

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("userID") private var userID = ""
    @AppStorage("firstName") private var firstName = ""
    @AppStorage("lastName") private var lastName = ""
    @AppStorage("email") private var email = ""
    @AppStorage("login") private var login = false
    
    @StateObject var cloudKitManager = CloudKitManager()
    @StateObject var locationManager = LocationManager()
    @State private var name: String = ""
    private var isSignedIn:Bool {
        !userID.isEmpty
    }
    
    var body: some View {
        NavigationStack(root: {
            VStack {
                            VStack{
                                Text("Fecth data here")
                                Text("")
                                if !isSignedIn{
                                    SignInButtonView()
                                }
                                // cek lagi buat first login
                                else{
                                    TextField("Masukkan Nama", text: $name)
                                        .padding()
                                        .textFieldStyle(RoundedBorderTextFieldStyle())

                                    Button(action: {
                                        Task{
                                            await cloudKitManager.updateNameDataUser(username:name)
                                        }
                                        
                                    }) {
                                        Text("Submit")
                                            .padding()
                                            .background(Color.blue)
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                    }
                                    .padding()

                                    if cloudKitManager.isLoading {
                                        ProgressView()
                                    } else {
                                        Text("Data Users: \(cloudKitManager.dataUsers.count)")
//                                        Text("Data User: \(cloudKitManager.dataUser.name)")
                                    }
                                }
                            }
                            .onAppear{
                                Task{
                                    await cloudKitManager.fetchDataUser()
                //                    locationManager.requestLocationPermission()
                                    print("this")
                //                    locationManager.requestLocation()
                //                    locationManager.
                //                    locationManager.d
                                }
                            }
                
            }
           
        }
        ).navigationTitle("Sign in")

       
    }
    
}

struct SignInButtonView: View {
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("userID") private var userID = ""
    @AppStorage("firstName") private var firstName = ""
    @AppStorage("lastName") private var lastName = ""
    @AppStorage("email") private var email = ""
    @AppStorage("login") private var login = false
    @StateObject var locationManager = LocationManager()
    @StateObject var cloudKitManager = CloudKitManager()
    
    var body: some View{
        SignInWithAppleButton(.continue){ request in
            
            request.requestedScopes = [.email, .fullName]
        } onCompletion: { result in
            // Switch result
            switch result {
                // Auth Success
                case .success(let authResults):

                switch authResults.credential {
                    case let appleIDCredential as ASAuthorizationAppleIDCredential:
                        let userID = appleIDCredential.user
                        if let firstName = appleIDCredential.fullName?.givenName,
                            let lastName = appleIDCredential.fullName?.familyName,
                            let email = appleIDCredential.email{
                            // For New user to signup, and
                            // save the 3 records to CloudKit
                            // Save to local
                            print("ini firstName")
                            print(firstName)
                           UserDefaults.standard.set(email, forKey: "email")
                           UserDefaults.standard.set(firstName, forKey: "firstName")
                           UserDefaults.standard.set(lastName, forKey: "lastName")
                            let record = CKRecord(recordType: "DataUser", recordID: CKRecord.ID(recordName: userID))
                            UserDefaults.standard.set(record.recordID.recordName, forKey: "userID")
                           
                            Task{
                                await cloudKitManager.addNewUser()
                            }
                           
//                            let record = CKRecord(recordType: "DataUser", recordID: CKRecord.ID(recordName: userID))
//
////                            guard let location = locations.last else { return }
//                            record["email"] = email
//                            record["firstName"] = firstName
//                            record["lastName"] = lastName
//                            record["name"] = firstName
//                            record["userID"] = userID
////                            record["longitude"] = locationDataManager.locationManager.location?.coordinate.latitude.description
//                            record["latitude"] = "52.481071"
//                            // Save to local
//                            UserDefaults.standard.set(email, forKey: "email")
//                            UserDefaults.standard.set(firstName, forKey: "firstName")
//                            UserDefaults.standard.set(lastName, forKey: "lastName")
//                            let publicDatabase = CKContainer.default().publicCloudDatabase
//                            publicDatabase.save(record) { (_, _) in
//                                UserDefaults.standard.set(record.recordID.recordName, forKey: "userID")
//                            }
                            // Change login state
                            self.login = true
                        } else {
                            // For returning user to signin,
                            // fetch the saved records from Cloudkit
                            let publicDatabase = CKContainer.default().publicCloudDatabase
                            publicDatabase.fetch(withRecordID: CKRecord.ID(recordName: userID)) { (record, error) in
                                if let fetchedInfo = record {
                                    let email = fetchedInfo["email"] as? String
                                    let firstName = fetchedInfo["firstName"] as? String
                                    let lastName = fetchedInfo["lastName"] as? String
                                    // Save to local
                                    UserDefaults.standard.set(userID, forKey: "userID")
                                    UserDefaults.standard.set(email, forKey: "email")
                                    UserDefaults.standard.set(firstName, forKey: "firstName")
                                    UserDefaults.standard.set(lastName, forKey: "lastName")
                                    // Change login state
                                    self.login = true
                                }
                            }
                        }

                    // default break (don't remove)
                    default:
                        break
                    }
                case .failure(let error):
                    print("failure", error)
            }
        }.signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
            .frame(height: 50)
            .padding()
            .cornerRadius(8)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//extension YourView: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else { return }
//
//        // Gunakan lokasi saat ini (latitude dan longitude)
//        let latitude = location.coordinate.latitude
//        let longitude = location.coordinate.longitude
//
//        // Lakukan sesuatu dengan lokasi saat ini
//        // Misalnya, tampilkan atau simpan ke CloudKit
//        print("Latitude: \(latitude), Longitude: \(longitude)")
//    }
//}
