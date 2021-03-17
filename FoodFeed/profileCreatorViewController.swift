//
//  profileCreatorViewController.swift
//  FoodFeed
//
//  Created by Kate Roberts on 15/03/2021.
//  Copyright © 2021 Daniel Haight. All rights reserved.
//

import UIKit
import AVFoundation

let usingSimulator = true

/// <#Description#>
class profileCreatorViewController: UIViewController, AVCapturePhotoCaptureDelegate, UIImagePickerControllerDelegate, UIPickerViewDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet var pageTitle: UILabel!
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        
        if let following = UserDefaults.standard.object(forKey: "following")
        {
            UserDefaults.standard.set( UserDefaults.standard.object(forKey: "following") as! Array<String> + ["Human"],  forKey: "following")
        }
        else{
            UserDefaults.standard.set( ["Human"],  forKey: "following")
        }
    }
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet var nickname: UILabel!
    @IBOutlet var nameEntry: UITextField!
    
    @IBOutlet var describe: UILabel!
    @IBOutlet var describePicker: UIPickerView!
 
    
    @IBOutlet var nextButton: UIButton!
    
    lazy var previewView: UIImageView = {
        let imageView = UIImageView()
        /// stretch
        return imageView
    }()
    
    lazy var addButton: UIButton = {
         let button = UIButton()
         button.backgroundColor = UIColor(red: 186/255, green: 242/255, blue: 206/255, alpha: 1)
         button.setTitle("+", for: .normal)
         button.titleLabel?.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
         button.titleLabel?.font = UIFont(name: "TwCenMT-CondensedExtraBold", size: 106 )
         button.titleLabel?.textAlignment = .center
         button.layer.borderWidth = 5.0
         button.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
         button.addTarget(self, action: #selector(pictureInput), for: .touchUpInside)
         return button
     }()
    
    var image: UIImage?
    let haptic = UINotificationFeedbackGenerator()
    
    // MARK: AV init helpers
        let imagePicker = UIImagePickerController()
        var captureSession: AVCaptureSession!
        var stillImageOutput: AVCapturePhotoOutput!
        var videoPreviewLayer: AVCaptureVideoPreviewLayer!
        var usedCamera = false
    
    // MARK: Picker Helper
    
    var goodAtPickerData  = ["Funny", "Curious", "Smart", "Generous", "Sassy", "Sporty", "Thoughtful", "Independent", "Stubborn", "Good friend", "Stylish", "Confident", "Organised", "Creative", "Calm", "Hardworking", "Team player", "Loyal", "Reliable", "Studious", "Ambitious", "Playful", "Helpful", "Animal lover", "Arty", "Musical", "Quirky"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        layoutSubviews()
    
        setUpPicker()
        
        //Looks for single or multiple taps.
       //   let tap = UITapGestureRecognizer(target: self, action: #selector("tap"))

        stopsInteractionWhenTappedAround()
        nameEntry.delegate = self
       //  view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        haptic.prepare()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           if usedCamera == true {
               self.captureSession?.stopRunning()
           }
        if let following = UserDefaults.standard.object(forKey: "following")
        {
            UserDefaults.standard.set( UserDefaults.standard.object(forKey: "following") as! Array<String> + ["Human"],  forKey: "following")
        }
        else{
            UserDefaults.standard.set( ["Human"],  forKey: "following")
        }
       }
    

//    @objc func tap(){
//        nameEntry.
//
//    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 10
        } else {
            return 100
        }
    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
////        if component == 0 {
////            return "First \(row)"
////        } else {
////            return "Second \(row)"
////        }
//        return goodAtPickerData[ row % (goodAtPickerData.count - 1 )]
//    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let pickerLabel = UILabel()
        
        pickerLabel.adjustsFontSizeToFitWidth = true
        let titleData = goodAtPickerData[ row % (goodAtPickerData.count - 1 )]
        let myTitle = NSAttributedString(string: titleData as! String, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 20.0)!,NSAttributedString.Key.foregroundColor:UIColor.black])
        pickerLabel.attributedText = myTitle
  
        return pickerLabel
    }
    
    func setUpPicker(){
   

        describePicker.delegate = self
        describePicker.dataSource = self
    
    }
    
    func layoutSubviews(){
        
   
        
        let layoutUnit = (self.view.frame.height - (self.navigationController?.navigationBar.frame.height ?? 0))/8
        let margins = view.layoutMarginsGuide
        
        
    
        nextButton.layer.cornerRadius = 5.0
        
        let nameStack = UIStackView()
        nameStack.axis = .vertical
        nameStack.alignment = .leading
        nameStack.addArrangedSubview(nickname)
        nameStack.addArrangedSubview(nameEntry)
        nameStack.distribution = .fill
        
        let idStack = UIStackView()
        idStack.axis = .horizontal
        idStack.addArrangedSubview(nameStack)
       // idStack.alignment = .top
        
        
    
        
        profilePictureImageView.translatesAutoresizingMaskIntoConstraints = false
        profilePictureImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        profilePictureImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profilePictureImageView.layer.cornerRadius = 10.0
    
        idStack.addArrangedSubview(profilePictureImageView)
        view.addSubview(idStack)

        
        let adjectiveStack = UIStackView()
        adjectiveStack.axis = .vertical
        adjectiveStack.alignment = .leading
        
        adjectiveStack.addArrangedSubview(describe)
        adjectiveStack.addArrangedSubview(describePicker)
        adjectiveStack.addArrangedSubview(nextButton)
        
        view.addSubview(adjectiveStack)
        
        idStack.translatesAutoresizingMaskIntoConstraints = false
        adjectiveStack.translatesAutoresizingMaskIntoConstraints = false
        
        idStack.topAnchor.constraint(equalTo: pageTitle.bottomAnchor, constant: 50).isActive = true
        idStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        idStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        idStack.bottomAnchor.constraint(equalTo: adjectiveStack.topAnchor, constant: -50).isActive = true
        
        idStack.distribution = .fillProportionally
        idStack.spacing = 20.0
        idStack.alignment = .center
        
        nameEntry.translatesAutoresizingMaskIntoConstraints = false
        nameEntry.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6).isActive = true
        nameEntry.placeholder = "Write here."
        
        //adjectiveStack.bottomAnchor.constraint(equalTo: nextButton.topAnchor).isActive = true
        adjectiveStack.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        adjectiveStack.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        adjectiveStack.alignment = .center
        
    
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        nextButton.topAnchor.constraint(equalTo: adjectiveStack.bottomAnchor, constant: 100).isActive = true
        
        view.addSubview(nextButton)
        
        view.addSubview(previewView)
                 previewView.isHidden = true
                 previewView.translatesAutoresizingMaskIntoConstraints = false
                 previewView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                // foodImage.image = UIImage(named: "cracker.jpeg")
                 previewView.layer.borderWidth = 6.0
                 previewView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
                 
                 NSLayoutConstraint.activate([
                        previewView.topAnchor.constraint(equalTo: profilePictureImageView.topAnchor),
                        previewView.bottomAnchor.constraint(equalTo: profilePictureImageView.bottomAnchor),
                        previewView.leadingAnchor.constraint(equalTo: profilePictureImageView.leadingAnchor),
                        previewView.trailingAnchor.constraint(equalTo: profilePictureImageView.trailingAnchor)
                 ])
        //previewView.cornerRadius = 1.5*layoutUnit
        
        view.addSubview(addButton)
                addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: profilePictureImageView.topAnchor),
            addButton.bottomAnchor.constraint(equalTo: profilePictureImageView.bottomAnchor),
            addButton.leadingAnchor.constraint(equalTo: profilePictureImageView.leadingAnchor),
            addButton.trailingAnchor.constraint(equalTo: profilePictureImageView.trailingAnchor)
        ])
        
    }
    
    @objc func pictureInput(){
            addButton.alpha = 0.2
            if previewView.isHidden
            {
                 previewView.isHidden = false
                
                if usingSimulator == false
                {
                    recordTheFood()
                }
                else{
                    //captureImageView.isHidden = false
                    /// captureImageView.image = UIImage(named: "NoCameraPlaceholder.001.jpeg")
                    //saveAndDisplayImage(imageData: imageData)
                    pickFromCameraRoll()
                    previewView.isHidden = true
                }
            }
            else{
                previewView.isHidden = true
                
                haptic.notificationOccurred(.success)
                
                if AVCaptureDevice.authorizationStatus(for: .video) != .denied
                {
                    let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
                    stillImageOutput.capturePhoto(with: settings, delegate: self)
                }

            }
          
        }
    
    //MARK: Data Input Subroutines
      
      func launchCamera(){
          previewView.isHidden = false
          recordTheFood()
      }
      
      func pickFromCameraRoll(){
          imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary
                profilePictureImageView.isHidden = false
                present(imagePicker, animated: true, completion: nil)
          
      }
      
      // MARK: Functions to manage the image input
        func setupLivePreview() {
          let layoutUnit = (self.view.frame.height - (self.navigationController?.navigationBar.frame.height ?? 0))/8
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer.videoGravity = .resizeAspectFill
            videoPreviewLayer.connection?.videoOrientation = .portrait
          //videoPreviewLayer.cornerRadius = 1.5*layoutUnit
            previewView.layer.addSublayer(videoPreviewLayer)
        }
      
        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
              guard let imageData = photo.fileDataRepresentation()
                else { return }
             
            saveAndDisplayImage(imageData: imageData)
          
        }
    
    func saveAndDisplayImage(imageData: Data){
        image = UIImage(data: imageData) ?? UIImage(named: "onejpg")!
        profilePictureImageView.image = image
        profilePictureImageView.layer.masksToBounds = true
       // human = User(name: "Maxwell", profilePic: profilePictureImageView.image )
        botUser.human = User(name: "Maxwell", profilePic: profilePictureImageView.image )
        
        
        //            if let data = image!.jpegData(compressionQuality: 0.8) {
        let filename = getDocumentsDirectory().appendingPathComponent("U.jpeg")
        try! imageData.write(to: filename)
        //}
        /// performSegue(withIdentifier: presentState ?? "Undefined", sender: "dataInputViewController")
        //passData(dvc1: nextViewController)
        //nextViewController.formatImage()
        // nextViewController.foodImage.image = image
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
        
        func presentCameraSettings() {
            let alertController = UIAlertController(title: "Error",
                                                    message: "Camera access is denied",
                                                    preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .default))
            alertController.addAction(UIAlertAction(title: "Settings", style: .cancel) { _ in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: { _ in
                    })
                }
            })
            
            present(alertController, animated: true)
        }
        
        
        func checkCameraAccess() -> Bool {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .denied:
                print("Denied, request permission from settings")
                //presentCameraSettings()
                pickFromCameraRoll()
                return false
            case .restricted:
                print("Restricted, device owner must approve")
            case .authorized:
                print("Authorized, proceed")
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { success in
                    if success {
                        print("Permission granted, proceed")
                    } else {
                        print("Permission denied")
                    }
                }
            }
            
            return true
        }
        
        
        func recordTheFood() {

            if checkCameraAccess() == true {
                captureSession = AVCaptureSession()
                captureSession.sessionPreset = .medium
            
  //              guard let backCamera = AVCaptureDevice.devices().filter({ $0.position == .back })
  //                  .first else {
  //                      fatalError("No front facing camera found")
  //                  }
              
              guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front)
                  else{ fatalError("no camera")}
            
                do {
                    let input = try AVCaptureDeviceInput(device: frontCamera)
                    stillImageOutput = AVCapturePhotoOutput()
                
                    if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                        captureSession.addInput(input)
                        captureSession.addOutput(stillImageOutput)
                        setupLivePreview()
                    }
                }
                catch let error  {
                    print("Error Unable to initialize back camera:  \(error.localizedDescription)")
                }
            
                DispatchQueue.global(qos: .userInitiated).async { //[weak self] in
                    self.captureSession.startRunning()
                }
            
                DispatchQueue.main.async {
                    self.videoPreviewLayer.frame = self.previewView.bounds
                }
              
              //nextViewController.presentState = .AddFoodViewController
            }
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
          
            // Local variable inserted by Swift 4.2 migrator.
            let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
            
            if let userPickedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage {
                profilePictureImageView.image = userPickedImage
                //image = userPickedImage.scaleImage(toSize: CGSize(width: 150, height: 150)) ?? UIImage(named: "chaos.jpg")!
                image = userPickedImage ?? UIImage(named: "one.jpeg")!
                
            }
            else {
                if let userPickedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
                profilePictureImageView.image = userPickedImage
                //image = userPickedImage.scaleImage(toSize: CGSize(width: 150, height: 150)) ?? UIImage(named: "chaos.jpg")!
                image = userPickedImage ?? UIImage(named: "one.jpeg")!
                }
            }
            
            imagePicker.dismiss(animated: true){ [self] in profilePictureImageView.image = image
                
                botUser.human = User(name: "Maxwell", profilePic: profilePictureImageView.image )
                
                
                //            if let data = image!.jpegData(compressionQuality: 0.8) {
              //  let filename = getDocumentsDirectory().appendingPathComponent("U.jpeg")
               // try! imageData.write(to: filename)
            }
        }
        
        // MARK: User interaction handlers
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
        //  textField.endEditing(true)
            return true
        }
    
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})}

    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
        
    }
    
    func stopsInteractionWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissInteractions))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissInteractions() {
        nameEntry.endEditing(true)
    }
        
}


//extension profileCreatorViewController: UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder() // dismiss keyboard
//        return true
//    }
//}
