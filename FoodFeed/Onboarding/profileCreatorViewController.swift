//
//  profileCreatorViewController.swift
//  FoodFeed
//

import UIKit
import AVFoundation
import SoftUIView

let usingSimulator = false

class profileCreatorViewController: UIViewController, AVCapturePhotoCaptureDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate, UIWindowSceneDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var nextButton : CherryButton
    
    var profileSet = false {
        didSet{
            saveProfile()
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("Storyboard are a pain")
    }
    
    required init?(frame: CGRect) {
        self.nextButton = CherryButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        super.init(nibName: nil, bundle: nil)
    }
    
    // I used to do this on a picker - but it caused stress in testing.
    // Now hard coded the personal qualities
    // The testing suggestions were to integrate populating this into the main flow of the app with Buzzfeed style quizes
    var personalQualities = ["Nice", "Kind", "Brave"]
  
   // @IBOutlet var nameEntry: UITextField!
    
    var nameEntry = UITextField()
    var profilePictureImageView =   UIImageView()
    var nickname = UILabel()
    var pageTitle = UILabel()
    
//    var describe = UILabel()
//    var describePicker = UIPickerView()
//
//
    lazy var previewView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    lazy var addButton: UIButton = {
         let button = UIButton()
         button.backgroundColor = .xeniaGreen
         button.setTitle("+", for: .normal)
         button.titleLabel?.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
         button.titleLabel?.font = UIFont(name: "TwCenMT-CondensedExtraBold", size: 106 )
         button.titleLabel?.textAlignment = .center
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
       // setUpPicker()
        
        whereIsMySQLite()
        loadJSON()

        stopsInteractionWhenTappedAround()
        nameEntry.delegate = self
        //describePicker.delegate = self
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("Editing")
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
            saveProfile()
       }
    
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 3
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return goodAtPickerData.count - 1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//
//        switch component{
//            case 0 : personalQualities[0] = goodAtPickerData[row]
//            case 1: personalQualities[1] = goodAtPickerData[row]
//            case 2: personalQualities[2] = goodAtPickerData[row]
//            default: break
//        }
//
//        return "Why do I have to return here?"
//    }
//
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        switch component{
//                   case 0 : personalQualities[0] = goodAtPickerData[row]
//                   case 1: personalQualities[1] = goodAtPickerData[row]
//                   case 2: personalQualities[2] = goodAtPickerData[row]
//                   default: break
//       }
//    }
//
//    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
//
//        let pickerLabel = UILabel()
//
//        pickerLabel.adjustsFontSizeToFitWidth = true
//        let titleData = goodAtPickerData[ row % (goodAtPickerData.count - 1 )]
//        let myTitle = NSAttributedString(string: titleData , attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 20.0)!,NSAttributedString.Key.foregroundColor:UIColor.black])
//        pickerLabel.attributedText = myTitle
//        pickerLabel.textAlignment = NSTextAlignment.center
//
//        return pickerLabel
//    }
//
//    func setUpPicker(){
//
//        describePicker.delegate = self
//        describePicker.dataSource = self
//
//    }
    
    func layoutSubviews(){
 
        nextButton.isHidden = true
        
        let layoutUnit = 0.9*(self.view.frame.height - (self.navigationController?.navigationBar.frame.height ?? 0))/6
        
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
        view.addSubview(softUIViewNameEntry)
        
        nameEntry = UITextField(frame: .init(x:  20 , y: 1.5*layoutUnit, width: self.view.frame.width - 60 - layoutUnit, height: layoutUnit/2))
        nameEntry.backgroundColor = .clear
        nameEntry.placeholder = "Write name here"
        nameEntry.delegate = self
        
        view.addSubview(nameEntry)
        
        // FIXME: this brings in a subtle bug that the very edges will irrevocably select softUIView
        nameEntry.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameEntry.topAnchor.constraint(equalTo: softUIViewNameEntry.topAnchor),
            nameEntry.bottomAnchor.constraint(equalTo: softUIViewNameEntry.bottomAnchor),
            nameEntry.leadingAnchor.constraint(equalTo: softUIViewNameEntry.leadingAnchor, constant: 5),
            nameEntry.trailingAnchor.constraint(equalTo: softUIViewNameEntry.trailingAnchor, constant: -5)
        ])
        
        let titleAttrs = [NSAttributedString.Key.foregroundColor: UIColor.textTint,
                          NSAttributedString.Key.font: UIFont(name: "Georgia-Bold", size: 36)!,
                          NSAttributedString.Key.textEffect: NSAttributedString.TextEffectStyle.letterpressStyle as NSString
        ]
        
        let string = NSAttributedString(string: "YOU", attributes: titleAttrs)
        pageTitle.attributedText = string
        view.addSubview(pageTitle)
        pageTitle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pageTitle.centerYAnchor.constraint(equalTo: nameEntry.centerYAnchor, constant: -layoutUnit),
            pageTitle.leadingAnchor.constraint(equalTo: nameEntry.leadingAnchor),
            pageTitle.trailingAnchor.constraint(equalTo: nameEntry.trailingAnchor, constant: 30 )
        ])

        let attrs = [NSAttributedString.Key.foregroundColor: UIColor.xeniaGreen,
                     NSAttributedString.Key.font: UIFont(name: "Georgia-Bold", size: 24)!,
                     NSAttributedString.Key.textEffect: NSAttributedString.TextEffectStyle.letterpressStyle as NSString
        ]
        
        let string2 = NSAttributedString(string: "Nickname", attributes: attrs)
        nickname.attributedText = string2
        view.addSubview(nickname)
        nickname.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nickname.topAnchor.constraint(equalTo: softUIViewProfilePic.topAnchor),
            nickname.bottomAnchor.constraint(equalTo: softUIViewNameEntry.topAnchor, constant: 10),
            nickname.leadingAnchor.constraint(equalTo: softUIViewNameEntry.leadingAnchor),
            nickname.trailingAnchor.constraint(equalTo: softUIViewNameEntry.trailingAnchor, constant: -5)
        ])
  
        let softUIViewButton = SoftUIView(frame: .init(x: 20, y: 5.5*layoutUnit, width: self.view.frame.width - 40 , height: 0.7*layoutUnit))
        view.addSubview(softUIViewButton)
        let okLabel = UILabel()
        okLabel.attributedText = NSAttributedString(string: "OK", attributes: titleAttrs)
        
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
        view.bringSubviewToFront(nameEntry)
    }
    
    @objc func segueToSummary(){
        
        let nextViewController = profileCardViewController()
        botUser.human.name = nameEntry.text ?? "Frog"
        
        DispatchQueue.main.async{ [weak self] in
            UserDefaults.standard.set(self!.nameEntry.text ?? "Bud", forKey: "userName")
            let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            if let data = self!.profilePictureImageView.image!.jpegData(compressionQuality: 1){
                let url = documents.appendingPathComponent("userSetProfilePic.jpeg")
                do {
                    try data.write(to: url)
                    UserDefaults.standard.set(url, forKey: "userSetPic")
                }
                catch {
                    print("Unable to Write Data to Disk (\(error))")
                }
            }
        }
        
        present(nextViewController, animated: true, completion: nil)      
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        botUser.human.name = nameEntry.text ?? "Frog"
//       if segue.identifier == "summaryProfile"
//        {
//
//
//           if let _ = segue.destination as? profileCardViewController {
//               botUser.human.name = nameEntry.text ?? ""
//           }
//       }
//
//
//      let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        if let data = profilePictureImageView.image!.jpegData(compressionQuality: 1){
//                            let url = documents.appendingPathComponent("userSetProfilePic.jpeg")
//                            do {
//                                try data.write(to: url)
//                                UserDefaults.standard.set(url, forKey: "userSetPic")
//                            }
//                            catch {
//                                print("Unable to Write Data to Disk (\(error))")
//                            }
//                        }
            
    }
    
    func saveProfile(){

        if UserDefaults.standard.object(forKey: "following") != nil
        {
            UserDefaults.standard.set( UserDefaults.standard.object(forKey: "following") as! Array<String> + ["Human"],  forKey: "following")
        }
        else{
            UserDefaults.standard.set( ["Human"],  forKey: "following")
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
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer.videoGravity = .resizeAspectFill
            videoPreviewLayer.connection?.videoOrientation = .portrait
            previewView.layer.addSublayer(videoPreviewLayer)
    }
      
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
            guard let imageData = photo.fileDataRepresentation()
            else {
                return
            }
            saveAndDisplayImage(imageData: imageData)
    }
    
    func saveAndDisplayImage(imageData: Data){
        image = UIImage(data: imageData) ?? UIImage(named: "onejpg")!
        profilePictureImageView.image = image
        profilePictureImageView.layer.masksToBounds = true
        botUser.human = User(name: nameEntry.text ?? "", profilePic: profilePictureImageView.image, personalQualities: ["Kind", "Smart", "Brave"] )

        let filename = getDocumentsDirectory().appendingPathComponent("U.jpeg")
        try! imageData.write(to: filename)
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
            }
    }
        
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
          
            let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
            
            if let userPickedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage {
                profilePictureImageView.image = userPickedImage
                image = userPickedImage
            }
            else {
                if let userPickedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
                profilePictureImageView.image = userPickedImage
                    image = userPickedImage
                }
            }
            
        imagePicker.dismiss(animated: true){ [weak self] in self?.profilePictureImageView.image = self?.image
                
            botUser.human = User(name: self?.nameEntry.text ?? "Maxwell", profilePic: self?.profilePictureImageView.image, personalQualities: nil )
            }
        }
        
   // MARK: User interaction handlers
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
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
        let sourceData = "/Day" + String(day) + ".txt"
        guard let data = try? String(contentsOfFile: filePath + sourceData , encoding: String.Encoding.utf8).data(using: .utf8) else {return}
        
        if let parsedData = try? JSONSerialization.jsonObject(with: data) as? [[String:Any]] {
            var i = Int32(0)
            for item in parsedData {
                let newPost = PostData(context: context)
                newPost.id = i 
                for (category, value) in item{
                    switch category{
                        case "day": newPost.day = value as! Int32
                       // case "id": newPost.id = i as! Int32
                        case "bigtext": newPost.bigtext = value as? String
                        case "caption": newPost.caption = value as? String
                        case "type": newPost.type = value as? String
                        case "gif":  newPost.gif = value as? String
                        case "image": newPost.image = value as? String
                        case "video":  newPost.video = value as? String
                        case "hashtag": newPost.hashtag = value as? String
                        case "votea": newPost.votea = value as? String
                        case "voteb": newPost.voteb = value as? String
                        case "votec": newPost.votec = value as? String
                        case "user": newPost.user = value as? String
                        default: break
                    }
                }
                saveItems()
                i = i + 1
            }
        }
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

// refactor to avoid this repeated codes

extension PostView{
    
   // let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveItems(){
        do{
            
            try  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext.save()
            
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    func loadJSON(){
        
        let filePath = Bundle.main.resourcePath!
        let sourceData = "/Day" + String(day) + ".txt"
        guard let data = try? String(contentsOfFile: filePath + sourceData , encoding: String.Encoding.utf8).data(using: .utf8) else {return}
        
        if let parsedData = try? JSONSerialization.jsonObject(with: data) as? [[String:Any]] {
            var i = Int32(0)
            for item in parsedData {
                let newPost = PostData(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext )
                newPost.id = i
                for (category, value) in item{
                    switch category{
                        case "day": newPost.day = value as! Int32
                                // case "id": newPost.id = i as! Int32
                        case "bigtext": newPost.bigtext = value as? String
                        case "caption": newPost.caption = value as? String
                        case "type": newPost.type = value as? String
                        case "gif":  newPost.gif = value as? String
                        case "image": newPost.image = value as? String
                        case "video":  newPost.video = value as? String
                        case "hashtag": newPost.hashtag = value as? String
                        case "votea": newPost.votea = value as? String
                        case "voteb": newPost.voteb = value as? String
                        case "votec": newPost.votec = value as? String
                        case "user": newPost.user = value as? String
                        default: break
                    }
                }
                saveItems()
                i = i + 1
            }
        }
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
