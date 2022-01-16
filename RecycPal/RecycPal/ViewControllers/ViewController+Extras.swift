//
//  ViewController+Extras.swift
//  RecycPal
//
//  Created by Justin Esguerra on 1/16/22.
//

import UIKit
import AVFoundation

extension Camera2ViewController {
    //MARK:- View Setup
    func setupView(){
       view.backgroundColor = .black
       view.addSubview(switchCameraButton)
       view.addSubview(captureImageButton)
       view.addSubview(capturedImageView)
        
        captureImageButton.center = CGPoint(
                    x: view.frame.width / 2,
                    y: view.frame.height - (self.tabBarController?.tabBar.frame.height)!
                )
       
       NSLayoutConstraint.activate([
           switchCameraButton.widthAnchor.constraint(equalToConstant: 30),
           switchCameraButton.heightAnchor.constraint(equalToConstant: 30),
           switchCameraButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
           switchCameraButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
           
//           captureImageButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
//           captureImageButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
//           captureImageButton.widthAnchor.constraint(equalToConstant: 50),
//           captureImageButton.heightAnchor.constraint(equalToConstant: 50),
           
           capturedImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
           capturedImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
           capturedImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
           capturedImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5, constant: -70)
       ])
       
       switchCameraButton.addTarget(self, action: #selector(switchCamera(_:)), for: .touchUpInside)
       captureImageButton.addTarget(self, action: #selector(captureImage(_:)), for: .touchUpInside)
    }
    
    //MARK:- Permissions
    func checkPermissions() {
        let cameraAuthStatus =  AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch cameraAuthStatus {
          case .authorized:
            return
          case .denied:
            abort()
          case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler:
            { (authorized) in
              if(!authorized){
                abort()
              }
            })
          case .restricted:
            abort()
          @unknown default:
            fatalError()
        }
    }
}
