//
//  ProfileViewController.swift
//  WhatsappClone
//
//  Created by nandawperdana on 09/07/24.
//

import Foundation
import SwiftUI

class ProfileViewController: UIViewController {
    // MARK: View Model
    var viewModel: ProfileUIViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: Setup UI
    private func setupUI() {
        let profileView = ProfileView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: profileView)
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        hostingController.didMove(toParent: self)
        
        viewModel.onNavigate = { vc in
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
