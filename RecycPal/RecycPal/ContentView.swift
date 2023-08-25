//
//  ContentView.swift
//  RecycPal
//
//  Created by Justin Esguerra on 7/14/23.
//

import SwiftUI
import AVFoundation

struct NavBar: View {
    @State private var selection = 0
    
    var body: some View {
        TabView(selection: $selection) {
            HomeView()
//                .background(Color(red:0.25, green:0.74, blue: 0.55))
                .tabItem {
                    Label("History",systemImage: "house")
                }
                .tag(0)
            CameraView()
                .tabItem {
                    Label("Camera",systemImage: "camera")
                }
                .tag(1)
            InformationView()
                .tabItem {
                    Label("Info",systemImage: "book")
                }
                .tag(2)
            
        }
    }
}

struct HomeView: View {
    var body: some View {
        VStack (
            alignment: .leading,
            spacing: 10
        ) {
            Text("Previous Photos")
                .font(.largeTitle)
                .padding(10)
                .foregroundColor(.white)
            
            ScrollView {
                VStack (
                    spacing: 10
                ) {
                    HistoryPhotoCard()
                }
                .frame(maxWidth: .infinity)
            }
        }
        .background(Color(red:0.3, green:0.7, blue: 0.50))

    }
}

struct HistoryPhotoCard: View {
    var body: some View {
        HStack {
            Image("plastic")
                .resizable()
                .scaledToFit()
                .frame(height: 75)
                .padding(10)
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
            Spacer()
            Text("Test Slide") // Have a random name generator and if the user wants to change it give them the ability to after saving the photo locally
                .font(.title)
            Spacer()
            Spacer()
        }
        .frame(width: 370)
        .background(Color(red: 0.9, green: 0.9 ,blue: 0.55 ))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
    }
}

struct Photo: Decodable {
    var image_path: String
    var name: String
    var datetime: Date
    var objects_detected: [String]
    var toatl_num_objects_detected: Int
}

struct CameraView: View {
    @State private var image: UIImage?

    var body: some View {
        ZStack {
            ZStack {
                ZStack {
//                    if image != nil {
//                        Image(uiImage: image!)
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                    } else {
//                        Camera(image: $image)
//                    }
                    HostedCamController()
                }
                .padding(10)
                .background(Color(red: 0.9, green: 0.9 ,blue: 0.55 ))
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
            }
            .frame(maxWidth: .infinity)
            .frame(maxHeight: .infinity)
            .padding()

        }
            .background(Color(red:0.3, green:0.7, blue: 0.50))
            

    }
}

//struct Camera: UIViewControllerRepresentable {
//    @Binding var image: UIImage?
//    @Environment(\.presentationMode) private var presentationMode
//
//    func makeUIViewController(context: Context) -> UIImagePickerController {
//        let picker = UIImagePickerController()
//        picker.delegate = context.coordinator
//        picker.sourceType = .camera
//        return picker
//    }
//
//    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
//    }
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
//        let parent: Camera
//
//        init(_ parent: Camera) {
//            self.parent = parent
//        }
//
//        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            if let image = info[.originalImage] as? UIImage {
//                parent.image = image
//            }
//            parent.presentationMode.wrappedValue.dismiss()
//        }
//
//        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//            parent.presentationMode.wrappedValue.dismiss()
//        }
//    }
//}

class CameraPreview: UIViewController {
    private var permissionGranted = false // Permission Flag
    private let captureSession = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "sessionQueue")
    private var previewLayer = AVCaptureVideoPreviewLayer()
    var screenRect: CGRect! = nil // Establish View Dimensions
    
    override func viewDidLoad() {
        checkPermission()
        
        sessionQueue.async { [unowned self] in
            guard permissionGranted else { return }
            self.setupCaptureSession()
            self.captureSession.startRunning()
        }
    }
    
    func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            // Permission Granted before
        case .authorized:
            permissionGranted = true
        case .notDetermined:
            requestPermission()
        default:
            permissionGranted = false
        }
    }
    
    func requestPermission() {
        sessionQueue.suspend()
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { [unowned self] granted in
            self.permissionGranted = granted
            self.sessionQueue.resume()
        })
    }
    
    func setupCaptureSession() {
        // Get Camera
        guard let videoDevice = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) else { return }
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice) else { return }
        
        guard captureSession.canAddInput(videoDeviceInput) else { return }
        captureSession.addInput(videoDeviceInput)
        
        // Preview Layer
        screenRect = UIScreen.main.bounds
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = CGRect(x: 0, y:0, width: screenRect.size.width, height: screenRect.size.height)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill // Fill Screen
        
        previewLayer.connection?.videoOrientation = .portrait
        
        // Updates to UI must be on main queue
        DispatchQueue.main.async { [weak self] in
            self!.view.layer.addSublayer(self!.previewLayer)
        }
    }
}

struct HostedCamController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        return CameraPreview()
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}

struct InformationView: View {
    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 10
        ) {
            Text("Information")
                .font(.largeTitle)
                .padding(10)
                .foregroundColor(.white) // changes text color
            InformationMap()
            Text("Materials")
                .font(.largeTitle)
                .padding(10)
                .foregroundColor(.white)
            InformationMaterial()
        }
        .background(Color(red:0.3, green:0.7, blue: 0.50))
    }
}

struct InformationMap: View {
    var body: some View {
//        GeometryReader { geometry in
            VStack(alignment: .leading) { // .leading = left
                HStack {
                    Image("navigator")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 75)
                        .padding(.trailing, 10)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
                    Text("Find your closest Recycling Center")
                        .font(.title)
                        .padding(.bottom, 5)
                }
                .padding(10)
                .frame(width: 370)
            }
                .background(Color(red: 0.9, green: 0.9 ,blue: 0.55 ))
                .cornerRadius(10)
//                .frame(width: geometry.size.width * 0.8) // 80% the width of the parent
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
                .padding(.leading, 10)
//        }
    }
}

struct InformationMaterial: View {
    let materials = GetMaterialService.loadMaterials()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                ForEach(materials, id: \.name) { material in
                    InformationMaterialCard(material: material)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct InformationMaterialCard: View {
    let material: Material
    
    var body: some View {
        HStack {
            Image(material.name.lowercased())
                .resizable()
                .scaledToFit()
                .frame(height: 75)
                .padding(10)
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
            Spacer()
            Text(material.name)
                .font(.title)
            Spacer()
            Spacer()
        }
        .frame(width: 370)
        .background(Color(red: 0.9, green: 0.9 ,blue: 0.55 ))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)


    }
}

struct InformationMaterialDetail: View {
    var body: some View {
        Text("Material Detail Card")
    }
}

struct Material: Decodable {
    var name: String
    var body: String
}

struct GetMaterialService {
    static func loadMaterials() -> [Material] {
        if let url = Bundle.main.url(forResource: "materials", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let materials = try? JSONDecoder().decode([Material].self, from: data) {
                print(materials)
                return materials
           } else {
               return []
           }
    }
}

struct ContentView: View {
    var body: some View {
        NavBar()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
