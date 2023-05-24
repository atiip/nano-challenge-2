//
//  DataUserModel.swift
//  GridPuzzleChallenge
//
//  Created by Muhammad Athif on 22/05/23.
//

import CloudKit
import CoreLocation


struct DataUserModel: Identifiable {
    var id = UUID()
    var recordID: CKRecord.ID?
    var status: String
    var firstName: String
    var lastName: String
    var username: String
    var email: String
    var userID: String
    var highscore: Int
    var longitude: Double
    var latitude: Double

    var record: CKRecord?
    
    
    var newRecord: CKRecord {
        let record = CKRecord(recordType: "DataUser")
        record.setValuesForKeys([
            "firstName": self.firstName,
            "lastName": self.lastName,
            "email": self.email,
            "userID": self.userID,
            "username": self.username,
            "status": self.status,
            "highscore": self.highscore,
            "longitude": self.longitude,
            "latitude": self.latitude
        ])
        return record
    }
    
    public func saveNewDataUserToCloudKit() async  -> DataUserModel?{
        let database = CloudKitConfiguration.container.publicCloudDatabase
        let newRecord = newRecord
        
        do{
            try await database.save(newRecord)
            print("masuk create")
//            try await DataUserModel.getAllDataUserFromCloudKit()
            return self
        }catch let err{
            print("Error cloudkit \(err.localizedDescription)")
            return nil
        }
    }
    
    static public func getAllDataUserFromCloudKit() async -> [DataUserModel]? {
        let database = CloudKitConfiguration.container.publicCloudDatabase
        let predicate = NSPredicate(value: true)
        // Record typenya berdasarkan apa
        let query = CKQuery(recordType: "DataUser", predicate: predicate)
        
        do{
            let resultRecords = try await database.records(matching: query, desiredKeys: nil)
            
            let dataUsers = try resultRecords.matchResults.map({ (id,result) in
                let record = try result.get()
                var dataUser = DataUserModel(
                    status: record["status"] as! String,
                    firstName: record["firstName"] as! String,
                    lastName: record["lastName"] as! String,
                    username: record["username"] as! String,
                    email: record["email"] as! String,
                    userID: record["userID"] as! String,
                    highscore: record["highscore"] as! Int,
                    longitude:  record["longitude"] as! Double,
                    latitude: record["latitude"] as! Double
                )
                dataUser.record = record
                return dataUser
            })
            
            return dataUsers
            
        }catch let err{
            print("Error cloudkit add \(err.localizedDescription)")
            return nil
        }
    }
    static func fetchDataWithRecordID(recordID: CKRecord.ID, completion: @escaping (DataUserModel?) -> Void) {
        let database = CKContainer.default().publicCloudDatabase
        
        database.fetch(withRecordID: recordID) { (record, error) in
            if let error = error {
                print("Error fetching data with record ID: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let record = record else {
                print("No data found for the record ID")
                completion(nil)
                return
            }
            
            // Process the retrieved record
            let status = record["status"] as? String ?? ""
            let firstName = record["firstName"] as? String ?? ""
            let lastName = record["lastName"] as? String ?? ""
            let email = record["email"] as? String ?? ""
            let username = record["username"] as? String ?? ""
            let userID = record["userID"] as? String ?? ""
            let highscore = record["highscore"] as? Int ?? 0
            let longitude = record["longitude"] as? Double ?? 0.0
            let latitude = record["latitude"] as? Double ?? 0.0
            
            // Create a DataUserModel instance with the fetched data
            let dataUser = DataUserModel(status: status, firstName: firstName, lastName: lastName, username: username,email: email, userID: userID, highscore: highscore, longitude: longitude, latitude: latitude)
//            DataUserModel(status: status, name: name, highscore: highscore, longitude: longitude, latitude: latitude)
            
            // Return the fetched DataUserModel
            completion(dataUser)
        }
    }
    static public func getDataUserFromCloudKit(userID: String) async -> DataUserModel? {
        let database = CloudKitConfiguration.container.publicCloudDatabase
        let predicate = NSPredicate(format: "userID == %@", userID)
        // Record typenya berdasarkan apa
        let query = CKQuery(recordType: "DataUser", predicate: predicate)
        
        do{
            let resultRecords = try await database.records(matching: query, desiredKeys: nil)
            
            
            
            guard let record = resultRecords.matchResults.first else {
                // Data user not found
                return nil
            }
            let finalRecord = try record.1.get()
            var dataUser = DataUserModel(
                status: finalRecord["status"] as! String,
                firstName: finalRecord["firstName"] as! String,
                lastName: finalRecord["lastName"] as! String,
                username: finalRecord["username"] as! String,
                email: finalRecord["email"] as! String,
                userID: finalRecord["userID"] as! String,
                highscore: finalRecord["highscore"] as! Int,
                longitude:  finalRecord["longitude"] as! Double,
                latitude: finalRecord["latitude"] as! Double
            )
           
//            let dataUsers = try resultRecords.matchResults.map({ (id,result) in
//                let record = try result.get()
//
//            })
            
            dataUser.record = finalRecord
            return dataUser
            
        }catch let err{
            print("Error fetching data from CloudKit: \(err.localizedDescription)")
            return nil
        }
    }
    
    public func updateUsernameToCloudKit(username: String) async -> Void{

        let database = CloudKitConfiguration.container.publicCloudDatabase
        let predicate = NSPredicate(format: "userID == %@", userID)
        // Record typenya berdasarkan apa
        let query = CKQuery(recordType: "DataUser", predicate: predicate)
        
        do{
            let resultRecords = try await database.records(matching: query, desiredKeys: nil)
            
            
            
            guard let record = resultRecords.matchResults.first else {
                // Data user not found
                return
            }
            let finalRecord = try record.1.get()
            finalRecord.setValuesForKeys([
                "username": username,
            ])
            try await database.save(finalRecord)
        }catch let err{
            print("Error fetching data from CloudKit: \(err.localizedDescription)")
            return
        }
    }
    
    
//    func fetchDataWithRecordID(recordID: CKRecord.ID, completion: @escaping (DataUserModel?) -> Void, {
//        let database = CKContainer.default().publicCloudDatabase
//
//        database.fetch(withRecordID: recordID) { (record, error) in
//            if let error = error {
//                print("Error fetching data with record ID: \(error.localizedDescription)")
//                completion(nil)
//                return
//            }
//
//            guard let record = record else {
//                print("No data found for the record ID")
//                completion(nil)
//                return
//            }
//
//            // Process the retrieved record
//            let status = record["status"] as? String ?? ""
//            let name = record["name"] as? String ?? ""
//            let highscore = record["highscore"] as? Int ?? 0
//            let longitude = record["longitude"] as? Double ?? 0.0
//            let latitude = record["latitude"] as? Double ?? 0.0
//
//            // Create a DataUserModel instance with the fetched data
//            let dataUser = DataUserModel(status: status, name: name, highscore: highscore, longitude: longitude, latitude: latitude)
//
//            // Perform further operations with the fetched data
//            print("Fetched data: \(dataUser)")
//            completion(dataUser)
//        }
//
//    }
    

}
