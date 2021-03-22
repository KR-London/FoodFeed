//
//  profileCreatorViewController.swift
//  FoodFeed
//
//  Created by Kate Roberts on 15/03/2021.
//  Copyright © 2021 Daniel Haight. All rights reserved.
//

import UIKit
import AVFoundation
import SoftUIView

let usingSimulator = true

/// <#Description#>
class profileCreatorViewController: UIViewController, AVCapturePhotoCaptureDelegate, UIImagePickerControllerDelegate, UIPickerViewDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var personalQualities = ["Nice", "Kind", "Brave"]

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
         button.backgroundColor = .xeniaGreen
         button.setTitle("+", for: .normal)
         button.titleLabel?.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
         button.titleLabel?.font = UIFont(name: "TwCenMT-CondensedExtraBold", size: 106 )
         button.titleLabel?.textAlignment = .center
       //  button.layer.borderWidth = 5.0
        // button.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
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
        
       
        view.backgroundColor = .mainBackground
        layoutSubviews()
        setUpPicker()
        
        whereIsMySQLite()
        loadJSON()

        stopsInteractionWhenTappedAround()
        nameEntry.delegate = self
        
        describePicker.delegate = self
       //  view.addGestureRecognizer(tap)
    }
    
    override var modalPresentationStyle: UIModalPresentationStyle {
        get { .fullScreen
        }
        set { assertionFailure("Shouldnt change that 😠") }
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
        if UserDefaults.standard.object(forKey: "following") != nil
        {
            UserDefaults.standard.set( UserDefaults.standard.object(forKey: "following") as! Array<String> + ["Human"],  forKey: "following")
        }
        else{
            UserDefaults.standard.set( ["Human"],  forKey: "following")
        }
       }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return goodAtPickerData.count - 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        switch component{
            case 0 : personalQualities[0] = goodAtPickerData[row]
            case 1: personalQualities[1] = goodAtPickerData[row]
            case 2: personalQualities[2] = goodAtPickerData[row]
            default: break
        }
        return "Why do I have to return here?"
    }
    
//    func pickerView( pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//
//
//        switch component{
//                   case 0 : personalQualities[0] = goodAtPickerData[row]
//                   case 1: personalQualities[1] = goodAtPickerData[row]
//                   case 2: personalQualities[2] = goodAtPickerData[row]
//                   default: break
//       }
//    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component{
                   case 0 : personalQualities[0] = goodAtPickerData[row]
                   case 1: personalQualities[1] = goodAtPickerData[row]
                   case 2: personalQualities[2] = goodAtPickerData[row]
                   default: break
       }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let pickerLabel = UILabel()
        
        pickerLabel.adjustsFontSizeToFitWidth = true
        let titleData = goodAtPickerData[ row % (goodAtPickerData.count - 1 )]
        let myTitle = NSAttributedString(string: titleData , attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 20.0)!,NSAttributedString.Key.foregroundColor:UIColor.black])
        pickerLabel.attributedText = myTitle
        pickerLabel.textAlignment = NSTextAlignment.center
  
        return pickerLabel
    }
    
    func setUpPicker(){
   

        describePicker.delegate = self
        describePicker.dataSource = self
    
    }
    
    func layoutSubviews(){
        
        
        //pageTitle.isHidden = true
       // profilePictureImageView.isHidden = true
       //nickname.isHidden = true
       // nameEntry.isHidden = true
       //describe.isHidden = true
       //describePicker.isHidden = true
        nextButton.isHidden = true
        
        let layoutUnit = 0.9*(self.view.frame.height - (self.navigationController?.navigationBar.frame.height ?? 0))/6
       // let margins = view.layoutMarginsGuide
        
        let softUIViewProfilePic = SoftUIView(frame: .init(x: self.view.frame.width - 20 - layoutUnit , y: layoutUnit, width: layoutUnit, height: layoutUnit))
        softUIViewProfilePic.cornerRadius = layoutUnit/2
        view.addSubview(softUIViewProfilePic)
        
        view.addSubview(profilePictureImageView)
        profilePictureImageView.translatesAutoresizingMaskIntoConstraints = false
        profilePictureImageView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        profilePictureImageView.layer.cornerRadius = layoutUnit/2
        
        NSLayoutConstraint.activate([
            profilePictureImageView.topAnchor.constraint(equalTo: softUIViewProfilePic.topAnchor),
            profilePictureImageView.bottomAnchor.constraint(equalTo: softUIViewProfilePic.bottomAnchor),
            profilePictureImageView.leadingAnchor.constraint(equalTo: softUIViewProfilePic.leadingAnchor),
            profilePictureImageView.trailingAnchor.constraint(equalTo: softUIViewProfilePic.trailingAnchor)
        ])
        
        let softUIViewNameEntry = SoftUIView(frame: .init(x:  20 , y: 1.5*layoutUnit, width: self.view.frame.width - 60 - layoutUnit, height: layoutUnit/2))
        softUIViewNameEntry.isSelected = true
        nameEntry.translatesAutoresizingMaskIntoConstraints = false
    //    softUIViewNameEntry.interaction = false
        //softUIViewNameEntry.setContentView(nameEntry)
        view.addSubview(softUIViewNameEntry)
        nameEntry.backgroundColor = .clear
        
        view.addSubview(nameEntry)
        
        // FIXME: this brings in a subtle bug that the very edges will irrevocably select softUIVoew
        NSLayoutConstraint.activate([
            nameEntry.topAnchor.constraint(equalTo: softUIViewNameEntry.topAnchor),
            nameEntry.bottomAnchor.constraint(equalTo: softUIViewNameEntry.bottomAnchor),
            nameEntry.leadingAnchor.constraint(equalTo: softUIViewNameEntry.leadingAnchor, constant: 5),
            nameEntry.trailingAnchor.constraint(equalTo: softUIViewNameEntry.trailingAnchor, constant: -5)
        ])
        
        
        let titleAttrs = [NSAttributedString.Key.foregroundColor: UIColor.xeniaGreen,
                          NSAttributedString.Key.font: UIFont(name: "Georgia-Bold", size: 36)!,
                          NSAttributedString.Key.textEffect: NSAttributedString.TextEffectStyle.letterpressStyle as NSString
        ]
        
        let string = NSAttributedString(string: "YOU", attributes: titleAttrs)
        pageTitle.attributedText = string
        
        pageTitle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pageTitle.centerYAnchor.constraint(equalTo: nameEntry.centerYAnchor, constant: -layoutUnit),
            // pageTitle.heightAnchor.constraint(equalToConstant: 0.75*layoutUnit),
            pageTitle.leadingAnchor.constraint(equalTo: nameEntry.leadingAnchor),
            pageTitle.trailingAnchor.constraint(equalTo: nameEntry.trailingAnchor, constant: 30 )
        ])//
        
        
        
        let attrs = [NSAttributedString.Key.foregroundColor: UIColor.xeniaGreen,
                     NSAttributedString.Key.font: UIFont(name: "Georgia-Bold", size: 24)!,
                     NSAttributedString.Key.textEffect: NSAttributedString.TextEffectStyle.letterpressStyle as NSString
        ]
        
        let string2 = NSAttributedString(string: "Nickname", attributes: attrs)
        nickname.attributedText = string2
        nickname.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nickname.topAnchor.constraint(equalTo: softUIViewProfilePic.topAnchor),
            nickname.bottomAnchor.constraint(equalTo: softUIViewNameEntry.topAnchor, constant: 10),
            nickname.leadingAnchor.constraint(equalTo: softUIViewNameEntry.leadingAnchor),
            nickname.trailingAnchor.constraint(equalTo: softUIViewNameEntry.trailingAnchor, constant: -5)
        ])
        

        let string3 = NSAttributedString(string: "Pick your personality", attributes: attrs)
        describe.attributedText = string3
        
    
        
        let adjectiveStack = UIStackView()
        adjectiveStack.axis = .vertical
        adjectiveStack.alignment = .leading
        adjectiveStack.addArrangedSubview(describe)
        adjectiveStack.addArrangedSubview(describePicker)
        
       
       // adjectiveStack.addArrangedSubview(nextButton)
        view.addSubview(adjectiveStack)
        if #available(iOS 14.0, *) {
            describePicker.translatesAutoresizingMaskIntoConstraints = false
            describePicker.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        }

        adjectiveStack.translatesAutoresizingMaskIntoConstraints = false

        adjectiveStack.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        adjectiveStack.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        adjectiveStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 3*layoutUnit).isActive = true
        
        describe.translatesAutoresizingMaskIntoConstraints = false
        describe.leadingAnchor.constraint(equalTo: adjectiveStack.leadingAnchor, constant: 20).isActive = true
        
       // adjectiveStack.topAnchor.constraint(equalTo: softUIViewNameEntry.bottomAnchor) = true
       // adjectiveStack.topAnchor.constraint(equalToConstant: 2.5*layoutUnit).isActive = true
        
        
        adjectiveStack.alignment = .center


        let softUIViewButton = SoftUIView(frame: .init(x: 20, y: 5.5*layoutUnit, width: self.view.frame.width - 40 , height: 0.7*layoutUnit))
        view.addSubview(softUIViewButton)
        let okLabel = UILabel()
        //okLabel.text = "OK"
        okLabel.attributedText = NSAttributedString(string: "OK", attributes: titleAttrs)
       // softUIViewButton.setContentView(okLabel)
        
        softUIViewButton.addTarget(self, action: #selector(segueToSummary), for: .touchUpInside)
        
        okLabel.textAlignment = .center
        view.addSubview(okLabel)
        
        okLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            okLabel.topAnchor.constraint(equalTo: softUIViewButton.topAnchor),
            okLabel.bottomAnchor.constraint(equalTo: softUIViewButton.bottomAnchor),
            okLabel.leadingAnchor.constraint(equalTo: softUIViewButton.leadingAnchor),
            okLabel.trailingAnchor.constraint(equalTo: softUIViewButton.trailingAnchor)
        ])
        
        
        
//        softUIView.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
//        
//        @objc func handleTap() {
//            // code
//        }
 //       nextButton.translatesAutoresizingMaskIntoConstraints = false
//
//        nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
//        nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
//        nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
//        nextButton.topAnchor.constraint(equalTo: adjectiveStack.bottomAnchor, constant: 100).isActive = true
//
//        view.addSubview(nextButton)
//
        view.addSubview(previewView)
                 previewView.isHidden = true
                 previewView.translatesAutoresizingMaskIntoConstraints = false
                 previewView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)

                 NSLayoutConstraint.activate([
                        previewView.topAnchor.constraint(equalTo: profilePictureImageView.topAnchor),
                        previewView.bottomAnchor.constraint(equalTo: profilePictureImageView.bottomAnchor),
                        previewView.leadingAnchor.constraint(equalTo: profilePictureImageView.leadingAnchor),
                        previewView.trailingAnchor.constraint(equalTo: profilePictureImageView.trailingAnchor)
                 ])

        view.addSubview(addButton)
                addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: profilePictureImageView.topAnchor),
            addButton.bottomAnchor.constraint(equalTo: profilePictureImageView.bottomAnchor),
            addButton.leadingAnchor.constraint(equalTo: profilePictureImageView.leadingAnchor),
            addButton.trailingAnchor.constraint(equalTo: profilePictureImageView.trailingAnchor)
        ])

        previewView.layer.cornerRadius = layoutUnit/2
        addButton.layer.cornerRadius = layoutUnit/2

    }
    
    @objc func segueToSummary(){
        performSegue(withIdentifier: "summaryProfile", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

       if segue.identifier == "summaryProfile" {
           if let destVC = segue.destination as? profileCardViewController {
              
              
            let human = User(name: nameEntry.text ?? "Buddy", profilePic: profilePictureImageView.image, personalQualities: personalQualities)
            
            botUser.human = human 
                
            destVC.human = human

           }
       }
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
         // let layoutUnit = (self.view.frame.height - (self.navigationController?.navigationBar.frame.height ?? 0))/8
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
        botUser.human = User(name: "Maxwell", profilePic: profilePictureImageView.image, personalQualities: nil )
        
        
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
            @unknown default:
                    print("Gosh - AVCapture did not have that option when this code was writte. ")
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
                image = userPickedImage 
                
            }
            else {
                if let userPickedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
                profilePictureImageView.image = userPickedImage
                //image = userPickedImage.scaleImage(toSize: CGSize(width: 150, height: 150)) ?? UIImage(named: "chaos.jpg")!
                    image = userPickedImage
                }
            }
            
            imagePicker.dismiss(animated: true){ [self] in profilePictureImageView.image = image
                
                botUser.human = User(name: "Maxwell", profilePic: profilePictureImageView.image, personalQualities: nil )
                
                
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

extension profileCreatorViewController{
 
    func saveItems(){
        do{
            
            try  context.save()
            
        } catch {
            print("Error saving context \(error)")
        }
        
    }
    
    func loadJSON(){
        
        let filePath = Bundle.main.resourcePath!
        let data = try! String(contentsOfFile: filePath + "/storyline.txt",
                               encoding: String.Encoding.utf8).data(using: .utf8)
        
        //  let decoder = JSONDecoder()
        
        if let parsedData = try! JSONSerialization.jsonObject(with: data!) as? [[String:Any]] {
            for item in parsedData {
                let newPost = PostData(context: context)
                
                print(item)
                for (category, value) in item{
                    print(value)
                    switch category{
                        case "day": newPost.day = value as! Int16
                        case "id": newPost.id = value as! Int32
                        case "bigtext": newPost.bigtext = value as? String
                        case "caption": newPost.caption = value as? String
                        case "type": newPost.type = value as? String
                        case "gif":  newPost.gif = value as? String
                        case "image": newPost.image = value as? String
                        case "video":  newPost.video = value as? String
                        case "hashtag": newPost.hashtag = value as? String
                        case "votea": newPost.votea = value as? String
                        case "voteb": newPost.voteb = value as? String
                        default: break
                    }
                    
                }
                saveItems()
            }
        }
        
        //  decoder.decode(newPost.self, from: textContent )
        //
    }
    
    func whereIsMySQLite() {
        let path = FileManager
            .default
            .urls(for: .applicationSupportDirectory, in: .userDomainMask)
            .last?
            .absoluteString
            .replacingOccurrences(of: "file://", with: "")
            .removingPercentEncoding
        
        print(path ?? "Not found")
    }

    
}
