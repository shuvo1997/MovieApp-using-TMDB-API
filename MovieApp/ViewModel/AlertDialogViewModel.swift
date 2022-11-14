//
//  AlertDialogViewModel.swift
//  MovieApp
//
//  Created by BS1010 on 13/11/22.
//

import Foundation

class AlertDialogViewModel: ObservableObject {
    @Published var alert = false
    @Published var error = ""
    @Published var isConfirmationView = false
    @Published var alertTitle = ""
}
