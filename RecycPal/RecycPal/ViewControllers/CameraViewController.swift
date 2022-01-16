//
//  CameraViewController.swift
//  RecycPal
//
//  Created by Denielle Abaquita on 1/15/22.
//

import AVFoundation
import UIKit

class CameraViewController: UIViewController {
    
    // Initialize CoreML + Vision variables and constants
//    let imagePredictor = ImagePredictor()
    let predictionsToShow = 1
    
    private let predictionLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemGreen
        return label
    }()
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    private func updateImage(_ image: UIImage) {
        DispatchQueue.main.async {
            self.imageView.image = image
        }
    }
    
    private func updatePredictionLabel(_ message: String) {
        DispatchQueue.main.async {
            self.predictionLabel.text = message
        }
    }
    
//    private func classifyImage(_ image: UIImage) {
//        do {
//            try self.imagePredictor.makePredictions(for: image, completionHandler: imagePredictionHandler)
//        } catch {
//            print("Vision was unable to make a prediction...\n\n\(error.localizedDescription)")
//        }
//    }
    
//    private func imagePredictionHandler(_ predictions: [ImagePredictor.Prediction]?) {
//        guard let predictions = predictions else {
//            updatePredictionLabel("No Predictions. (Check console log.)")
//            return
//        }
//        
//        let formattedPredictions = formatPredictions(predictions)
//        
//        let predictionString = formattedPredictions.joined(separator: "\n")
//        updatePredictionLabel(predictionString)
//    }
//    
//    private func formatPredictions(_ predictions: [ImagePredictor.Prediction]) -> [String] {
//        let topPredictions: [String] = predictions.prefix(predictionsToShow).map { prediction in
//            var name = prediction.classification
//            
//            if let firstComma = name.firstIndex(of: ",") {
//                name = String(name.prefix(upTo: firstComma))
//            }
//            
//            return "\(name) - \(prediction.confidencePercentage)%"
//        }
//        
//        return topPredictions
//    }
    
    // Initializing Camera View
    var session: AVCaptureSession?
    let output = AVCapturePhotoOutput()
    let previewLayer = AVCaptureVideoPreviewLayer()
    
    private let shutterButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        button.layer.cornerRadius = 50
        button.layer.borderWidth = 10
        button.layer.borderColor = Colors.green.cgColor
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.yellow
        view.layer.addSublayer(previewLayer)
        
        shutterButton.addTarget(self, action: #selector(didTapTakePhoto), for: .touchUpInside)
        view.addSubview(shutterButton)
        
        checkPermission()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
        
        shutterButton.center = CGPoint(
            x: view.frame.width / 2,
            y: view.frame.height - 175
        )
    }
    
    private func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setUpCamera()
        case .denied:
            break
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else { return }
                DispatchQueue.main.async {
                    self?.setUpCamera()
                }
            }
        case .restricted:
            break
        @unknown default:
            break
        }
    }
    
    private func setUpCamera() {
        let session = AVCaptureSession()
        session.beginConfiguration()
        if let device = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input) {
                    session.addInput(input)
                }
                
                let photoOutput = AVCapturePhotoOutput()
                guard session.canAddOutput(photoOutput) else { return }
                session.sessionPreset = .photo
                session.addOutput(photoOutput)
                session.commitConfiguration()
                
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.session = session
                
                self.session = session
                session.startRunning()
            } catch {
                print(error)
            }
        }
    }
    
    @objc private func didTapTakePhoto() {
        output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(
        _ output: AVCapturePhotoOutput,
        didFinishProcessingPhoto photo: AVCapturePhoto,
        error: Error?
    ) {
        guard let data = photo.fileDataRepresentation() else {
            return
        }
        let image = UIImage(data: data)
        
        session?.stopRunning()
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.frame = view.bounds
        
        view.addSubview(imageView)
    }
}


