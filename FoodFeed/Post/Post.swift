import Foundation
import AVFoundation
import AVKit
import UIKit
import Speech
import SoftUIView
import SwiftyGif
import CoreData
import youtube_ios_player_helper
import Alamofire
import AlamofireImage
import GiphyUISDK


let humanAvatar = AvatarView()

@IBDesignable
final class AvatarView: UIView {
    private let margin: CGFloat = 0.5
    // 2
    let imageView = UIImageView()
    
    struct State {
        let image: UIImage
        let name: String
    }
        
    func setup() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        self.backgroundColor = .white
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: margin),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -margin),
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: margin),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -margin),
            NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: imageView, attribute: .width, multiplier: 1, constant: 0)
            
        ])
        

//        override func viewDidAppear(){
//            imageView.reloadInputViews()
//        }
        
     //   CommentsView.
    }
    
    // MARK: UIView
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = 20  //(imageView.frame.width) / 2
        self.layer.cornerRadius = 20 //self.frame.width / 2
        
        
      
        self.layer.masksToBounds = true
       //self.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
       // self.layer.borderWidth = 2
        self.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.contentMode = .scaleAspectFill
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 60, height: 60)
    }
    
    func update(state: State) {
        imageView.image = state.image
        print("Avatar loading" + state.name)
    }
}

//#if canImport(SwiftUI) && DEBUG
//import SwiftUI
//@available(iOS 13.0, *)
//struct AvatarViewPreview: PreviewProvider {
//    static var previews: some View {
//                UIViewPreview {
//                    let image = UIImage(named: "guy_profile_pic.jpeg")!
//                    let view = AvatarView()
//                    view.update(
//                        state: AvatarView.State(image: image)
//                    )
//                    return view
//                }
//                .previewLayout(.sizeThatFits)
//                .background(Color.black)
//    }
//}
//#endif

final class LikeView: UIView {
    struct State {
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
    }
    
    func update(state: State) {
    }
}

class PostView: UIView {
    
    struct State {
        //var tag: Model.Tag?
        var avatar: AvatarView.State
        var media: MediaView.State
        var interaction: InteractionView.State
        var tag: String?
    }
    
    let stackView = UIStackView()
    let controlsStack = UIStackView()
    let pageTitleHashtag = UILabel.titleLabel()
    let avatarView = AvatarView()
    let mediaView = MediaView()
   // let bigTextView = BigTextView()
    let interactionView = InteractionView()
    let settingsButton = UIButton()
    var didPause = false
    

    
    var delegate : FeedViewInteractionDelegate?
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    init(frame: CGRect, feed: Feed) {
        super.init(frame: frame)
        
        setup(feed: feed)
      //  tagLabel = feed.
        
       backgroundColor = .postBackground
        
        switch feed.state{
            case .text(let bigText, let caption, let hashtag, let votea, let voteb, let character):
                
                let profilePic = profilePicture(who: character)
                self.update(state: PostView.State(
                    avatar: AvatarView.State( image: profilePic, name: character.rawValue),
                    media: MediaView.State(filename: bigText, captionText: caption, votea: votea , voteb: voteb),
                    interaction: InteractionView.State(),
                    tag: hashtag
                ))
                if let tag = hashtag{
                    pageTitleHashtag.text = tag
//                    if tag == "Getting to know "{
//                        pageTitle.text = tag + botUser.human.name
//                    }
//                    else{
//                        pageTitle.text = tag
//                    }
                }
                self.bringSubviewToFront(mediaView)
              //  mediaView.isHidden == true
            case .gif(let gifName, let caption, let hashtag, let who):
                let profilePic = profilePicture(who: who)
                self.update(state: PostView.State(
                    avatar: AvatarView.State( image: profilePic, name: who.rawValue),
                    media: MediaView.State(filename: gifName, captionText: caption, votea: "", voteb: ""),
                    interaction: InteractionView.State(),
                    tag: hashtag
                ))
                pageTitleHashtag.text = hashtag
                self.bringSubviewToFront(mediaView)
            case .image(let imageName, let caption, let hashtag, let who):
                let profilePic = profilePicture(who: who)
                self.update(state: PostView.State(
                    avatar: AvatarView.State( image: profilePic, name: who.rawValue),
                    media: MediaView.State(filename: imageName,captionText: caption, votea: "", voteb: ""),
                    interaction: InteractionView.State(),
                    tag: hashtag
                ))
                self.bringSubviewToFront(mediaView)
                pageTitleHashtag.text = hashtag
            case .video(let videoName, let hashtag, let who):
                let profilePic = profilePicture(who: who)
                self.update(state: PostView.State(
                    avatar: AvatarView.State( image: profilePic, name: who.rawValue ),
                    media: MediaView.State(filename: videoName, captionText: nil, votea: "",voteb: ""),
                    interaction: InteractionView.State(),
                    tag: hashtag
                ))
               self.bringSubviewToFront(mediaView)
                pageTitleHashtag.text = hashtag
            case .poll(let caption, let votea, let voteb, let votec, let hashtag, let who):
//                if let tag = hashtag{
//                 pageTitleHashtag.text = tag + botUser.human.name
//                }
                print("This is a poll. I want to somehow swap out the media view for the interaction view ideally - or otherwise make a frankenstein Media view ")
                let profilePic = profilePicture(who: who)
                self.update(state: PostView.State(
                    avatar: AvatarView.State( image: profilePic, name: who.rawValue ),
                    media: MediaView.State(),
                    interaction: InteractionView.State(caption: caption, votea: votea, voteb: voteb, votec: votec),
                    tag: hashtag ?? "Getting to know " + botUser.human.name
                ))
                // QUESTION: Why did I not need to do this here?
                //self.bringSubviewToFront(mediaView)
        
            case .question(caption: let caption, hashtag: let hashtag, let who):
                print("This is a question. I want to somehow swap out the media view for the interaction view ideally - or otherwise make a frankenstein Media view ")
                let profilePic = profilePicture(who: who)
                self.update(state: PostView.State(
                    avatar: AvatarView.State( image: profilePic, name: who.rawValue ),
                    media: MediaView.State(),
                    interaction: InteractionView.State(caption: caption),
                    tag: hashtag
                ))
               // tagLabel.text = hashtag
//            case .photoPrompt(caption: let caption):
//                print("This is a photo prompt ")
//                self.update(state: PostView.State(
//                    avatar: AvatarView.State(image: try! UIImage(imageName: "guy_profile_pic.jpeg")!),
//                    media: MediaView.State(),
//                    interaction: InteractionView.State(caption: caption)
//                ))
            default: return
        }
        
//        self.update(state: PostView.State(
//
//            //FIXME: Refactor
//            // tag: Model.Tag(rawValue: "#this is tag"),
//            avatar: AvatarView.State(image: try! UIImage(imageName: "guy_profile_pic.jpeg")!),
//            media: MediaView.State(filename: feed.gif)
//        ))
        
//
//        if feed.state == .text(let bigText) { [self] in
//            mediaView.isHidden == true
//        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup(feed: Feed) {
        
//        if feed.state == .poll{
//            setupMediaView()
//        }
        
        // MARK: Where views are placed
        setupMediaView()
        
        if feed.id  == -1 {
            setUpResetButtons()
        }
        else{
           
            setupStackView()
            setupTag()
            
            setupInteractionView()
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            addGestureRecognizer(tap)
            setupRightView()
            setupAvatarView()
        }
        
       
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        
        didPause = !didPause
        if didPause{
            mediaView.pause()
        }
        else{
            mediaView.play()
        }
    }
    
    func pause(){
        mediaView.pause()
    }
    
    func setup() {
        setupMediaView()
        setupStackView()
        setupTag()
        setupRightView()
    }
    
    func setupStackView() {
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        stackView.alignment = .leading
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    func setupMediaView() {
        
        addSubview(mediaView)
        mediaView.translatesAutoresizingMaskIntoConstraints = false
        mediaView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        mediaView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        mediaView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        mediaView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    

    
    func setupInteractionView() {
        
        addSubview(interactionView)
        interactionView.translatesAutoresizingMaskIntoConstraints = false
        interactionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        interactionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        interactionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        interactionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        interactionView.isUserInteractionEnabled = true
    }
    
//    func setupBigTextView() {
//        addSubview(bigTextView)
//        bigTextView.translatesAutoresizingMaskIntoConstraints = false
//        bigTextView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
//        bigTextView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
//        bigTextView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        bigTextView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//    }
//
    func setUpResetButtons()
    {
        
        let softButton = SoftUIView(frame: CGRect(x: 1, y: self.frame.height - 101, width: 100, height: 100))
        softButton.cornerRadius = 50
        
        let label = UILabel()
        label.font = UIFont.init(name: "Georgia", size: 60)
        label.text =  "\u{2672}"
        
        label.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        label.textAlignment = .center
        label.textColor = .darkText
        softButton.setContentView(label)
        softButton.addTarget(self, action: #selector(resetUserDefaults), for: .touchUpInside)
        self.addSubview(softButton)
    }

    
    func setupRightView() {
        addSubview(controlsStack)
        controlsStack.axis = .vertical

        //FIXME: Hiddne like button because i won't be able to do anything with it this time around 
       // let lView = likeView()
        //controlsStack.addArrangedSubview(avatarView)
       // controlsStack.addArrangedSubview(lView)
       // controlsStack.setCustomSpacing(36, after: lView)
        //controlsStack.addArrangedSubview(commentView())
        controlsStack.isLayoutMarginsRelativeArrangement = true
        controlsStack.spacing = 24
        controlsStack.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        controlsStack.widthAnchor.constraint(equalToConstant: 120).isActive = true
        controlsStack.translatesAutoresizingMaskIntoConstraints = false
        controlsStack.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        controlsStack.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    }
    
    func setupAvatarView() {
        
        addSubview(avatarView)
        bringSubviewToFront(avatarView)
        
        var thirdScreenHeight = UIScreen.main.bounds.height / 3
//        avatarView.backgroundColor = .yellow
//
//        avatarView.layer.cornerRadius = 20
//        avatarView.layer.masksToBounds = true
//        avatarView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//        avatarView.layer.borderWidth = 2
//        avatarView.backgroundColor = .white
//        avatarView.contentMode = .scaleAspectFill
        //pic.image = profilePic
        let margins = self.layoutMarginsGuide

        
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarView.bottomAnchor.constraint(equalTo: margins.topAnchor, constant: thirdScreenHeight),
            avatarView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            avatarView.heightAnchor.constraint(equalToConstant: 60),
            avatarView.widthAnchor.constraint(equalToConstant: 60)
        ])
        
        
        
//        avatarView.translatesAutoresizingMaskIntoConstraints = false
//        avatarView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
//        avatarView.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        avatarView.heightAnchor.constraint(equalToConstant: 100).isActive = true
//        avatarView.bottomAnchor.constraint(equalTo:  .bottomAnchor).isActive = true
    }
    
    func likeView() -> UIView {
        let image: UIImage?
        if #available(iOS 13.0, *) {
            image = UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(scale: UIImage.SymbolScale.large))
        } else {
            image = nil
        }
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .white
        return imageView
    }

    func commentView() -> UIView {
        let image: UIImage?
        if #available(iOS 13.0, *) {
            image = UIImage(systemName: "plus.message", withConfiguration: UIImage.SymbolConfiguration(scale: UIImage.SymbolScale.large))
        } else {
            image = nil
        }
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .white
        return imageView
    }
    
    func setupTag() {
        let textStack = UIStackView()
        textStack.alignment = .leading
        textStack.distribution = .equalCentering
        textStack.axis = .vertical
        let xxx = UILabel.usernameLabel()
        //xxx.text = T
        textStack.addArrangedSubview(pageTitleHashtag)
        textStack.addArrangedSubview(xxx)
        addSubview(textStack)
        textStack.translatesAutoresizingMaskIntoConstraints = false
        //textStack.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor, constant: 16).isActive = true
       // textStack.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor).isActive = true
        textStack.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor, constant: 16).isActive = true
        textStack.centerXAnchor.constraint(equalTo: self.layoutMarginsGuide.centerXAnchor).isActive = true
        textStack.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func update(state: State) {
        if let tag = state.tag{
            pageTitleHashtag.text = tag
            pageTitleHashtag.textColor = .textTint
        }
        avatarView.update(state: state.avatar)
        mediaView.update(state: state.media)
        interactionView.update(state: state.interaction)
        
    }
    
    @objc func resetUserDefaults(sender: UIButton!) {
        UserDefaults.standard.removeObject(forKey: "loginRecord")
        UserDefaults.standard.removeObject(forKey: "following")
        
        /// delete database
        
        clearAllCoreData()
        
//        let path = FileManager
//            .default
//            .urls(for: .applicationSupportDirectory, in: .userDomainMask)
//            .last?
//            .absoluteString
//            .replacingOccurrences(of: "file://", with: "")
//            .removingPercentEncoding
//
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        //let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
////        let persistentStoreURL =
//
//        do {
//            try context.persistentStoreCoordinator.destroyPersistentStoreAtURL(path + "FoodFeed.sql", withType: NSSQLiteStoreType, options: nil)
//
//        } catch {
//            // Error Handling
//        }
        
//        do{
//            try print(container.description)
//            try container.persistentStoreCoordinator.destroyPersistentStore(at: <#T##URL#>, ofType: <#T##String#>, options: <#T##[AnyHashable : Any]?#>)
//        }
        

        
   //     let container = NSPersistentContainer(name: "FoodFeed")
        
   //     container.
    }
}

public func clearAllCoreData() {
    let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    let entities = container.managedObjectModel.entities
    entities.flatMap({ $0.name }).forEach(clearDeepObjectEntity)
}

private func clearDeepObjectEntity(_ entity: String) {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //let context = persistentContainer.viewContext
    
    let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
    
    do {
        try context.execute(deleteRequest)
        try context.save()
    } catch {
        print ("There was an error")
    }
}

extension UILabel {
    static func titleLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .textTint
        label.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.bold)
        label.adjustsFontForContentSizeCategory = true
        return label
    }
}

extension UILabel {
    static func captionLabel() -> UILabel {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        return label
    }
}

extension UILabel {
    static func usernameLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        return label
    }
}



final class InteractionView: UIView, UITableViewDelegate{
    
   // var hiddens = true
    
    /// I deleted the refactor code because I got completely lost in what the point was.
    /// but at some point will i be limited by not being able to pass pictuers in  ... ?
    enum State {
        case poll(captionText: String, votea: String, voteb: String, votec: String)
        case question(captionText: String)
        case hidden
        init(caption: String, votea: String, voteb: String, votec: String) {
            self = .poll(captionText: caption, votea: votea, voteb: voteb, votec: votec)
        }
        
        init(caption: String) {
            self = .question(captionText: caption)
        }

        init() {
            self = .hidden
        }
    }
    
    let screenRect = UIScreen.main.bounds
    let widthLayoutUnit = UIScreen.main.bounds.width - 40
   // var heightLayoutUnit = 0.9*( UIScreen.main.bounds.width / 3)
   // var thirdScreenHeight = UIScreen.main.bounds.height / 3
    
    let caption = UILabel()
    
 
    
  //  let voteAbutton = OptionButton(frame: CGRect(x: 10, y: 10, width: 10, height: 10), type: .one)
    let voteAbutton = RaspberryButton(frame: CGRect(x: 10, y: 10, width: 10, height: 10) )
    let voteBbutton = OptionButton(frame: CGRect(x: 10, y: 10, width: 10, height: 10), type: .two)
    let voteCbutton = OptionButton(frame: CGRect(x: 10, y: 10, width: 10, height: 10), type: .one)
    let dunno = NotSureButton(frame: CGRect(x: 10, y: 10, width: 10, height: 10))
    
    
    
    
    
    let answerInput = UITextField()
    let backgroundImage = UIImageView()
    var thirdScreenHeight = CGFloat(100.0)
    var heightLayoutUnit = CGFloat(100.0)
    var sayCard = chatBubbleView(frame:  CGRect(x: 0, y: 0, width: 100, height: 100), user: nil)
    var descriptiveLabel = UILabel()
    var userAnswerCard = userAnswerView(frame:  CGRect(x: 20, y: 20, width: 100, height: 100), user: botUser.human)
    let descriptiveLabel2 = UILabel()
    let buttonStack = UIStackView()
    
//    let humanAvatar = AvatarView()
    
    /// scaffolding for the comments feed
    static let reuseID = "CELL"
    var commentsView : chatBubbleView
        ///commentTableViewController().view! as! UITableView
    var scrollContainer = UIScrollView()
    var commentsDriver : TimedComments?
    var comments: [Comment] = []
    var commentButton = UIButton()
    
    let synthesizer = AVSpeechSynthesizer()
    var utterance = AVSpeechUtterance()
    
    override init(frame: CGRect) {
        let screenRect = UIScreen.main.bounds
        let widthLayoutUnit = screenRect.size.width - 40
        heightLayoutUnit = 0.9*(screenRect.size.width / 3)
        thirdScreenHeight = screenRect.size.height / 3
        commentsView =  chatBubbleView(frame:  CGRect(x: 40, y: 2*thirdScreenHeight + (thirdScreenHeight - heightLayoutUnit)/2 - 10 , width: widthLayoutUnit - 20, height: heightLayoutUnit), user: nil)
            //chatBubbleView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), user: nil)
        super.init(frame: frame)
        
//        switch feed.state {
//            case .question(let captionText):
//                setup()
//            default:
//                print("I am hidden")
//    }
        setup()
}
    
    required init?(coder: NSCoder) {
        commentsView = chatBubbleView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), user: nil)
        super.init(coder: coder)
       
   
//
//        switch feed.state {
//            case .question(let captionText):
//                setup()
//            default:
//                print("I am hidden")
//        }
        setup()
        //setupRightView()
    }
    
    @objc func userAnswer(_ textField:UITextField ){
       // print(textField.text!)

        commentsDriver?.userComment(userComment: textField.text!)
        
        textField.placeholder =  textField.text!
        textField.text = ""
    }
    
    func setup() {
        
        
        let screenRect = UIScreen.main.bounds
        let widthLayoutUnit = screenRect.size.width - 40
        heightLayoutUnit = 0.9*(screenRect.size.width / 3)
        thirdScreenHeight = screenRect.size.height / 3
        
        
       // backgroundColor = .postBackground
        backgroundColor = .clear
        
        self.isUserInteractionEnabled = true

        backgroundImage.backgroundColor = .postBackground

        backgroundImage.isUserInteractionEnabled = true
        self.addSubview(backgroundImage)

        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: backgroundImage.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: backgroundImage.trailingAnchor).isActive = true
        self.topAnchor.constraint(equalTo: backgroundImage.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: backgroundImage.bottomAnchor).isActive = true
        self.sendSubviewToBack(backgroundImage)
        
        ///TODO: May 5th Add a title feeding from hashtag
        
     
        dunno.setTitle("Don't know", for: .normal)
        
        buttonStack.addArrangedSubview(voteAbutton)
        buttonStack.addArrangedSubview(voteBbutton)
        buttonStack.addArrangedSubview(voteCbutton)
        buttonStack.addArrangedSubview(dunno)
        buttonStack.axis = .vertical
        
        voteAbutton.heightAnchor.constraint(equalToConstant: 0.5*heightLayoutUnit).isActive = true
        voteBbutton.heightAnchor.constraint(equalToConstant: 0.5*heightLayoutUnit).isActive = true
        voteCbutton.heightAnchor.constraint(equalToConstant: 0.5*heightLayoutUnit).isActive = true
        dunno.heightAnchor.constraint(equalToConstant: 0.5*heightLayoutUnit).isActive = true
        
        buttonStack.distribution = .equalSpacing
        buttonStack.spacing = 20
        //voteAbutton.setContentHuggingPriority(.required, for: .horizontal)
        //voteBbutton.setContentHuggingPriority(.required, for: .horizontal)
        self.addSubview(buttonStack)
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.widthAnchor.constraint(equalToConstant: widthLayoutUnit).isActive = true
        buttonStack.bottomAnchor.constraint(equalTo: backgroundImage.bottomAnchor, constant: -20).isActive = true
        buttonStack.heightAnchor.constraint(equalToConstant: 3*heightLayoutUnit).isActive = true
        buttonStack.centerXAnchor.constraint(equalTo: backgroundImage.centerXAnchor).isActive = true
      
        buttonStack.isHidden = false
        voteAbutton.titleLabel?.lineBreakMode = .byWordWrapping
        voteAbutton.tag = 0
        voteAbutton.addTarget(self, action: #selector(voted), for: .touchUpInside)

        
        ///TODO: May 5th show c button
        
        ///TODO: May 5th don't know button
        
        
//        self.addSubview(voteBbutton)
       // voteBbutton.translatesAutoresizingMaskIntoConstraints = false
       // self.trailingAnchor.constraint(equalTo: voteBbutton.trailingAnchor, constant: 20).isActive = true
        //voteBbutton.widthAnchor.constraint(equalToConstant: 120).isActive = true
       // voteBbutton.heightAnchor.constraint(equalToConstant: 50).isActive = true
       // voteBbutton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -100).isActive = true
     //   voteBbutton.backgroundColor = .blue
        voteBbutton.titleLabel?.lineBreakMode = .byWordWrapping
        voteBbutton.tag = 1
        voteBbutton.isUserInteractionEnabled = true
        voteBbutton.addTarget(self, action: #selector(voted), for: .touchUpInside)
        
      //  voteCbutton.backgroundColor = .blue
        voteCbutton.titleLabel?.lineBreakMode = .byWordWrapping
        voteCbutton.tag = 2
        voteCbutton.isUserInteractionEnabled = true
        voteCbutton.addTarget(self, action: #selector(voted), for: .touchUpInside)
        
        dunno.titleLabel?.lineBreakMode = .byWordWrapping
        dunno.tag = 3
        dunno.isUserInteractionEnabled = true
        dunno.addTarget(self, action: #selector(voted), for: .touchUpInside)
        
        descriptiveLabel = UILabel(frame: CGRect(x: 20, y: (thirdScreenHeight - heightLayoutUnit)/4 + 25, width: widthLayoutUnit, height: heightLayoutUnit/4))
        let subtitleAttrs = [NSAttributedString.Key.foregroundColor: UIColor.textTint,
                     NSAttributedString.Key.font: UIFont(name: "Georgia-Bold", size: 18)!,
                     NSAttributedString.Key.textEffect: NSAttributedString.TextEffectStyle.letterpressStyle as NSString
        ]
        

        
        let subtitleStyled = NSAttributedString(string: "Question:", attributes: subtitleAttrs)
        descriptiveLabel.attributedText = subtitleStyled
        self.addSubview(descriptiveLabel)
        
        sayCard = chatBubbleView(frame:  CGRect(x: 40, y: (thirdScreenHeight - heightLayoutUnit)/2 + 50, width: widthLayoutUnit - 20, height: heightLayoutUnit), user: botUser.guy)
        self.addSubview(sayCard)
        
        userAnswerCard = userAnswerView(frame:  CGRect(x: 40, y: thirdScreenHeight + (thirdScreenHeight - heightLayoutUnit)/2 + 25, width: widthLayoutUnit - 20, height: heightLayoutUnit), user: botUser.human)
        self.addSubview(userAnswerCard)
        
//        let botCommentCard = chatBubbleView(frame:  CGRect(x: 20, y: 2*thirdScreenHeight + (thirdScreenHeight - heightLayoutUnit)/2, width: widthLayoutUnit, height: heightLayoutUnit), user: botUser.emery)
//        self.addSubview(botCommentCard)
//
    
        descriptiveLabel2.textAlignment = .right
        self.addSubview(descriptiveLabel2)
        descriptiveLabel2.translatesAutoresizingMaskIntoConstraints = false
        descriptiveLabel2.heightAnchor.constraint(equalTo:  descriptiveLabel.heightAnchor).isActive = true
        descriptiveLabel2.trailingAnchor.constraint(equalTo: backgroundImage.trailingAnchor, constant: -20).isActive = true
        descriptiveLabel2.widthAnchor.constraint(equalTo:  descriptiveLabel.widthAnchor).isActive = true
        descriptiveLabel2.bottomAnchor.constraint(equalTo: backgroundImage.bottomAnchor, constant: -20).isActive = true

        let subtitleStyled2 = NSAttributedString(string: ":Answers", attributes: subtitleAttrs)
        descriptiveLabel2.attributedText = subtitleStyled2


        self.addSubview(answerInput)
       // answerInput.frame = CGRect(x: 20, y: thirdScreenHeight + (thirdScreenHeight - heightLayoutUnit)/2 + 25 + frame.height/2, width: widthLayoutUnit, height: heightLayoutUnit/2)
        //answerInput= CGRect(x: 20, y: 20, width: 50, height: 50)
        answerInput.backgroundColor = .clear
        answerInput.placeholder = "What do you think?"
        answerInput.translatesAutoresizingMaskIntoConstraints = false
        answerInput.centerYAnchor.constraint(equalTo: userAnswerCard.centerYAnchor).isActive = true
        answerInput.heightAnchor.constraint(equalTo: userAnswerCard.heightAnchor, multiplier: 0.5).isActive = true
        answerInput.widthAnchor.constraint(equalToConstant: userAnswerCard.frame.width - userAnswerCard.frame.width*userAnswerCard.dimensionMultiplier).isActive = true
        answerInput.leadingAnchor.constraint(equalTo: userAnswerCard.leadingAnchor, constant: userAnswerCard.frame.width*userAnswerCard.dimensionMultiplier).isActive = true
        answerInput.setLeftPaddingPoints(10)
        answerInput.layer.cornerRadius = 20.0
        answerInput.addTarget(self, action: #selector(userAnswer), for: UIControl.Event.editingDidEndOnExit)
        answerInput.isHidden = false

//        self.addSubview(humanAvatar)
//        humanAvatar.translatesAutoresizingMaskIntoConstraints = false
//        humanAvatar.heightAnchor.constraint(equalTo: answerInput.heightAnchor, multiplier: 1.5).isActive = true
//        humanAvatar.trailingAnchor.constraint(equalTo: backgroundImage.trailingAnchor, constant: -10).isActive = true
//        humanAvatar.widthAnchor.constraint(equalTo: answerInput.heightAnchor, multiplier: 1.5).isActive = true
//        humanAvatar.centerYAnchor.constraint(equalTo: answerInput.centerYAnchor).isActive = true
//
//        humanAvatar.imageView.image = botUser.human.profilePic
//
//
////        humanAvatar.imageView.image = human.profilePic{
////            didSet{
////                reloadInputViews()
////            }
////        }
//            //botUser.human.profilePic
//
//
        self.addSubview(scrollContainer)
        scrollContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -(thirdScreenHeight - heightLayoutUnit)/2 ).isActive = true
        scrollContainer.heightAnchor.constraint(equalTo: sayCard.heightAnchor).isActive = true
        scrollContainer.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        scrollContainer.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        scrollContainer.backgroundColor = .green
        scrollContainer.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 2000)
        
        setUpCommentsView()
        
        commentsView.backgroundColor = .clear
//        commentsView.translatesAutoresizingMaskIntoConstraints = false
//        commentsView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -(thirdScreenHeight - heightLayoutUnit)/2 ).isActive = true
//        commentsView.heightAnchor.constraint(equalTo: sayCard.heightAnchor).isActive = true
//        commentsView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
//        commentsView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
       
//
//        bringSubviewToFront(answerInput)
//        bringSubviewToFront(humanAvatar)
//        bringSubviewToFront(commentsView)
        
       // bringSubviewToFront(voteAbutton)
       // bringSubviewToFront(voteBbutton)
        
        bringSubviewToFront(answerInput)
        bringSubviewToFront(buttonStack)
        
    }
    
    func pause(){
        synthesizer.pauseSpeaking(at: .immediate)
    }
    
    func reloadHumanAvatar(){
        humanAvatar.imageView.image = botUser.human.profilePic
    }
    
    // MARK: Comments Work
    // Custom layout of a UITableView; connect up to the view controller that manages the timed release of the comments; set self as delegate for the table view
    func setUpCommentsView(){
      
//        let scrollPlaceholder = UIScrollView()
//        scrollPlaceholder.addSubview(commentsView)
       // scrollContainer.addSubview(commentsView)
//        commentsView = chatBubbleView(frame: scrollContainer.frame, user: nil)
       // commentsView.translatesAutoresizingMaskIntoConstraints = false
      //  commentsView.topAnchor.constraint(equalTo: scrollContainer.topAnchor).isActive = true
     //   commentsView.heightAnchor.constraint(equalTo: scrollContainer.heightAnchor).isActive = true
     //   commentsView.widthAnchor.constraint(equalTo: scrollContainer.widthAnchor).isActive = true
     //   commentsView.centerXAnchor.constraint(equalTo: scrollContainer.centerXAnchor).isActive = true
        self.addSubview(commentsView)
      //  commentsView.setUpCommentsView(margins: self.layoutMarginsGuide)
        
//        commentsDriver?.didUpdateComments =
//            { [self]
//                comments in
//                self.comments = comments
//                self.commentsView.reloadData()
//            }
//
       // commentsView.register(commentTableViewCell.self, forCellReuseIdentifier: Self.reuseID)
     //   commentsView.register(softCommentTableViewCell.self, forCellReuseIdentifier: Self.reuseID)
      //  commentsView.delegate = self
     //   commentsView.dataSource = self
        
        
        
    }
    
    func triggerCommentsView(){
        commentsDriver?.currentCaption = caption.text ?? ""
        commentsDriver?.start()
        commentsDriver?.didUpdateComments =
            { [self]
                comments in
                self.comments = comments
                self.commentsView.reloadData(comment: comments.last!)
                
            }
        
    }
    
    func stopTimedComments(){
        commentsDriver?.stop()
    }
    
    func setUpCommentsPipeline(){
        
    }
    
//    func setupRightView() {
//        addSubview(controlsStack)
//        controlsStack.axis = .vertical
//
//        //FIXME: Hiddne like button because i won't be able to do anything with it this time around
//        // let lView = likeView()
//        controlsStack.addArrangedSubview(avatarView)
//        // controlsStack.addArrangedSubview(lView)
//        // controlsStack.setCustomSpacing(36, after: lView)
//        //controlsStack.addArrangedSubview(commentView())
//        controlsStack.isLayoutMarginsRelativeArrangement = true
//        controlsStack.spacing = 24
//        controlsStack.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
//        controlsStack.widthAnchor.constraint(equalToConstant: 80).isActive = true
//        controlsStack.translatesAutoresizingMaskIntoConstraints = false
//        controlsStack.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
//        controlsStack.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//    }
//
    func update(state: State) {
     
        switch state {
            case .poll(let captionText, let votea, let voteb, let votec):
                caption.text = captionText
                
                
                let voteAQ = votea.components(separatedBy: "^answer^").first ?? ""
                let voteBQ = voteb.components(separatedBy: "^answer^").first ?? ""
                let voteCQ = votec.components(separatedBy: "^answer^").first ?? ""
               // let voteDQ = voteb?.components(separatedBy: "^answer^").dropFirst().first ?? ""
            
                let voteAA = votea.components(separatedBy: "^answer^").dropFirst().first ?? ""
                let voteBA = voteb.components(separatedBy: "^answer^").dropFirst().first ?? ""
                let voteCA = votec.components(separatedBy: "^answer^").dropFirst().first ?? ""
                
                voteAbutton.answer = voteAA
                voteBbutton.answer = voteBA
                voteCbutton.answer = voteCA
                
                
                voteAbutton.setTitle(voteAQ, for: .normal)
                voteBbutton.setTitle(voteBQ, for: .normal)
                voteCbutton.setTitle(voteCQ, for: .normal)
               // voteAbutton.addTarget(self, action: #selector(voted), for: .touchUpInside)
                answerInput.isHidden = true
                commentsDriver?.stop()
                
                answerInput.isHidden = true
                sayCard.label.text = captionText
                descriptiveLabel.isHidden = true
                descriptiveLabel2.isHidden = true
                userAnswerCard.isHidden = true
                backgroundImage.isHidden = true
            case .question(let captionText):
                caption.text = "Q:" + captionText
                sayCard.label.text = captionText
                voteAbutton.isHidden = true
                voteBbutton.isHidden = true
                voteCbutton.isHidden = true
                dunno.isHidden = true
            case .hidden:
                caption.isHidden = true
                voteAbutton.isHidden = true
                voteBbutton.isHidden = true
                voteCbutton.isHidden = true
                dunno.isHidden = true
                answerInput.isHidden = true
                sayCard.isHidden = true
                descriptiveLabel.isHidden = true
                descriptiveLabel2.isHidden = true
                userAnswerCard.isHidden = true
                backgroundImage.isHidden = true
                commentsDriver?.stop()
        }
        
        reloadHumanAvatar()
        // Reads out the label in a random Anglophone voice
        if let say = caption.text
        {
            commentsDriver?.currentCaption = say
            utterance = AVSpeechUtterance(string: String(say.dropFirst().dropFirst()))
            utterance.pitchMultiplier = [Float(1), Float(1.1), Float(1.4), Float(1.5) ].randomElement()!
            utterance.rate = [Float(0.5), Float(0.4),Float(0.6),Float(0.7)].randomElement()!
            let language = [AVSpeechSynthesisVoice(language: "en-AU"),AVSpeechSynthesisVoice(language: "en-GB"),AVSpeechSynthesisVoice(language: "en-IE"),AVSpeechSynthesisVoice(language: "en-US"),AVSpeechSynthesisVoice(language: "en-IN"), AVSpeechSynthesisVoice(language: "en-ZA")]
            utterance.voice =  language.first!!
           // synthesizer.speak(utterance)
        }
    }
    
    @objc func voted(_ sender: OptionButton) {
        print("button Pressed")
        if sender.tag == 0 {
            
            
            
            if sender.answer != ""
            {
                if sender.answer.contains("^photo^") == true {
                    
                }
                else{
                    sayCard.label.text = sender.answer
                }
            }
            else
            {
            sayCard.label.text =  "Yes - exactly like that!"
            }
            //(String((voteAbutton.currentTitle ?? "Sunshine ").dropLast()) ) + " is the best!"
            // caption.reloadInputViews()
//            voteBbutton.isEnabled = false
//            voteCbutton.isEnabled = false
//            dunno.isEnabled = false
            
            voteAbutton.isPicked = true
            voteBbutton.isPicked = false
            voteCbutton.isPicked = false
            dunno.isPicked = false
        }
        if sender.tag == 1 {
            if sender.answer != ""
            {
                if sender.answer.contains("^photo^") == true {
                    
                }
                else{
                    sayCard.label.text = sender.answer
                }
            }
            else
            {
            sayCard.label.text = "Yes - exactly like that!"
            }
            //(String((voteBbutton.currentTitle ?? "Sunshine ").dropLast())  ) + " is the best!"
            voteAbutton.isPicked = false
            voteBbutton.isPicked = true
            voteCbutton.isPicked = false
            dunno.isPicked = false
        }
        if sender.tag == 2 {
            if sender.answer != ""
            {
                if sender.answer.contains("^photo^") == true {
                    
                }
                else{
                    sayCard.label.text = sender.answer
                }
            }
            else
            {
            sayCard.label.text = "Yes - exactly like that!"
            //(String((voteBbutton.currentTitle ?? "Sunshine ").dropLast())  ) + " is the best!"
            }
//            voteAbutton.isEnabled = false
//
//            voteBbutton.isEnabled = false
//            dunno.isHidden = true
            
            voteAbutton.isPicked = false
            voteBbutton.isPicked =  false
            voteCbutton.isPicked = true
            dunno.isPicked = false
        }
        if sender.tag == 3 {
            sayCard.label.text = "Mmm hmm"
            //(String((voteBbutton.currentTitle ?? "Sunshine ").dropLast())  ) + " is the best!"
//            voteAbutton.isEnabled = false
//            voteBbutton.isEnabled = false
//            voteCbutton.isEnabled = false
            
            voteAbutton.isPicked = false
            voteBbutton.isPicked = false
            voteCbutton.isPicked = false
            dunno.isPicked = true
        }
        
        // Reads out the label in a random Anglophone voice
        if let say = sayCard.label.text
        {
            utterance = AVSpeechUtterance(string: say)
            //utterance.pitchMultiplier = [Float(1), Float(1.1), Float(1.4), Float(1.5) ].randomElement()!
            //utterance.rate = [Float(0.5), Float(0.4),Float(0.6),Float(0.7)].randomElement()!
            let language = [AVSpeechSynthesisVoice(language: "en-AU"),AVSpeechSynthesisVoice(language: "en-GB"),AVSpeechSynthesisVoice(language: "en-IE"),AVSpeechSynthesisVoice(language: "en-US"),AVSpeechSynthesisVoice(language: "en-IN"), AVSpeechSynthesisVoice(language: "en-ZA")]
            utterance.voice =  language.first!!
            //synthesizer.speak(utterance)
        }

        //caption.isHidden = true
        //sendSubviewToBack(self)
       // reloadInputViews()
    }
    
    
}


extension InteractionView: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       // let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! commentTableViewCell
        
       //NSStringFromClass(StockCell)
        
       let cell = tableView.dequeueReusableCell(withIdentifier: Self.reuseID, for: indexPath) as! softCommentTableViewCell
        //cell.awakeFromNib()
        cell.backgroundColor = UIColor.clear
        cell.indentationLevel = 2
        let botAnswerView = chatBubbleView(frame: CGRect(x: 40, y: 2*thirdScreenHeight + (thirdScreenHeight - heightLayoutUnit)/4, width: self.frame.width - 40, height: heightLayoutUnit), user:comments.last!.user)
        
        if indexPath.row < comments.count  {
         //   cell.comment.text = comments[comments.count - indexPath.row - 1].comment
          //  cell.avatarView.imageView.image = comments[comments.count - indexPath.row - 1].avatar
            //[#imageLiteral(resourceName: "bot1.jpeg") ,#imageLiteral(resourceName: "bot2.jpeg") ,#imageLiteral(resourceName: "bot3.jpeg") , #imageLiteral(resourceName: "bot4.jpeg")].randomElement()
            //        let botCommentCard = chatBubbleView(frame:  CGRect(x: 20, y: 2*thirdScreenHeight + (thirdScreenHeight - heightLayoutUnit)/2, width: widthLayoutUnit, height: heightLayoutUnit), user: botUser.emery)
            //        self.addSubview(botCommentCard)
            //
            
            /// FIXME: Change the Comment data structure so it carries a user i can directly read
           // let bot = [botUser.emery, botUser.fred, botUser.tony]
            //let comment = comments.last!.avatar
            
 
        //    botAnswerView.bigText = "Wash it down with a big glass of water"
//
//            self.willRemoveSubview(self.subviews.last!)
//
//            for subviews in self.subviews{
//                if sub
//            }
//
            botAnswerView.label.text = comments.last!.comment
            botAnswerView.reloadInputViews()
            self.addSubview(botAnswerView)
            
        }
        return cell
    }
}


final class MediaView: UIView, YTPlayerViewDelegate {
    enum State {
        case gifImage(gifImage: String, caption: String)
       // case gifImage(gifImage: UIImage, caption: String)
        case video(video: String, caption: String)
        case stillImage(image: UIImage, caption: String)
        case text(bigText: String, caption: String, votea: String?, voteb: String?)
       // case youTube(playlist: String, caption: String)
        case hidden
        
        init(filename: String, captionText: String?, votea: String?, voteb: String?) {
            
           
      switch (filename, filename.suffix(4)){
              
          case let (_, suffix) where [".mp4", "MP4"].contains(suffix) :
              self = .video(video: filename.lowercased(), caption: captionText ?? "" )
          case let (str, _ ) where str.contains("youtu"):
              self = .video(video: filename, caption: captionText ?? "")
              
          case let (_, suffix) where ["jpeg", ".jpg", ".png"].contains(suffix):
              self = .stillImage(image: UIImage(named: filename.lowercased()) ?? UIImage(named: "two.jpeg")!, caption: captionText ?? "" )
          case let (str, _ ) where str.contains("unsplash"):
              let imageURL = URL(string: filename)!
              var downloadedImage : UIImage?
              if let data = try? Data(contentsOf: imageURL) {
                  downloadedImage = UIImage(data: data)
              }
              self = .stillImage(image: downloadedImage ?? UIImage(named: "two.jpeg")!, caption: captionText ?? "" )
              
              
              
//          case let (_, suffix) where [".gif", ".GIF"].contains(suffix):
//              if let gif = try? UIImage(gifName: filename.lowercased()){
//                  self = .gifImage(gifImage: gif, caption: captionText ?? "")
//              }
//              else{
//                  self = .text(bigText: "gif filename is wrong", caption: captionText ?? "", votea: "Never mind", voteb: "Gosh, that's a pain" )
//                  self = .text(bigText: "gif filename is wrong", caption: captionText ?? "", votea: nil, voteb: nil)
//              }
          case let (str, _ ) where str.contains("giphy"):
              self = .gifImage(gifImage: str, caption: captionText ?? "")
              
//              var gifView = GPHMedia()
//              GiphyCore.shared.gifByID("Y1M0ZSlt5fDhvj4Zz5") { (response, error) in
//                  if let media = response?.data {
//
//                }
//              }
              
              //self = .stillImage( image: UIImage(named: "two.jpeg")!, caption: captionText ?? "" )
              
              //self = .gifImage(gifImage: UIImage(named: "bot1")!, caption: captionText ?? "")
//              GiphyCore.shared.gifByID("Y1M0ZSlt5fDhvj4Zz5") { (response, error) in
//                  if let media = response?.data {
//                      self = .gifImage(gifImage: UIImage(named: "bot1")!, caption: captionText ?? "")
////                      DispatchQueue.main.sync { [weak self] in
////                          self?.mediaView.media = media
////                      }
//                  }
//              }
            
          
          
          default:
              if let assetImage = UIImage(named: filename.lowercased()){
                  self = .stillImage(image: UIImage(named: filename.lowercased()) ?? UIImage(named: "two.jpeg")!, caption: captionText ?? "" )
              }
              else
              {
                      // self = .text(bigText: filename.lowercased(), caption: captionText ?? "", votea: "Never mind", voteb: "Gosh, that's a pain")
                  self = .text(bigText: filename.lowercased(), caption: captionText ?? "", votea: votea, voteb: voteb)
              }
      }
            
            
            
//          //    case let str where str.suffix(4) == ".mp4":
//           //     print("mp4 found")
//
//        switch filename.suffix(4){
//            case ".mp4", ".MP4":
//                self = .video(video: filename.lowercased(), caption: captionText ?? "" )
//            case "jpeg", ".jpg", ".png":
//                self = .stillImage(image: UIImage(named: filename.lowercased()) ?? UIImage(named: "two.jpeg")!, caption: captionText ?? "" )
//            case ".gif", ".GIF":
//               // FIXME: Is the try! robust....? Feels quite possible we will send some bad data in at some point
//                if let gif = try? UIImage(gifName: filename.lowercased()){
//                    self = .gifImage(gifImage: gif, caption: captionText ?? "")
//                }
//                else{
//                    //self = .text(bigText: "gif filename is wrong", caption: captionText ?? "", votea: "Never mind", voteb: "Gosh, that's a pain" )
//                    self = .text(bigText: "gif filename is wrong", caption: captionText ?? "", votea: nil, voteb: nil)
//                }
//            default:
//
//                if filename.contains("unsplash"){
//
//                    let imageURL = URL(string: filename)!
//                    var downloadedImage : UIImage?
//
//
////                    AF.request( "https://images.unsplash.com/photo-1529850494847-05b7e590e91f?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=2554&q=80",method: .get).response{ response in
////
////                        switch response.result {
////                            case .success(let responseData):
////                                downloadedImage = UIImage(data: responseData!, scale:0.01)
////
////                            case .failure(let error):
////                                print("error--->",error)
////                        }
////                    }
//
//
////                    let task = URLSession.shared.dataTask(with: imageURL as URL) {(data, response, error) in
////
////                        guard error == nil else {
////                            completion(error, nil)
////                            return
////                        }
////
////                        completion(nil, data)
////                    }
////                    task.resume()
////
//
//                        // Fetch Image Data
//                    if let data = try? Data(contentsOf: imageURL) {
//                            // Create Image and Update Image View
//                        downloadedImage = UIImage(data: data)
//                        //imageView.image = UIImage(data: data)
//                    }
//                   self = .stillImage(image: downloadedImage ?? UIImage(named: "two.jpeg")!, caption: captionText ?? "" )
//
//                }
//                else{
//                    if filename.contains("youtu"){
//                        self = .video(video: filename, caption: captionText ?? "")
//                    }
//                        else{
//                            if let assetImage = UIImage(named: filename.lowercased()){
//                            self = .stillImage(image: UIImage(named: filename.lowercased()) ?? UIImage(named: "two.jpeg")!, caption: captionText ?? "" )
//                            }
//                            else
//                            {
//                                    // self = .text(bigText: filename.lowercased(), caption: captionText ?? "", votea: "Never mind", voteb: "Gosh, that's a pain")
//                                self = .text(bigText: filename.lowercased(), caption: captionText ?? "", votea: votea, voteb: voteb)
//                            }
//                    }
//                }
//            }
 }
        
        init() {
            self = .hidden
        }
    }

    let imageView = UIImageView()
    var gifView = GPHMediaView()
    let videoController = AVPlayerViewController()
    let settingsButton = UIButton()
    let label = UILabel()
    let caption = UILabel()
    var player : AVPlayer?
    var labelCard = chatBubbleView(frame:  CGRect(x: 0, y: 0, width: 100, height: 100), user: botUser.guy)
    //SoftUIView(frame: CGRect(x: 0,y: 0,width: 10,height: 10))
    let stack = UIStackView()
    
    let yesButton = OptionButton(frame: CGRect(x: 10, y: 10, width: 10, height: 10), type: .two)
    let noButton = OptionButton(frame: CGRect(x: 10, y: 10, width: 10, height: 10), type: .one)
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    
    /// THINKS: Is setting up views I won;t use inefficient? Or is it in fact better to do it asap so that the user doe not get a hang?
    func setup() {
        Giphy.configure(apiKey: giphyAPIKey)
        
        let screenRect = UIScreen.main.bounds
        let widthLayoutUnit = screenRect.size.width - 100

        let videoView = videoController.view
        
        self.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: imageView.trailingAnchor).isActive = true
        self.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        imageView.backgroundColor = .postBackground
        
        self.addSubview(videoView!)
        videoView!.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: videoView!.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: videoView!.trailingAnchor).isActive = true
        self.topAnchor.constraint(equalTo: videoView!.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: videoView!.bottomAnchor).isActive = true
        
        imageView.addSubview(gifView)
        //imageView.bringSubviewToFront(gifView)
        
        gifView.translatesAutoresizingMaskIntoConstraints = false
        
        gifView.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
        gifView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        
        gifView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        gifView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor).isActive = true
        
        
        //self.addSubview(label)
        let yCoord = (screenRect.size.height - widthLayoutUnit)/2
     
        
        labelCard = chatBubbleView(frame:  CGRect(x: (1/6)*widthLayoutUnit, y: yCoord, width: widthLayoutUnit, height: 0.67*widthLayoutUnit), user: botUser.guy)
            //SoftUIView(frame: CGRect(x: 50, y: yCoord, width: widthLayoutUnit, height: widthLayoutUnit))
        label.frame = CGRect(x: (1/6)*widthLayoutUnit, y: 0, width: (5/6)*widthLayoutUnit, height: 0.67*widthLayoutUnit)
      //  label.frame = CGRect(x: frame.width/6 + (1/6)*widthLayoutUnit, y: 0, width: (5/6)*widthLayoutUnit, height: 0.67*widthLayoutUnit)
        label.adjustsFontForContentSizeCategory = true
        
        labelCard.addSubview(label)
        self.addSubview(labelCard)
        
        yesButton.isHidden = true
        noButton.isHidden = true
        yesButton.tag = 1
        yesButton.isUserInteractionEnabled = true
        noButton.tag = 0
        noButton.isUserInteractionEnabled = true
       
        stack.isUserInteractionEnabled = true
        self.addSubview(stack)
        yesButton.setTitle("Yes", for: .normal)
        noButton.setTitle("No", for: .normal)
        //yesButton.backgroundColor = .option1
        //noButton.backgroundColor = .option3

        yesButton.heightAnchor.constraint(equalToConstant: 0.2*widthLayoutUnit).isActive = true
        noButton.heightAnchor.constraint(equalToConstant: 0.2*widthLayoutUnit).isActive = true
        
        stack.axis = .vertical
       // stack.backgroundColor = .yellow
        stack.addArrangedSubview(yesButton)
        stack.addArrangedSubview(noButton)
        stack.distribution = .equalSpacing
       // stack.spacing = 50.0
        
        stack.translatesAutoresizingMaskIntoConstraints = false
      //  stack.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
      //  stack.topAnchor.constraint(equalTo: labelCard.bottomAnchor, constant: 50).isActive = true
        stack.trailingAnchor.constraint(equalTo: labelCard.trailingAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50).isActive = true
       // stack.widthAnchor.constraint(equalTo: labelCard.widthAnchor).isActive = true
        stack.leadingAnchor.constraint(equalTo: labelCard.leadingAnchor, constant: -widthLayoutUnit/24).isActive = true
        stack.heightAnchor.constraint(equalToConstant: 0.6*widthLayoutUnit).isActive = true
       
       // labelCard.translatesAutoresizingMaskIntoConstraints = false
       // labelCard.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
       // labelCard.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        
       //label.translatesAutoresizingMaskIntoConstraints = false
        //self.leadingAnchor.constraint(equalTo: label.leadingAnchor).isActive = true
        //self.trailingAnchor.constraint(equalTo: label.trailingAnchor).isActive = true
        //self.topAnchor.constraint(equalTo: label.topAnchor).isActive = true
        //self.bottomAnchor.constraint(equalTo: label.bottomAnchor).isActive = true
        //label.isHidden = true
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        //label.backgroundColor = .yellow
       // label.backgroundColor = .postBackground
        label.textAlignment = .center
        label.font = UIFont(name: "Tw Cen MT Condensed Extra Bold", size: 40)
        label.adjustsFontForContentSizeCategory = true
        
        self.addSubview(caption)
        caption.backgroundColor = .green
        caption.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: caption.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: caption.trailingAnchor).isActive = true
        self.topAnchor.constraint(equalTo: caption.topAnchor).isActive = true
        caption.heightAnchor.constraint(equalToConstant: 100).isActive = true
        //label.isHidden = true
        caption.lineBreakMode = .byWordWrapping
        caption.numberOfLines = 0
        caption.backgroundColor =  .postBackground
        caption.textAlignment = .center
        caption.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.bold)
        caption.textColor = .textTint
       
        self.bringSubviewToFront(stack)
 
    }
    
    
    func update(state: State) {

        switch state {
//            case .gifImage(let gifImage, let captionText):
//                imageView.setGifImage(gifImage, loopCount: -1)
//                imageView.isHidden = false
//                label.isHidden = true
//                videoController.view.isHidden = true
//                labelCard.isHidden = true
//
//                if captionText == "" {
//                    caption.isHidden = true
//
//                }
//                else{
//                    caption.isHidden = false
//                    caption.text = captionText
//                }
            case .gifImage(let giphy, let captionText):
              
                var id = giphy.components(separatedBy: "/").dropLast().last
                print(id)
                
                GiphyCore.shared.gifByID(id ?? "") { (response, error) in
                    if let media = response?.data {
                        DispatchQueue.main.sync { [weak self] in
                            self?.gifView.media = media
                        }
                    }
                }
                
                
                imageView.isHidden = false
                label.isHidden = true
                videoController.view.isHidden = true
                labelCard.isHidden = true
                
                if captionText == "" {
                    caption.isHidden = true
                    
                }
                else{
                    caption.isHidden = false
                    caption.text = captionText
                }
            case .stillImage(let image, let captionText):
                imageView.image = image
                backgroundColor = .clear
                imageView.isHidden = false
                labelCard.isHidden = true
                label.isHidden = true
                
                if captionText == "" {
                    caption.isHidden = true

                } //TO DO: fix the concept clash between caption and hashtag
                else{
                    caption.isHidden = false
                    caption.text = captionText
                }

             //   pageTitleHashtag.text = captionText
                
                
                
                
                videoController.view.isHidden = true
            case .text(let bigText, let captionText, let votea, let voteb):
                imageView.isHidden = true
                label.isHidden = false
            
                let attrs = [NSAttributedString.Key.foregroundColor: UIColor.textTint,
                             NSAttributedString.Key.font: UIFont(name: "Georgia-Bold", size: 24)!,
                             NSAttributedString.Key.textEffect: NSAttributedString.TextEffectStyle.letterpressStyle as NSString
                ]
                
                let bigTextStyled = NSAttributedString(string: bigText, attributes: attrs)
                label.attributedText = bigTextStyled
                videoController.view.isHidden = true
                if captionText == "" {
                    caption.isHidden = true

                }
                else{
                    caption.text = captionText
                }
                
                if votea != nil && voteb != nil {
                    yesButton.isHidden = false
                    noButton.isHidden = false
                    
                    let voteBQ = voteb?.components(separatedBy: "^answer^").first ?? ""
                    let voteBA = voteb?.components(separatedBy: "^answer^").dropFirst().first ?? ""
                    
                    yesButton.setTitle(votea, for: .normal)
                    noButton.setTitle(String(voteBQ), for: .normal)
                    
                    noButton.answer = String(voteBA)
                    
                    yesButton.addTarget(self, action: #selector(textChatBack), for: .touchUpInside)
                    noButton.addTarget(self, action: #selector(textChatBack), for: .touchUpInside)
                }
                
                
            case .video(let video, let captionText):
//                labelCard.isHidden = true
//                                imageView.isHidden = true
//                                label.isHidden = true
//                                yesButton.isHidden = true
//                                noButton.isHidden = true
//
                labelCard.isHidden = false
                imageView.isHidden = true
                label.isHidden = false
                yesButton.isHidden = false
                noButton.isHidden = false
                yesButton.addTarget(self, action: #selector(videoPreferenceStated), for: .touchUpInside)
                noButton.addTarget(self, action: #selector(videoPreferenceStated), for: .touchUpInside)
                

                let attrs = [NSAttributedString.Key.foregroundColor: UIColor.textTint,
                             NSAttributedString.Key.font: UIFont(name: "Georgia-Bold", size: 24)!,
                             NSAttributedString.Key.textEffect: NSAttributedString.TextEffectStyle.letterpressStyle as NSString
                ]


               videoController.view.isHidden = true
                if captionText == "" {
                    let bigTextStyled = NSAttributedString(string: "Do you want to see a video?", attributes: attrs)
                    label.attributedText = bigTextStyled

                }
                else{
                    let bigTextStyled = NSAttributedString(string: "Do you want to see a video about \(captionText)", attributes: attrs)
                    label.attributedText = bigTextStyled
                    
                    /// Page title
                    caption.text = captionText
                }

                yesButton.video = video

//                if let urlPath = Bundle.main.url(forResource: String(video.dropLast(4)), withExtension: ".MP4"){
//                    print(urlPath)
//                    player = AVPlayer(url: urlPath)
//                    videoController.player = player
//                    player?.play()
//                }
//            case .youTube(let playlist, let caption ):
//
//                let playerVars = [ "rel" : 0, "loop" : 1]
//                myView.load(withPlaylistId: "PLPCeSm8EDITr2z9Y6tnTrP3ZsWZKDdMYi", playerVars: playerVars)
//
//                labelCard.isHidden = false
//                imageView.isHidden = true
//                label.isHidden = false
//                yesButton.isHidden = false
//                noButton.isHidden = false
//                yesButton.addTarget(self, action: #selector(videoPreferenceStated), for: .touchUpInside)
//                noButton.addTarget(self, action: #selector(videoPreferenceStated), for: .touchUpInside)
//
//
//                let attrs = [NSAttributedString.Key.foregroundColor: UIColor.textTint,
//                             NSAttributedString.Key.font: UIFont(name: "Georgia-Bold", size: 24)!,
//                             NSAttributedString.Key.textEffect: NSAttributedString.TextEffectStyle.letterpressStyle as NSString
//                ]
//
//
//                videoController.view.isHidden = true
//                if captionText == "" {
//                    let bigTextStyled = NSAttributedString(string: "Do you want to see a video?", attributes: attrs)
//                    label.attributedText = bigTextStyled
//
//                }
//                else{
//                    let bigTextStyled = NSAttributedString(string: "Do you want to see a video about \(captionText)", attributes: attrs)
//                    label.attributedText = bigTextStyled
//
//                    /// Page title
//                    caption.text = captionText
//                }
//
//                yesButton.video = video
                
                
            case .hidden:
                imageView.isHidden = true
                label.isHidden = true
                caption.isHidden = true
                videoController.view.isHidden = true
                labelCard.isHidden = true
        }
    }
    
    
    func play() {
        player?.play()
    }
    
    func pause() {
        player?.pause()
        
        
    }

    // Pauses video playback on tap
    //FIXME: pause gifs and voice
    
    @objc func videoPreferenceStated(_ sender: OptionButton) {
        
        print("video preference stated")
      //  yesButton.isHidden = true
       
      
//        if sender.titleLabel?.text = ("Yes")
//        {
//ƒƒ
//        }
        if sender.tag == 0 {
          //  noButton.backgroundColor = .gray
            let attrs = [NSAttributedString.Key.foregroundColor: UIColor.textTint,
                         NSAttributedString.Key.font: UIFont(name: "Georgia-Bold", size: 24)!,
                         NSAttributedString.Key.textEffect: NSAttributedString.TextEffectStyle.letterpressStyle as NSString
            ]
            let bigTextStyled = NSAttributedString(string: "That's cool - let's skip it.", attributes: attrs)
            label.attributedText = bigTextStyled
            yesButton.isEnabled = false
            noButton.isPicked = true

        }
        if sender.tag == 1 {
            labelCard.isHidden = true
            noButton.isEnabled = false
            videoController.view.isHidden =  false
            
            if sender.video.last == "4"
           {
                    if let urlPath = Bundle.main.url(forResource: String(sender.video.dropLast(4)), withExtension: ".MP4") {
                                    print(urlPath)
                                    player = AVPlayer(url: urlPath)
                                    videoController.player = player
                                    player?.play()
                                }
                else {
                    if let urlPath = Bundle.main.url(forResource: String(sender.video.dropLast(4)), withExtension: ".mp4") {
                        print(urlPath)
                        player = AVPlayer(url: urlPath)
                        videoController.player = player
                        player?.play()
                    }
                }
            }
            
            if sender.video.contains("youtu")
            {
                videoController.view.isHidden = true
                let myView = YTPlayerView()
                myView.delegate = self
                self.addSubview(myView)
                
                myView.translatesAutoresizingMaskIntoConstraints = false
                self.leadingAnchor.constraint(equalTo: myView.leadingAnchor).isActive = true
                self.trailingAnchor.constraint(equalTo: myView.trailingAnchor).isActive = true
                self.centerYAnchor.constraint(equalTo: myView.centerYAnchor).isActive = true
                myView.heightAnchor.constraint(equalToConstant: bounds.width*(9/16)).isActive = true
                
              
             //   let swipeGestureRecognizerLeft = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
                
                // Configure Swipe Gesture Recognizer
              //  swipeGestureRecognizerLeft.direction = .left
                
              //  myView.addGestureRecognizer(swipeGestureRecognizerLeft)
                
                let playerVars = [ "rel" : 0, "loop" : 1, "playinline" : 1, "autoplay" : 0, "autohide": 1, "showinfo": 1, "modestbranding": 1]
                //myView.load(withVideoId: "l_NYrWqUR40", playerVars: playerVars)
                
                
                // M
                
                var playlistID = ""
                
                if sender.video.contains("="){
                    playlistID = String(sender.video.split(separator: "=").last! )
                }
                else{
                    playlistID = String( sender.video.split(separator: "/").last ?? "" )
                }
                
//                let playlistID = String(sender.video.split(separator: "=").last ?? sender.video.split(separator: "/").last ?? "" )
                
                
                myView.load(withPlaylistId: playlistID, playerVars: playerVars)
            }
            
            yesButton.isHidden = true
            noButton.isHidden = true
            
        }
//        if sender.tag == 2 {
//            caption.text = (String((voteBbutton.currentTitle ?? "Sunshine ").dropLast())  ) + " is the best!"
//            voteAbutton.isHidden = true
//            voteBbutton.isHidden = true
//            dunno.isHidden = true
//        }
//        if sender.tag == 3 {
//            caption.text = (String((voteBbutton.currentTitle ?? "Sunshine ").dropLast())  ) + " is the best!"
//            voteAbutton.isHidden = true
//            voteBbutton.isHidden = true
//            voteCbutton.isHidden = true
//        }
        
    }
    
    @objc func  didSwipe(_ sender: UISwipeGestureRecognizer){
        print("Swiped")
    }
   
    @objc func  textChatBack(_ sender: OptionButton) {
        
        print("text chat back")
       // yesButton.isEnabled = false
        
        
        //        if sender.titleLabel?.text = ("Yes")
        //        {
        //ƒƒ
        //        }
        if sender.tag == 0 {
            //noButton.backgroundColor = .gray
            noButton.isPicked = true
            yesButton.isEnabled = false
            let attrs = [NSAttributedString.Key.foregroundColor: UIColor.textTint,
                         NSAttributedString.Key.font: UIFont(name: "Georgia-Bold", size: 24)!,
                         NSAttributedString.Key.textEffect: NSAttributedString.TextEffectStyle.letterpressStyle as NSString
            ]
            let bigTextStyled = NSAttributedString(string: sender.answer, attributes: attrs)
            label.attributedText = bigTextStyled
            
        }
        if sender.tag == 1 {
            let attrs = [NSAttributedString.Key.foregroundColor: UIColor.textTint,
                         NSAttributedString.Key.font: UIFont(name: "Georgia-Bold", size: 24)!,
                         NSAttributedString.Key.textEffect: NSAttributedString.TextEffectStyle.letterpressStyle as NSString
            ]
         //   let bigTextStyled = NSAttributedString(string: "This should automatically advance but it is not working yet ", attributes: attrs)
           // label.attributedText = bigTextStyled
            noButton.isEnabled = false
            yesButton.isPicked = true
            NotificationCenter.default.post(name: .goForwardsNotification, object: nil)

            /// load next screen?
        }
        //        if sender.tag == 2 {
        //            caption.text = (String((voteBbutton.currentTitle ?? "Sunshine ").dropLast())  ) + " is the best!"
        //            voteAbutton.isHidden = true
        //            voteBbutton.isHidden = true
        //            dunno.isHidden = true
        //        }
        //        if sender.tag == 3 {
        //            caption.text = (String((voteBbutton.currentTitle ?? "Sunshine ").dropLast())  ) + " is the best!"
        //            voteAbutton.isHidden = true
        //            voteBbutton.isHidden = true
        //            voteCbutton.isHidden = true
        //        }
        
    }


    

}

class PostViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .postBackground
    }
}

// MARK: - Mock Data
#if DEBUG
//extension Model {
//    static let mock: Self = Model(id: "asdf", tag: Tag(rawValue: "#this is tag"), like: Like(state: .liked, count: 10))
//}

extension PostView.State {
    static let mock: Self = PostView.State(
        //tag: Model.Tag(rawValue: "#this is tag"),
        avatar: AvatarView.State(image: UIImage(contentsOfFile: "guy_profile_pic.jpeg")!, name: "Gyu"),
        media: MediaView.State(filename: "This is a block of text to work out how to format it.", captionText: "" , votea: "", voteb: ""),
        interaction: InteractionView.State()
    )
}


#endif


// MARK: - Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI
@available(iOS 13.0, *)


struct Preview {
    
    struct PostViewPreview: PreviewProvider {
        static var previews: some View {
            Group {
                UIViewPreview {
                            let postView = PostView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
                            postView.update(
                                state: PostView.State.mock
                            )
                            postView.backgroundColor = .red
                            return postView
                        }
                        .previewLayout(.sizeThatFits)
                .edgesIgnoringSafeArea(.all)
                UIViewPreview {
                    let postView = PostView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
                    postView.update(
                        state: PostView.State.mock
                    )
                    postView.backgroundColor = .red
                    return postView
                }
                .previewLayout(.sizeThatFits)
                .edgesIgnoringSafeArea(.all)
            }

        }
    }
}

// MARK: - Preview Helpers

@available(iOS 13.0, *)
struct UIViewPreview<View: UIView>: UIViewRepresentable {
    let view: View

    init(_ builder: @escaping () -> View) {
        view = builder()
    }

    // MARK: - UIViewRepresentable

    func makeUIView(context: Context) -> UIView {
        return view
    }

    func updateUIView(_ view: UIView, context: Context) {
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
}

@available(iOS 13.0, *)
struct ViewControllerRepresentation<T: UIViewController>: UIViewControllerRepresentable {
    let viewController: T
    init(viewController: T) {
        self.viewController = viewController
    }
    
    func makeUIViewController(context: Context) -> T {
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: T, context: Context) {
    }
}

#endif
