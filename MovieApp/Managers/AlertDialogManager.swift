//
//  AlertDialogViewModel.swift
//  MovieApp
//
//  Created by BS1010 on 13/11/22.
//

import Foundation
import SwiftUI

class AlertDialogViewModel: ObservableObject {
    @Published var alert = false
    @Published var error = ""
    @Published var isConfirmationView = false
    @Published var alertTitle = ""
    @Published var okBtnAction: (() -> Void)?
    
    func createAlertNotification(btnAction: @escaping () -> Void) {
        alertTitle = "New Movie Added"
        error = "A new movie has been added. Want to navigate there?"
        isConfirmationView = true
        okBtnAction = btnAction
        alert.toggle()
    }
    
    func createLogoutAlert(btnAction: @escaping () -> Void) {
        isConfirmationView = true
        error = "Do you want to log out?"
        alertTitle = "Logout"
        okBtnAction = btnAction
        alert.toggle()
    }
    func sessionTimeOutAlert() {
        alertTitle = "Session Expired"
        isConfirmationView = false
        error = "The auth token session is expired"
        alert.toggle()
    }
    
    func configureAlertViewForLogin(errorMsg: String, errorTitle: String) {
        isConfirmationView = false
        error = errorMsg
        alertTitle = errorTitle
        alert.toggle()
    }
}
