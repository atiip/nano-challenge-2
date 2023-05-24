//
//  FirstLoginView.swift
//  GridPuzzleChallenge
//
//  Created by Muhammad Athif on 24/05/23.
//

import SwiftUI

struct FirstLoginView: View {
    @State private var username: String = ""
    @StateObject var cloudKitManager = CloudKitManager()
    var body: some View {
        VStack{
            TextField("Masukkan Nama", text: $username)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(action: {
                Task{
                    await cloudKitManager.updateNameDataUser(username:username)
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
}

struct FirstLoginView_Previews: PreviewProvider {
    static var previews: some View {
        FirstLoginView()
    }
}
