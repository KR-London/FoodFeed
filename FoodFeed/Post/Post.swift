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
        
    }
    
    // MARK: UIView
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = 20  //(imageView.frame.width) / 2
        self.layer.cornerRadius = 20 //self.frame.width / 2

        self.layer.masksToBounds = true
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
    let interactionView = InteractionView()
    let settingsButton = UIButton()
    var didPause = false
    
    var say = ""
    var author = Personage.Unknown
    
    var delegate : FeedViewInteractionDelegate?
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    init(frame: CGRect, feed: Feed) {
        super.init(frame: frame)
        
        setup(feed: feed)
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
                }
                say = bigText
                author = character
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
                print("This is a poll. I want to somehow swap out the media view for the interaction view ideally - or otherwise make a frankenstein Media view ")
                let profilePic = profilePicture(who: who)
                self.update(state: PostView.State(
                    avatar: AvatarView.State( image: profilePic, name: who.rawValue ),
                    media: MediaView.State(),
                    interaction: InteractionView.State(caption: caption, votea: votea, voteb: voteb, votec: votec),
                    tag: hashtag ?? "Getting to know " + botUser.human.name
                ))
                say = caption
            case .question(caption: let caption, hashtag: let hashtag, let who):
                print("This is a question. I want to somehow swap out the media view for the interaction view ideally - or otherwise make a frankenstein Media view ")
                let profilePic = profilePicture(who: who)
                self.update(state: PostView.State(
                    avatar: AvatarView.State( image: profilePic, name: who.rawValue ),
                    media: MediaView.State(),
                    interaction: InteractionView.State(caption: caption),
                    tag: hashtag
                ))
                say = caption
            default: return
        }
        
        bringSubviewToFront(avatarView)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup(feed: Feed) {

        // MARK: Where views are placed
        setupMediaView()
        
        if feed.id  == -1 {
            
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 600))
            label.center = CGPoint(x: 160, y: 285)
            label.textAlignment = .center
            label.numberOfLines = 0
            let attrs = [NSAttributedString.Key.foregroundColor: UIColor.textTint, NSAttributedString.Key.font: UIFont(name: "Georgia-Bold", size: 24)!, NSAttributedString.Key.textEffect: NSAttributedString.TextEffectStyle.letterpressStyle as NSString ]
            
            let bigTextStyled = NSAttributedString(string: "Thank you for testing FudFid. You are now on day \(day) on the storyline. Press the reset button below if you ever want to restart the testing.", attributes: attrs)
            label.attributedText = bigTextStyled
            addSubview(label)
            
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
    
    func voiceOver() -> (String, Personage) {
        return (say, author)
    }
    
    func setup() {
        setupMediaView()
        setupStackView()
        setupTag()
        setupRightView()
        setupAvatarView()
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
        self.bringSubviewToFront(softButton)
        self.mediaView.isHidden = true
        self.stackView.isHidden = true
    }

    
    func setupRightView() {
        addSubview(controlsStack)
        controlsStack.axis = .vertical

        //FIXME: Hidden like button because i won't be able to do anything with it this time around
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
        
        let thirdScreenHeight = UIScreen.main.bounds.height / 3
        let margins = self.layoutMarginsGuide

        avatarView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            avatarView.bottomAnchor.constraint(equalTo: mediaView.topAnchor, constant: thirdScreenHeight - 10),
            avatarView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            avatarView.heightAnchor.constraint(equalToConstant: 80),
            avatarView.widthAnchor.constraint(equalToConstant: 80)
        ])
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

        textStack.addArrangedSubview(pageTitleHashtag)
        textStack.addArrangedSubview(xxx)
        addSubview(textStack)
        textStack.translatesAutoresizingMaskIntoConstraints = false
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
        UserDefaults.standard.removeObject(forKey: "launchedBefore")
        
        /// delete database
       day = 1
        clearAllCoreData()

    }
}

public func clearAllCoreData() {
    let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    let entities = container.managedObjectModel.entities
    entities.flatMap({ $0.name }).forEach(clearDeepObjectEntity)
}

private func clearDeepObjectEntity(_ entity: String) {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

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
    
    let caption = UILabel()
    
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
    
    static let reuseID = "CELL"
    var commentsView : chatBubbleView

    var scrollContainer = UIScrollView()
    var commentsDriver : TimedComments?
    var comments: [Comment] = []
    var commentButton = UIButton()
    var author = Personage.Unknown
    
    let synthesizer = AVSpeechSynthesizer()
    var utterance = AVSpeechUtterance()
    
    override init(frame: CGRect) {
        let screenRect = UIScreen.main.bounds
        let widthLayoutUnit = screenRect.size.width - 40
        heightLayoutUnit = 0.9*(screenRect.size.width / 3)
        thirdScreenHeight = screenRect.size.height / 3
        commentsView =  chatBubbleView(frame:  CGRect(x: 40, y: 2*thirdScreenHeight + (thirdScreenHeight - heightLayoutUnit)/2 - 10 , width: widthLayoutUnit - 20, height: heightLayoutUnit), user: nil)

        super.init(frame: frame)

        setup()
}
    
    required init?(coder: NSCoder) {
        commentsView = chatBubbleView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), user: nil)
        commentsView.doYouWantProfilePicture = true
        super.init(coder: coder)
       
        setup()
    }
    
    @objc func userAnswer(_ textField:UITextField ){

        commentsDriver?.userComment(userComment: textField.text!)
        
        textField.placeholder =  textField.text!
        textField.text = ""
    }
    
    func setup() {

        let screenRect = UIScreen.main.bounds
        let widthLayoutUnit = screenRect.size.width - 40
        heightLayoutUnit = 0.9*(screenRect.size.width / 3)
        thirdScreenHeight = screenRect.size.height / 3
        
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

        voteBbutton.titleLabel?.lineBreakMode = .byWordWrapping
        voteBbutton.tag = 1
        voteBbutton.isUserInteractionEnabled = true
        voteBbutton.addTarget(self, action: #selector(voted), for: .touchUpInside)
        
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

        self.addSubview(scrollContainer)
        scrollContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -(thirdScreenHeight - heightLayoutUnit)/2 ).isActive = true
        scrollContainer.heightAnchor.constraint(equalTo: sayCard.heightAnchor).isActive = true
        scrollContainer.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        scrollContainer.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        scrollContainer.backgroundColor = .green
        scrollContainer.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 2000)
        
        setUpCommentsView()
        commentsView.doYouWantProfilePicture = true
        
        commentsView.backgroundColor = .clear
        
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
        self.addSubview(commentsView)
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

    func update(state: State) {
        // FIXME: I am not picking up which character triggered the interaction?
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
            }
            
            voteAbutton.isPicked = false
            voteBbutton.isPicked =  false
            voteCbutton.isPicked = true
            dunno.isPicked = false
        }
        if sender.tag == 3 {
            sayCard.label.text = "Mmm hmm"

            voteAbutton.isPicked = false
            voteBbutton.isPicked = false
            voteCbutton.isPicked = false
            dunno.isPicked = true
        }
        
        ///FIXME: put author through to here
        if let say = sayCard.label.text
        {
            utterance = AVSpeechUtterance(string: say)
            utterance = voice(who: .Unknown, saying: utterance)
            
            synthesizer.speak(utterance)
        }
    }
}

extension InteractionView: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.reuseID, for: indexPath) as! softCommentTableViewCell
        
        cell.backgroundColor = UIColor.clear
        cell.indentationLevel = 2
        let botAnswerView = chatBubbleView(frame: CGRect(x: 40, y: 2*thirdScreenHeight + (thirdScreenHeight - heightLayoutUnit)/4, width: self.frame.width - 40, height: heightLayoutUnit), user:comments.last!.user)
        
        if indexPath.row < comments.count  {
            botAnswerView.label.text = comments.last!.comment
            botAnswerView.reloadInputViews()
            self.addSubview(botAnswerView)
        }
        return cell
    }
}

final class MediaView: UIView, YTPlayerViewDelegate {

    enum State {
        case giphyImage(gifImageURL: String, caption: String)
        case gifImage(gifImage: UIImage, caption: String)
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
              
          case let (str, _ ) where str.contains("giphy"):
              self = .giphyImage(gifImageURL: str, caption: captionText ?? "")
              
          case let (_, suffix) where [".gif", ".GIF"].contains(suffix):
              if let gif = try? UIImage(gifName: filename.lowercased()){
                  self = .gifImage(gifImage: gif, caption: captionText ?? "")
              }
              else{
                  self = .text(bigText: "gif filename is wrong", caption: captionText ?? "", votea: "Never mind", voteb: "Gosh, that's a pain" )
                  self = .text(bigText: "gif filename is wrong", caption: captionText ?? "", votea: nil, voteb: nil)
              }
          
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
    
    var swipedAway = false
    
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
        imageView.backgroundColor = .clear
        
        self.addSubview(videoView!)
        videoView!.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: videoView!.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: videoView!.trailingAnchor).isActive = true
        self.topAnchor.constraint(equalTo: videoView!.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: videoView!.bottomAnchor).isActive = true
        
        imageView.addSubview(gifView)
        //imageView.bringSubviewToFront(gifView)
        
        gifView.translatesAutoresizingMaskIntoConstraints = false
        
        gifView.widthAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        gifView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        gifView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        gifView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        gifView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor).isActive = true
        
        
        //self.addSubview(label)
        let yCoord = (screenRect.size.height - widthLayoutUnit)/2
     
        
        labelCard = chatBubbleView(frame:  CGRect(x: (1/6)*widthLayoutUnit, y: yCoord, width: widthLayoutUnit, height: 0.67*widthLayoutUnit), user: botUser.guy)
            //SoftUIView(frame: CGRect(x: 50, y: yCoord, width: widthLayoutUnit, height: widthLayoutUnit))
        label.frame = CGRect(x: (1/6)*widthLayoutUnit, y: 0, width: (5/6)*widthLayoutUnit, height: 0.67*widthLayoutUnit)
        label.adjustsFontForContentSizeCategory = true
        
        labelCard.addSubview(label)
        self.addSubview(labelCard)
        
        yesButton.isHidden = true
        noButton.isHidden = true
        yesButton.tag = 1
        yesButton.isUserInteractionEnabled = true
        noButton.tag = 0
        noButton.isUserInteractionEnabled = true
       
       
        yesButton.setTitle("Yes", for: .normal)
        noButton.setTitle("No", for: .normal)
        self.addSubview(yesButton)
        self.addSubview(noButton)
        
        yesButton.translatesAutoresizingMaskIntoConstraints = false
        noButton.translatesAutoresizingMaskIntoConstraints = false
        yesButton.trailingAnchor.constraint(equalTo: labelCard.trailingAnchor).isActive = true
        noButton.trailingAnchor.constraint(equalTo: labelCard.trailingAnchor).isActive = true
        noButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50).isActive = true
        yesButton.leadingAnchor.constraint(equalTo: labelCard.leadingAnchor, constant: -widthLayoutUnit/24).isActive = true
        noButton.leadingAnchor.constraint(equalTo: labelCard.leadingAnchor, constant: -widthLayoutUnit/24).isActive = true
        yesButton.bottomAnchor.constraint(equalTo: noButton.topAnchor, constant: -50).isActive = true
        
        yesButton.heightAnchor.constraint(equalToConstant: 0.2*widthLayoutUnit).isActive = true
        noButton.heightAnchor.constraint(equalToConstant: 0.2*widthLayoutUnit).isActive = true

        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
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
            case .gifImage(let gifImage, let captionText):
                imageView.setGifImage(gifImage, loopCount: -1)
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
            case .giphyImage(let giphy, let captionText):
              
                var id = ""
                
                if giphy.suffix(3) == "gif"{
                    id = giphy.components(separatedBy: "/").dropLast().last!
                }
                else{
                    id = giphy.components(separatedBy: "/").last!.components(separatedBy: "-").last!
                }
                
                
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
                
                if votea != nil {
                    yesButton.isHidden = false
                    
                    yesButton.setTitle(votea, for: .normal)
                    
                    yesButton.addTarget(self, action: #selector(textChatBack), for: .touchUpInside)
                }
                
                if voteb != nil {
                
                    noButton.isHidden = false
                    
                    let voteBQ = voteb?.components(separatedBy: "^answer^").first ?? ""
                    let voteBA = voteb?.components(separatedBy: "^answer^").dropFirst().first ?? ""
                    
                    noButton.setTitle(String(voteBQ), for: .normal)
                    
                    noButton.answer = String(voteBA)
                    
                    noButton.addTarget(self, action: #selector(textChatBack), for: .touchUpInside)
                }
                
                
            case .video(let video, let captionText):

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

    //FIXME: pause gifs and voice
    
    @objc func videoPreferenceStated(_ sender: OptionButton) {
        
        print("video preference stated")
        
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
                
                let playerVars = [ "rel" : 0, "loop" : 1, "playinline" : 1, "autoplay" : 0, "autohide": 1, "showinfo": 1, "modestbranding": 1]

                var playlistID = ""
                
                if sender.video.contains("="){
                    playlistID = String(sender.video.split(separator: "=").last! )
                }
                else{
                    playlistID = String( sender.video.split(separator: "/").last ?? "" )
                }
                  
                myView.load(withPlaylistId: playlistID, playerVars: playerVars)
            }
            yesButton.isHidden = true
            noButton.isHidden = true
        }
    }
    
    @objc func  didSwipe(_ sender: UISwipeGestureRecognizer){
        print("Swiped")
    }
   
    @objc func  textChatBack(_ sender: OptionButton) {

        if sender.tag == 0 {

            noButton.isPicked = true
            yesButton.isEnabled = false
            let attrs = [NSAttributedString.Key.foregroundColor: UIColor.textTint,
                         NSAttributedString.Key.font: UIFont(name: "Georgia-Bold", size: 24)!,
                         NSAttributedString.Key.textEffect: NSAttributedString.TextEffectStyle.letterpressStyle as NSString
            ]
            let bigTextStyled = NSAttributedString(string: sender.answer, attributes: attrs)
            label.attributedText = bigTextStyled
            
            let synthesizer = AVSpeechSynthesizer()
            var utterance = AVSpeechUtterance()
            
            utterance = AVSpeechUtterance(string: sender.answer)

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                synthesizer.speak(utterance)
            }
           
            //FIXME: don't trigger if user changed
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                
                if self.swipedAway == false {
                    NotificationCenter.default.post(name: .goForwardsNotification, object: nil)
                }
               
            }
            
        }
        if sender.tag == 1 {
            let attrs = [NSAttributedString.Key.foregroundColor: UIColor.textTint,
                         NSAttributedString.Key.font: UIFont(name: "Georgia-Bold", size: 24)!,
                         NSAttributedString.Key.textEffect: NSAttributedString.TextEffectStyle.letterpressStyle as NSString
            ]

            noButton.isEnabled = false
            yesButton.isPicked = true
            
        /// load next screen
            NotificationCenter.default.post(name: .goForwardsNotification, object: nil)
        }
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
