//
//  CameraCell.swift
//  Pods
//
//  Created by Joakim Gyllström on 2015-09-26.
//
//

import UIKit
import AVFoundation

/**
*/
final class CameraCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraBackground: UIView!
    var takePhotoIcon: UIImage? {
        didSet {
            imageView.image = takePhotoIcon
            
            // Apply tint to image
            imageView.image = imageView.image?.imageWithRenderingMode(.AlwaysTemplate)
        }
    }
    
    var session: AVCaptureSession?
    var captureLayer: AVCaptureVideoPreviewLayer?
    let sessionQueue = dispatch_queue_create("AVCaptureVideoPreviewLayer", nil)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Don't trigger camera access for the background
        guard AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo) == .Authorized else {
            return
        }
        
        do {
            // Prepare avcapture session
            session = AVCaptureSession()
            session?.sessionPreset = AVCaptureSessionPresetMedium
            
            // Hook upp device
            let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
            let input = try AVCaptureDeviceInput(device: device)
            session?.addInput(input)
            
            // Setup capture layer
            if let captureLayer = AVCaptureVideoPreviewLayer(session: session) {
                captureLayer.frame = bounds
                captureLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                cameraBackground.layer.addSublayer(captureLayer)
                
                self.captureLayer = captureLayer
            }
        } catch {
            session = nil
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        captureLayer?.frame = bounds
    }
    
    func startLiveBackground() {
        dispatch_async(sessionQueue) { () -> Void in
            self.session?.startRunning()
        }
    }
    
    func stopLiveBackground() {
        dispatch_async(sessionQueue) { () -> Void in
            self.session?.stopRunning()
        }
    }
}
