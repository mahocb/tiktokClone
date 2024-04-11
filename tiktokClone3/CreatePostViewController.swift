//
//  CreatePostViewController.swift
//  tiktokClone3
//
//  Created by Mahmut Başcı on 2.04.2024.
//

import UIKit
import AVFoundation


class CreatePostViewController: UIViewController {

    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var captureButtonRingView: UIView!
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var flipCameraButton: UIButton!
    @IBOutlet weak var flipCameraLabel: UILabel!
    @IBOutlet weak var speedButton: UIButton!
    @IBOutlet weak var beautyButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var timerButton: UIButton!
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var effectsButton: UIButton!
    @IBOutlet weak var discardButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var flashLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var beautyLabel: UILabel!
    @IBOutlet weak var timeCounterLabel: UILabel!
    @IBOutlet weak var soundsView: UIView!
    
    let photoFileOutput = AVCapturePhotoOutput()
    let captureSession = AVCaptureSession()
    let movieOutput = AVCaptureMovieFileOutput()
    var activeInput: AVCaptureDeviceInput!
    var outputURL : URL!
    var currentCameraDevice: AVCaptureDevice?
    var thumbnailImage: UIImage?
    var recordedClips = [VideoClips]()
    var isRecording = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if setupCaptureSession() {
            DispatchQueue.global(qos: .background).async {
                self.captureSession.startRunning()
            }
        }
        setupView()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    @IBAction func captureButtonDidTapped(_ sender: Any) {
        if movieOutput.isRecording == false {
            startRecording()
        } else {
            stopRecording()
        }
    }
    
    func setupView(){
        captureButton.backgroundColor = UIColor(red: 254/255, green: 44/255, blue: 85/255, alpha: 1.0)
        captureButton.layer.cornerRadius =  68/2
        captureButtonRingView.layer.borderColor = UIColor(red: 254/255, green: 44/255, blue: 85/255, alpha: 0.5).cgColor
        captureButtonRingView.layer.borderWidth = 6
        captureButtonRingView.layer.cornerRadius = 85/2
        
        timeCounterLabel.backgroundColor = UIColor.black.withAlphaComponent(0.42)
        timeCounterLabel.layer.cornerRadius = 15
        timeCounterLabel.layer.borderColor = UIColor.white.cgColor
        timeCounterLabel.layer.borderWidth = 1.8
        timeCounterLabel.clipsToBounds = true
        
        soundsView.layer.cornerRadius = 12
        saveButton.layer.cornerRadius = 17
        saveButton.backgroundColor = UIColor(red: 254/255, green: 44/255, blue: 85/255, alpha: 1.0)
        saveButton.alpha = 0
        discardButton.alpha = 0
        
        
        
        
        
        [self.captureButton,self.captureButtonRingView,self.cancelButton,self.flipCameraButton,self.flipCameraLabel,self.speedLabel,self.speedButton,self.beautyLabel,self.beautyButton,self.filterLabel,self.filterButton,self.timerLabel,self.timerButton,self.galleryButton,self.effectsButton,self.soundsView,self.timeCounterLabel, self.saveButton, self.discardButton].forEach { subView in
            subView?.layer.zPosition = 1
        }
    }
    func setupCaptureSession() -> Bool  {
        captureSession.sessionPreset = AVCaptureSession.Preset.high
        
        // 1. setup inputs
        if let captureVideoDevice = AVCaptureDevice.default(for: AVMediaType.video),
           let captureAudioDevice =  AVCaptureDevice.default(for: AVMediaType.audio) {
            do {
                let inputVideo = try AVCaptureDeviceInput(device: captureVideoDevice)
                let inputAudio = try AVCaptureDeviceInput(device: captureAudioDevice)
                
                if captureSession.canAddInput(inputVideo) {
                    captureSession.addInput(inputVideo)
                    activeInput = inputVideo
                }
                if captureSession.canAddInput(inputAudio) {
                    captureSession.addInput(inputAudio)
                }
                
                if captureSession.canAddOutput(movieOutput){
                    captureSession.addOutput(movieOutput)
                }
                
            } catch let error{
             print("Could not  setup camera input:", error)
                return false
            }
        }
        // 2. setup input
        if captureSession.canAddOutput(photoFileOutput){
            captureSession.addOutput(photoFileOutput)
        }
        // 3. setup input
    let previewLayer  = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.frame
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        return true
    }
    
    @IBAction func flipButtonDidTapped(_ sender: Any) {
        captureSession.beginConfiguration()
        
        let currentInput = captureSession.inputs.first as? AVCaptureDeviceInput
        let newCameraDevice = currentInput?.device.position == .back ? getDeviceFront(position: .front) : getDeviceBack(position: .back)
        
        let newVideoInput  = try? AVCaptureDeviceInput(device: newCameraDevice!)
        
        if let inputs = captureSession.inputs as? [AVCaptureDeviceInput] {
            for input in inputs {
                captureSession.removeInput(input)
            }
        }
        
        if  captureSession.inputs.isEmpty {
            captureSession.addInput(newVideoInput!)
            activeInput = newVideoInput
        }
        
        if let microphone = AVCaptureDevice.default(for: .audio) {
            do {
                let micInput = try AVCaptureDeviceInput(device: microphone)
                if captureSession.canAddInput(micInput) {
                    captureSession.addInput(micInput)
                }
            } catch let micInputError {
                print("Error setting device audio input\(micInputError)")
            }
            
        }
        
        captureSession.commitConfiguration()
    }
    
    func getDeviceFront(position: AVCaptureDevice.Position) -> AVCaptureDevice?{
        AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
    }
    func getDeviceBack(position: AVCaptureDevice.Position) -> AVCaptureDevice?{
        AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
    }
    
    @IBAction func handleDismiss(_ sender: Any) {
        tabBarController?.selectedIndex = 0
    }
    func tempUrl() -> URL? {
        let directory = NSTemporaryDirectory() as NSString
        
        if directory != "" {
            let path = directory.appendingPathComponent(NSUUID().uuidString)
            return URL(fileURLWithPath: path)
        }
        return nil
    }
    
    func startRecording() {
        if movieOutput.isRecording == false {
            guard let connection = movieOutput.connection(with: .video) else {return}
            if connection.isVideoOrientationSupported{
                connection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationMode.auto
                let device = activeInput.device
                if device.isSmoothAutoFocusSupported {
                    do{
                        try device.lockForConfiguration()
                        device.isSmoothAutoFocusEnabled = false
                        device.unlockForConfiguration()
                    } catch{
//                        print("Error setting configuration: \(error) ")
                    }
                }
                outputURL = tempUrl()
                movieOutput.startRecording(to: outputURL, recordingDelegate: self)
                handleAnimateRecordButton()
                
            }
        }
    }
    func stopRecording() {
        if movieOutput.isRecording == true {
            movieOutput.stopRecording()
            handleAnimateRecordButton()
            print("STOP THE COUNT")
        }
    }
    func handleAnimateRecordButton() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            [weak self] in
            
        
            
            guard let self = self else {return}
            if self.isRecording == false {
                self.captureButton.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                self.captureButtonRingView.transform = CGAffineTransform(scaleX: 1.7, y: 1.7)
                
                self.saveButton.alpha = 0
                self.discardButton.alpha = 0
                
                [self.flipCameraButton,self.flipCameraLabel,self.speedLabel,self.speedButton,self.beautyLabel,self.beautyButton,self.filterLabel,self.filterButton,self.timerLabel,self.timerButton,self.galleryButton,self.effectsButton,self.soundsView,self.timeCounterLabel].forEach { subView in
                    subView?.isHidden = true
                }
            } else{
                self.captureButton.transform = CGAffineTransform.identity
                self.captureButton.layer.cornerRadius = 68/2
                self.captureButtonRingView.transform = CGAffineTransform.identity
                
                self.handleResetAllVisibilityToIdendity()
            }
        } ) {[weak self] onComplete in
            guard let self = self else {return}
            self.isRecording = !self.isRecording
         }
    }
    
    func handleResetAllVisibilityToIdendity(){
        
        if recordedClips.isEmpty == true {
            [self.flipCameraButton,self.flipCameraLabel,self.speedLabel,self.speedButton,self.beautyLabel,self.beautyButton,self.filterLabel,self.filterButton,self.timerLabel,self.timerButton,self.galleryButton,self.effectsButton,self.soundsView,self.timeCounterLabel].forEach { subView in
                subView?.isHidden = false
            }
            saveButton.alpha = 0
            discardButton.alpha = 0
            print("recordedClips:", "isEmpty")
        } else {
            [self.flipCameraButton,self.flipCameraLabel,self.speedLabel,self.speedButton,self.beautyLabel,self.beautyButton,self.filterLabel,self.filterButton,self.timerLabel,self.timerButton,self.galleryButton,self.effectsButton,self.soundsView,self.timeCounterLabel].forEach { subView in
                subView?.isHidden = true
            }
            saveButton.alpha = 1
            discardButton.alpha = 1
            print("recordedClips:", "is not Empty")
        }
    }


}

extension CreatePostViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: (any Error)?) {
        if error != nil {
            print("Error recording  movie: \(error?.localizedDescription ?? "")")
        } else {
            let urlOfVideoRecorded = outputURL! as URL
            
            guard let generatedThumbnailImage = generateVideoThumbnail(withfile: urlOfVideoRecorded) else {return}
            
            if currentCameraDevice?.position == .front {
                thumbnailImage = didTakePicture(generatedThumbnailImage, to: .upMirrored)
            } else {
                thumbnailImage = generatedThumbnailImage
            }
             
        }
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        let newRecordedClip = VideoClips(videoUrl: fileURL, cameraPosition: currentCameraDevice?.position)
        recordedClips.append(newRecordedClip)
        print("recordedClips:", recordedClips.count)
    }
    
    func didTakePicture(_ picture: UIImage, to orientation: UIImage.Orientation) -> UIImage {
        let flippedImage = UIImage(cgImage: picture.cgImage!, scale: picture.scale, orientation: orientation)
        return flippedImage
    }
    
    func generateVideoThumbnail(withfile videoUrl: URL) -> UIImage? {
        let  asset = AVAsset(url: videoUrl)
        
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        do {
            let cmTime = CMTimeMake(value: 1, timescale: 60)
            let thumbnailCGImage = try  imageGenerator.copyCGImage(at: cmTime, actualTime: nil )
            return UIImage(cgImage: thumbnailCGImage)
        } catch let error{
            print(error)
        }
        return nil
    }
    
}
