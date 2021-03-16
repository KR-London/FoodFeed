import Foundation
import AVFoundation
import AVKit
import UIKit
import Speech

let humanAvatar = AvatarView()

@IBDesignable
final class AvatarView: UIView {
    private let margin: CGFloat = 2
    let imageView = UIImageView()
    
    struct State {
        let image: UIImage
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
        imageView.layer.cornerRadius = (imageView.frame.width) / 2
        self.layer.cornerRadius =  self.frame.width / 2
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
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI
@available(iOS 13.0, *)
struct AvatarViewPreview: PreviewProvider {
    static var previews: some View {
                UIViewPreview {
                    let image = UIImage(named: "guy_profile_pic.jpeg")!
                    let view = AvatarView()
                    view.update(
                        state: AvatarView.State(image: image)
                    )
                    return view
                }
                .previewLayout(.sizeThatFits)
                .background(Color.black)
    }
}
#endif

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
    let tagLabel = UILabel.tagLabel()
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
        
        switch feed.state{
            case .text(let bigText, let caption, let hashtag):
                self.update(state: PostView.State(
                    avatar: AvatarView.State(image: try! UIImage(imageName: "guy_profile_pic.jpeg")!),
                    media: MediaView.State(filename: bigText, captionText: caption),
                    interaction: InteractionView.State(),
                    tag: hashtag
                ))
                if let tag = hashtag{
                    tagLabel.text = "#" + tag
                }
              //  mediaView.isHidden == true
            case .gif(let gifName, let caption, let hashtag):
                self.update(state: PostView.State(
                    avatar: AvatarView.State(image: try! UIImage(imageName: "guy_profile_pic.jpeg")!),
                    media: MediaView.State(filename: gifName, captionText: caption),
                    interaction: InteractionView.State(),
                    tag: hashtag
                ))
                tagLabel.text = hashtag
            case .image(let imageName, let caption, let hashtag):
                self.update(state: PostView.State(
                    avatar: AvatarView.State(image: try! UIImage(imageName: "guy_profile_pic.jpeg")!),
                    media: MediaView.State(filename: imageName,captionText: caption),
                    interaction: InteractionView.State(),
                    tag: hashtag
                ))
                tagLabel.text = hashtag
            case .video(let videoName, let hashtag):
                self.update(state: PostView.State(
                    avatar: AvatarView.State(image: try! UIImage(imageName: "guy_profile_pic.jpeg")!),
                    media: MediaView.State(filename: videoName, captionText: nil),
                    interaction: InteractionView.State(),
                    tag: hashtag
                ))
                tagLabel.text = hashtag
            case .poll(let caption, let votea, let voteb, let hashtag):
                print("This is a poll. I want to somehow swap out the media view for the interaction view ideally - or otherwise make a frankenstein Media view ")
                self.update(state: PostView.State(
                    avatar: AvatarView.State(image: try! UIImage(imageName: "guy_profile_pic.jpeg")!),
                    media: MediaView.State(),
                    interaction: InteractionView.State(caption: caption, votea: votea, voteb: voteb),
                    tag: hashtag
                ))
                tagLabel.text = hashtag
            case .question(caption: let caption, hashtag: let hashtag):
                print("This is a question. I want to somehow swap out the media view for the interaction view ideally - or otherwise make a frankenstein Media view ")
                self.update(state: PostView.State(
                    avatar: AvatarView.State(image: try! UIImage(imageName: "guy_profile_pic.jpeg")!),
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
        interactionView.isUserInteractionEnabled == true
    }
    
//    func setupBigTextView() {
//        addSubview(bigTextView)
//        bigTextView.translatesAutoresizingMaskIntoConstraints = false
//        bigTextView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
//        bigTextView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
//        bigTextView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        bigTextView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//    }
    
    func setUpResetButtons()
    {
        self.addSubview(settingsButton)
        settingsButton.backgroundColor = .blue
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: settingsButton.leadingAnchor, constant: -20).isActive = true
        self.trailingAnchor.constraint(equalTo: settingsButton.trailingAnchor, constant: 20).isActive = true
        settingsButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        settingsButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        settingsButton.titleLabel?.font = UIFont(name: "Tw Cen MT Condensed Extra Bold", size: 40)!
        settingsButton.setTitle("Reset Beta Test?", for: .normal)
        settingsButton.layer.cornerRadius = 10.0
        settingsButton.layer.borderWidth = 1.0
        settingsButton.addTarget(self, action: #selector(resetUserDefaults), for: .touchUpInside)
    }

    
    func setupRightView() {
        addSubview(controlsStack)
        controlsStack.axis = .vertical

        //FIXME: Hiddne like button because i won't be able to do anything with it this time around 
       // let lView = likeView()
        controlsStack.addArrangedSubview(avatarView)
       // controlsStack.addArrangedSubview(lView)
       // controlsStack.setCustomSpacing(36, after: lView)
        //controlsStack.addArrangedSubview(commentView())
        controlsStack.isLayoutMarginsRelativeArrangement = true
        controlsStack.spacing = 24
        controlsStack.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        controlsStack.widthAnchor.constraint(equalToConstant: 80).isActive = true
        controlsStack.translatesAutoresizingMaskIntoConstraints = false
        controlsStack.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        controlsStack.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
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
        textStack.addArrangedSubview(tagLabel)
        textStack.addArrangedSubview(xxx)
        addSubview(textStack)
        textStack.translatesAutoresizingMaskIntoConstraints = false
        textStack.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor, constant: 16).isActive = true
        textStack.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor).isActive = true
    }
    
    func update(state: State) {
        if let tag = state.tag{
            tagLabel.text = "#" + tag
            tagLabel.textColor = .blue
        }
        avatarView.update(state: state.avatar)
        mediaView.update(state: state.media)
        interactionView.update(state: state.interaction)
        
    }
    
    @objc func resetUserDefaults(sender: UIButton!) {
        UserDefaults.standard.removeObject(forKey: "loginRecord")
        UserDefaults.standard.removeObject(forKey: "following")
    }
}

extension UILabel {
    static func tagLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .white
        return label
    }
}

extension UILabel {
    static func captionLabel() -> UILabel {
        let label = UILabel()
        return label
    }
}

extension UILabel {
    static func usernameLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }
}



final class InteractionView: UIView, UITableViewDelegate{
    
    
    /// I deleted the refactor code because I got completely lost in what the point was.
    /// but at some point will i be limited by not being able to pass pictuers in  ... ?
    enum State {
        case poll(captionText: String, votea: String, voteb: String)
        case question(captionText: String)
        case hidden
        init(caption: String, votea: String, voteb: String) {
            self = .poll(captionText: caption, votea: votea, voteb: voteb)
        }
        
        init(caption: String) {
            self = .question(captionText: caption)
        }

        init() {
            self = .hidden
        }
    }
    
    let caption = UILabel()
    let voteAbutton = UIButton()
    let voteBbutton = UIButton()
    let answerInput = UITextField()
    let backgroundImage = UIImageView()
    
//    let humanAvatar = AvatarView()
    
    /// scaffolding for the comments feed
    static let reuseID = "CELL"
    let commentsView = commentTableViewController().view! as! UITableView
    var commentsDriver : TimedComments?
    var comments: [Comment] = []
    var commentButton = UIButton()
    
    let synthesizer = AVSpeechSynthesizer()
    var utterance = AVSpeechUtterance()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
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
        
        self.isUserInteractionEnabled = true
        
        backgroundImage.backgroundColor = .green
        backgroundImage.isUserInteractionEnabled = true
        self.addSubview(backgroundImage)

        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: backgroundImage.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: backgroundImage.trailingAnchor).isActive = true
        self.topAnchor.constraint(equalTo: backgroundImage.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: backgroundImage.bottomAnchor).isActive = true
        self.sendSubviewToBack(backgroundImage)
        
        
        self.addSubview(voteAbutton)
        voteAbutton.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: voteAbutton.leadingAnchor, constant: -20).isActive = true
        voteAbutton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        voteAbutton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        voteAbutton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -100).isActive = true
        voteAbutton.backgroundColor = .blue
        voteAbutton.titleLabel?.lineBreakMode = .byWordWrapping
        voteAbutton.tag = 0
        //  voteAbutton.addTarget(self, action: #selector(voted), for: .touchUpInside)
        
        
        self.addSubview(voteBbutton)
        voteBbutton.translatesAutoresizingMaskIntoConstraints = false
        self.trailingAnchor.constraint(equalTo: voteBbutton.trailingAnchor, constant: 20).isActive = true
        voteBbutton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        voteBbutton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        voteBbutton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -100).isActive = true
        voteBbutton.backgroundColor = .blue
        voteBbutton.titleLabel?.lineBreakMode = .byWordWrapping
        voteBbutton.tag = 1
        // voteBbutton.isUserInteractionEnabled = true
        voteBbutton.addTarget(self, action: #selector(voted), for: .touchUpInside)


        self.addSubview(caption)
        caption.contentMode = .scaleAspectFit
        caption.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: caption.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: caption.trailingAnchor).isActive = true
        self.topAnchor.constraint(equalTo: caption.topAnchor).isActive = true
        caption.heightAnchor.constraint(equalTo: backgroundImage.heightAnchor, multiplier: 0.5).isActive = true
        caption.lineBreakMode = .byWordWrapping
        caption.numberOfLines = 0
        caption.backgroundColor = .green
        caption.textAlignment = .center
        caption.font = UIFont(name: "Tw Cen MT Condensed Extra Bold", size: 40)
        self.bringSubviewToFront(caption)

        
        self.addSubview(answerInput)
        answerInput.backgroundColor = .white
        answerInput.placeholder = "What do you think?"
        answerInput.translatesAutoresizingMaskIntoConstraints = false
        answerInput.heightAnchor.constraint(equalTo: voteBbutton.heightAnchor, multiplier: 1.5).isActive = true
        answerInput.leadingAnchor.constraint(equalTo: voteAbutton.leadingAnchor, constant: -10).isActive = true
        answerInput.trailingAnchor.constraint(equalTo: voteBbutton.trailingAnchor).isActive = true
       // answerInput.topAnchor.constraint(equalTo: voteBbutton.topAnchor).isActive = true
        answerInput.topAnchor.constraint(equalTo: caption.bottomAnchor, constant: -50).isActive = true
        answerInput.layer.cornerRadius = 20.0
        //answerInput.enablesReturnKeyAutomatically
        answerInput.addTarget(self, action: #selector(userAnswer), for: UIControl.Event.editingDidEndOnExit)
        
        self.addSubview(humanAvatar)
        humanAvatar.translatesAutoresizingMaskIntoConstraints = false
        humanAvatar.heightAnchor.constraint(equalTo: answerInput.heightAnchor, multiplier: 1.5).isActive = true
        humanAvatar.trailingAnchor.constraint(equalTo: backgroundImage.trailingAnchor).isActive = true
        humanAvatar.widthAnchor.constraint(equalTo: answerInput.heightAnchor, multiplier: 1.5).isActive = true
        humanAvatar.centerYAnchor.constraint(equalTo: answerInput.centerYAnchor).isActive = true
        
        humanAvatar.imageView.image = botUser.human.profilePic
        
        
//        humanAvatar.imageView.image = human.profilePic{
//            didSet{
//                reloadInputViews()
//            }
//        }
            //botUser.human.profilePic
      
        
        setUpCommentsView()
        commentsView.backgroundColor = .clear
        commentsView.translatesAutoresizingMaskIntoConstraints = false
        commentsView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        let topConstraint = commentsView.topAnchor.constraint(equalTo: answerInput.bottomAnchor, constant: 50)
        topConstraint.priority = UILayoutPriority(rawValue: 700)
        topConstraint.isActive = true
        //  heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.3)
        //commentsView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        //commentsView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        // commentsView.widthAnchor.constraint(equalToConstant: 240).isActive = true
        commentsView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        commentsView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        bringSubviewToFront(answerInput)
        bringSubviewToFront(humanAvatar)
        
       // bringSubviewToFront(voteAbutton)
       // bringSubviewToFront(voteBbutton)
        

        
    }
    
    func reloadHumanAvatar(){
        humanAvatar.imageView.image = botUser.human.profilePic
    }
    
    // MARK: Comments Work
    // Custom layout of a UITableView; connect up to the view controller that manages the timed release of the comments; set self as delegate for the table view
    func setUpCommentsView(){
        
        
        self.addSubview(commentsView)
        commentsView.setUpCommentsView(margins: self.layoutMarginsGuide)
        
//        commentsDriver?.didUpdateComments =
//            { [self]
//                comments in
//                self.comments = comments
//                self.commentsView.reloadData()
//            }
//
        commentsView.register(commentTableViewCell.self, forCellReuseIdentifier: Self.reuseID)
        commentsView.delegate = self
        commentsView.dataSource = self
        
        
        
    }
    
    func triggerCommentsView(){
        commentsDriver?.currentCaption = caption.text ?? "Trying to copy before its initialised"
        commentsDriver?.start()
        commentsDriver?.didUpdateComments =
            { [self]
                comments in
                self.comments = comments
                self.commentsView.reloadData()
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
            case .poll(let captionText, let votea, let voteb):
                caption.text = captionText
                voteAbutton.setTitle(votea, for: .normal)
                voteBbutton.setTitle(voteb, for: .normal)
                voteAbutton.addTarget(self, action: #selector(voted), for: .touchUpInside)
                answerInput.isHidden = true
            case .question(let captionText):
                caption.text = "Q:" + captionText
                voteAbutton.isHidden = true
                voteBbutton.isHidden = true
            case .hidden:
                caption.isHidden = true
                voteAbutton.isHidden = true
                voteBbutton.isHidden = true
                answerInput.isHidden = true
            default:
                return
        }
        
        reloadHumanAvatar()
        // Reads out the label in a random Anglophone voice
        if let say = caption.text
        {
            commentsDriver?.currentCaption = say 
            utterance = AVSpeechUtterance(string: String(say.dropFirst().dropFirst()))
           // utterance.pitchMultiplier = [Float(1), Float(1.1), Float(1.4), Float(1.5) ].randomElement()!
           // utterance.rate = [Float(0.5), Float(0.4),Float(0.6),Float(0.7)].randomElement()!
            let language = [AVSpeechSynthesisVoice(language: "en-AU"),AVSpeechSynthesisVoice(language: "en-GB"),AVSpeechSynthesisVoice(language: "en-IE"),AVSpeechSynthesisVoice(language: "en-US"),AVSpeechSynthesisVoice(language: "en-IN"), AVSpeechSynthesisVoice(language: "en-ZA")]
            utterance.voice =  language.first!!
            synthesizer.speak(utterance)
        }
    }
    
    @objc func voted(_ sender: UIButton) {
        print("button Pressed")
        if sender.tag == 0 {
            caption.text = (String((voteAbutton.currentTitle ?? "Sunshine ").dropLast()) ?? "Sunshine") + " is the best!"
        }
        if sender.tag == 1 {
            caption.text = (String((voteBbutton.currentTitle ?? "Sunshine ").dropLast())  ?? "Sunshine") + " is the best!"
        }
        
        // Reads out the label in a random Anglophone voice
        if let say = caption.text
        {
            utterance = AVSpeechUtterance(string: say)
            //utterance.pitchMultiplier = [Float(1), Float(1.1), Float(1.4), Float(1.5) ].randomElement()!
            //utterance.rate = [Float(0.5), Float(0.4),Float(0.6),Float(0.7)].randomElement()!
            let language = [AVSpeechSynthesisVoice(language: "en-AU"),AVSpeechSynthesisVoice(language: "en-GB"),AVSpeechSynthesisVoice(language: "en-IE"),AVSpeechSynthesisVoice(language: "en-US"),AVSpeechSynthesisVoice(language: "en-IN"), AVSpeechSynthesisVoice(language: "en-ZA")]
            utterance.voice =  language.first!!
            synthesizer.speak(utterance)
        }
        
        voteBbutton.isHidden = true
        voteAbutton.isHidden = true
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! commentTableViewCell
        
       // let cell = tableView.dequeueReusableCell(withIdentifier: Self.reuseID, for: indexPath) as! commentTableViewCell
        //cell.awakeFromNib()
        cell.backgroundColor = UIColor.clear
        if indexPath.row < comments.count {
            cell.comment.text = comments[comments.count - indexPath.row - 1].comment
            cell.avatarView.imageView.image = comments[comments.count - indexPath.row - 1].avatar
            //[#imageLiteral(resourceName: "bot1.jpeg") ,#imageLiteral(resourceName: "bot2.jpeg") ,#imageLiteral(resourceName: "bot3.jpeg") , #imageLiteral(resourceName: "bot4.jpeg")].randomElement()
        }
        return cell
    }
}


final class MediaView: UIView {
    enum State {
        case gifImage(gifImage: UIImage, caption: String)
        case video(video: String, caption: String)
        case stillImage(image: UIImage, caption: String)
        case text(bigText: String, caption: String)
        case hidden
        
        init(filename: String, captionText: String?) {
            
           

        switch filename.suffix(4){
            case ".mp4", ".MP4":
                self = .video(video: filename.lowercased(), caption: captionText ?? "" )
            case "jpeg", ".jpg", ".png":
                self = .stillImage(image: UIImage(named: filename.lowercased()) ?? UIImage(named: "two.jpeg")!, caption: captionText ?? "" )
            case ".gif", ".GIF":
                //FIXME: Is the try! robust....? Feels quite possible we will send some bad data in at some point
                if let gif = try? UIImage(gifName: filename.lowercased()){
                    self = .gifImage(gifImage: gif, caption: captionText ?? "")
                }
                else{
                    self = .text(bigText: "gif filename is wrong", caption: captionText ?? "" )
                }
            default:
                self = .text(bigText: filename.lowercased(), caption: captionText ?? "" )
            }
        }
        
        init() {
            self = .hidden
        }
    }
    
  

    let imageView = UIImageView()
    let videoController = AVPlayerViewController()
    let settingsButton = UIButton()
    let label = UILabel()
    let caption = UILabel()
    var player : AVPlayer?
   
    
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

        let videoView = videoController.view
        
        self.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: imageView.trailingAnchor).isActive = true
        self.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        imageView.backgroundColor = .blue
        
        self.addSubview(videoView!)
        videoView!.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: videoView!.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: videoView!.trailingAnchor).isActive = true
        self.topAnchor.constraint(equalTo: videoView!.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: videoView!.bottomAnchor).isActive = true
        
        
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: label.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: label.trailingAnchor).isActive = true
        self.topAnchor.constraint(equalTo: label.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: label.bottomAnchor).isActive = true
        //label.isHidden = true
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.backgroundColor = .yellow
        label.textAlignment = .center
        label.font = UIFont(name: "Tw Cen MT Condensed Extra Bold", size: 40)
        
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
        caption.backgroundColor = .purple
        caption.textAlignment = .center
        caption.font = UIFont(name: "Tw Cen MT Condensed Extra Bold", size: 24)
        
        
        
        
    }
    
    
    func update(state: State) {

        switch state {
            case .gifImage( let gifImage, let captionText):
                imageView.setGifImage(gifImage, loopCount: -1)
                imageView.isHidden = false
                label.isHidden = true
                videoController.view.isHidden = true
                if captionText == "" {
                    caption.isHidden = true

                }
                else{
                    caption.text = captionText
                }
            case .stillImage(let image, let captionText):
                imageView.setImage(image)
                imageView.isHidden = false
                label.isHidden = true
                if captionText == "" {
                    caption.isHidden = true
                    
                }
                else{
                    caption.text = captionText
                }
                videoController.view.isHidden = true
            case .text(let bigText, let captionText):
                imageView.isHidden = true
                label.isHidden = false
                label.text = bigText
                videoController.view.isHidden = true
                if captionText == "" {
                    caption.isHidden = true

                }
                else{
                    caption.text = captionText
                }
            case .video(let video, let captionText):
                imageView.isHidden = true
                label.isHidden = true
                if captionText == "" {
                    caption.isHidden = true
                    
                }
                else{
                    caption.text = captionText
                }
              
                if let urlPath = Bundle.main.url(forResource: String(video.dropLast(4)), withExtension: ".mp4"){
                    print(urlPath)
                    player = AVPlayer(url: urlPath)
                    videoController.player = player
                    player?.play()
                }
            case .hidden:
                imageView.isHidden = true
                label.isHidden = true
                caption.isHidden = true
                videoController.view.isHidden = true
            default:
                return
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



}

class PostViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
    }
}

// MARK: - Mock Data
#if DEBUG
//extension Model {
//    static let mock: Self = Model(id: "asdf", tag: Tag(rawValue: "#this is tag"), like: Like(state: .liked, count: 10))
//}

extension PostView.State {
    static let mock: Self = PostView.State(
       // tag: Model.Tag(rawValue: "#this is tag"),
        avatar: AvatarView.State(image: try! UIImage(imageName: "guy_profile_pic.jpeg")!),
        media: MediaView.State(filename: "This is a block of text to work out how to format it.", captionText: "" ),
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
