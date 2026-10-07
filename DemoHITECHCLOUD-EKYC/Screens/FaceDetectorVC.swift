//
//  FaceDetectorVC.swift
//  DemoHITECHCLOUD-EKYC
//
//  Created by Nguyen Thanh An on 08/10/2026.
//

import UIKit
import HITECHCLOUD_EKYC
import AVFoundation

extension UIViewController {
    static func loadFromNib() -> Self {
        func instantiateFromNib<T: UIViewController>() -> T {
            return T.init(nibName: String(describing: T.self), bundle: nil)
        }
        
        return instantiateFromNib()
    }
}

class FaceDetectorVC: UIViewController {
    
    @IBOutlet weak var imageCropView: UIImageView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var correctView: UIImageView!
    
    var camera: HITECHCLOUDEKYC?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        camera = HITECHCLOUDEKYC.init(frameCameraPreview: self.cameraView.bounds, frameCorrect: self.correctView.frame)
        if let camera = self.camera {
            self.cameraView.addSubview(camera.cameraPreview)
        }
        self.cameraView.bringSubviewToFront(self.correctView)
        self.cameraView.bringSubviewToFront(self.imageCropView)
        
        //Set Delegate
        camera?.cameraDelegate = self
        camera?.faceDetectorDelegate = self
        
        //Set Type
        camera?.isType = .face
        //Show debug view
        camera?.showDebug = true
        //Position
        camera?.cameraPosition = .front
        
        camera?.startSession()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Restart session - Khởi tạo lại camera nếu đã tạm dừng camera trước đó
        self.camera?.restartSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //Tạm dừng session Camera - Nếu cần tạm dừng camera
        self.camera?.stopSession()
    }
    
    
    
}

extension FaceDetectorVC: HITECHCLOUDEKYCCameraDelegate {
    func cameraChangePosition(newPosision: AVCaptureDevice.Position) {
        
    }
    
    func cameraPermissionCameraDenied(status: AVAuthorizationStatus) {
        
    }
    
    func cameraDidStart() {
        
    }
    
    func cameraDidFail(error: Error) {
        
    }
    
    func cameraDidStop() {
        
    }
    

    
}

extension FaceDetectorVC: HITECHCLOUDEKYCFaceDetectorDelegate {
    func faceDetectionResult(valid: Bool, image: UIImage?) {
        DispatchQueue.main.async {
            self.correctView.image = self.correctView.image?.withRenderingMode(.alwaysTemplate)
            self.correctView.tintColor = valid ? UIColor.green : UIColor.red
        }
        if let imageResult = image, valid {
            //Phương thức này sẽ vẫn được gọi mỗi lần nhận được được khuôn mặt
            //Hãy gắn flag đánh dấu khi nhận được ảnh để tạm dừng không chạy block này tùy theo cách dùng
        }
    }
    

}