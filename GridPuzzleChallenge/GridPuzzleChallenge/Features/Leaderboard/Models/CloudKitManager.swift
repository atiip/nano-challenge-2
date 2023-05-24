
import Foundation
import CloudKit
import SwiftUI


class CloudKitManager: NSObject,ObservableObject{
    @Published var dataUsers: [DataUserModel] = []
    @Published var isLoading: Bool = false
    @Published var dataUser: DataUserModel = DataUserModel(status: "", firstName: "", lastName: "", username: "", email: "", userID: "", highscore: 0, longitude: 0.0, latitude: 0.0)
    
    public func fetchAllDataUser() async {
        DispatchQueue.main.async { self.isLoading = true }
        
        if let dataUsers = await DataUserModel.getAllDataUserFromCloudKit(){
            DispatchQueue.main.async {
                self.isLoading = false
                self.dataUsers = dataUsers }
        }else{
            self.isLoading = false
        }
    }
    public func fetchDataUser() async {
        DispatchQueue.main.async { self.isLoading = true }
        guard let userID = UserDefaults.standard.string(forKey: "userID") else{return}
        
        if let dataUser = await DataUserModel.getDataUserFromCloudKit(userID: userID){
            DispatchQueue.main.async {
                self.isLoading = false
                self.dataUser = dataUser
                print("this model")
                print(dataUser)
            }
            
        }else{
            self.isLoading = false
        }
    }
    public func addNewUser() async {
        DispatchQueue.main.async { self.isLoading = true }
        
        guard let firstName = UserDefaults.standard.string(forKey: "firstName") else{return}
        guard let lastName = UserDefaults.standard.string(forKey: "lastName") else{return}
        guard let email = UserDefaults.standard.string(forKey: "email") else{return}
        guard let userID = UserDefaults.standard.string(forKey: "userID") else{return}
    
        let newUser = DataUserModel(status: "offline", firstName: firstName, lastName: lastName, username: "", email: email, userID: userID, highscore: 0, longitude: 0.0, latitude: 0.0)
       
        
        if let savedDataUser = await newUser.saveNewDataUserToCloudKit(){
            
            DispatchQueue.main.async {
                self.dataUsers.append(savedDataUser)
                self.isLoading = false
                
            }
        }else{
            DispatchQueue.main.async { self.isLoading = false }
        }
    }
    public func updateNameDataUser(username:String) async {
        DispatchQueue.main.async { self.isLoading = true }
            
        await self.dataUser.updateUsernameToCloudKit(username: username)
        print(username)
        DispatchQueue.main.async { self.isLoading = false }
        print("Update nih bos")
//        print(dataUser.)
//
//        do {
//
//        } catch {
//            Self.logger.error("\(error.localizedDescription, privacy: .public)")
//        }
//        let newDrawing = Drawing(title: "Untitled Drawing \(drawings.count + 1)")
//
//        if let savedDrawing = await newDrawing.saveNewDrawingToCloudKit(){
//
//            DispatchQueue.main.async {
//                self.drawings.append(savedDrawing)
//                self.isLoading = false
//
//            }
//        }else{
//
//        }
    }
    
    
    
    
}

