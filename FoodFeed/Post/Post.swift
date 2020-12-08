import Foundation
import UIKit

enum Media {
    case image(URL) // data
    case video(URL, position: Int)
    case unknown(URL) // should be able to fallback to image or video, not sure best way yet
}

enum Interaction {
    struct Poll {
        struct Option {
            let ID: UUID
            let text: String
            let votes: Int
        }
        let ID: UUID // TODO: should make ID's specific to types
        let questionText: String
        let options: [Option] // TODO: could restrict to only 2?
    }
    case CommentPrompt(String)
    case PollPrompt(Poll)
    case PhotoPrompt
}

struct PostModel: Identifiable {
    let id: ID
    var bigText: String
    var caption: String
    var media: Media // gif, video, image
    var interaction: Interaction
    var tag: Tag?

    struct Like {
        var state: State
        var count: Int
        
        enum State {
            case liked
            case disliked
            case undecided
        }
    }
    
    struct ID: RawRepresentable, Hashable {
        let rawValue: Int
        init(rawValue value: Int) {
            self.rawValue = value
        }
    }
    
    struct Tag: RawRepresentable, Hashable {
        let rawValue: String
        var displayText: String {
            return "# \(rawValue)"
        }
    }
}

struct TextContent: RawRepresentable, Hashable {
    let rawValue: String
    init?(rawValue: String) {
        if rawValue.count > 400 {
            return nil
        }
        self.rawValue = rawValue
    }
}

extension PostModel.ID: ExpressibleByIntegerLiteral {
    init(integerLiteral value: Int) {
        self.init(rawValue: value)
    }
}

final class AvatarView: UIView {
    private let margin: CGFloat = 2
    private let imageView = UIImageView()
    
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
                    let image = UIImage(named: "one.jpeg")!
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
    }
    
    let stackView = UIStackView()
    let controlsStack = UIStackView()
    let tagLabel = UILabel.tagLabel()
    let avatarView = AvatarView()
    let mediaView = MediaView()
    
    var delegate : FeedViewInteractionDelegate?
    
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    init(frame: CGRect, feed: Feed) {
        super.init(frame: frame)
        
        setup()
//
//        switch feed {
//            case let gifName where gifName == feed.gifName :
//                self.update(state: PostView.State(
//                    // tag: Model.Tag(rawValue: "#this is tag"),
//                    avatar: AvatarView.State(image: try! UIImage(imageName: "one.jpeg")!),
//                    media: MediaView.State(gifImage: try! UIImage(gifName: gifName ?? "giphy30.gif")
//                    )
//                ))
//
//            default :  self.update(state: PostView.State(
//                        avatar: AvatarView.State(image: try! UIImage(imageName: "one.jpeg")!),
//                        media: MediaView.State(gifImage: UIImage(named: feed.image) ?? UIImage(gifName: feed.gifName) ?? UIImage(gifName: "giphy30.gif")
//                        )
//                    ))
//        }
        
        self.update(state: PostView.State(
            
            //FIXME: Refactor
            // tag: Model.Tag(rawValue: "#this is tag"),
            avatar: AvatarView.State(image: try! UIImage(imageName: "one.jpeg")!),
            media: MediaView.State(filename: "giphy30.gif")
        ))
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
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

    
    func setupRightView() {
        addSubview(controlsStack)
        controlsStack.axis = .vertical

        let lView = likeView()
        controlsStack.addArrangedSubview(avatarView)
        controlsStack.addArrangedSubview(lView)
        controlsStack.setCustomSpacing(36, after: lView)
        controlsStack.addArrangedSubview(commentView())
        controlsStack.isLayoutMarginsRelativeArrangement = true
        controlsStack.spacing = 24
        controlsStack.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        controlsStack.widthAnchor.constraint(equalToConstant: 80).isActive = true
        controlsStack.translatesAutoresizingMaskIntoConstraints = false
        controlsStack.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        controlsStack.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
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
        xxx.text = "asdfasdfsadf"
        textStack.addArrangedSubview(tagLabel)
        textStack.addArrangedSubview(xxx)
        addSubview(textStack)
        textStack.translatesAutoresizingMaskIntoConstraints = false
        textStack.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor, constant: 16).isActive = true
        textStack.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor).isActive = true
    }
    
    func update(state: State) {
      //  tagLabel.text = state.tag?.rawValue
        avatarView.update(state: state.avatar)
        mediaView.update(state: state.media)
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



struct PostModel2 {
    enum Media {
        case image(URL)
        case video(URL, position: Int)
        case unknown(URL) // should be able to fallback to image or video, not sure best way yet
    }
    
    struct Author { // fix up model maybe, fine for now
        let ID: UUID
        let avatar: URL
        let username: String
    }
    struct Comment { // fix up model, combine the user/username somehow
        struct Author {
            let ID: UUID
            let username: String
        }
        let content: String
        let user: Author
        let date: Date
    }
    
    struct Tag {
        let rawValue: String
    }
    
    enum Interaction {
        struct Poll {
            struct Option {
                let ID: UUID
                let text: String
                let votes: Int
            }
            let ID: UUID // TODO: should make ID's specific to types
            let questionText: String
            let options: [Option] // TODO: could restrict to only 2?
        }
        case CommentPrompt(String)
        case PollPrompt(Poll)
        case PhotoPrompt
    }
    
    let media: Media
    let caption: String
    let tags: [Tag]
    let comments: [Comment]
    let author: Author
}


final class MediaView: UIView {
    enum State {
        case gifImage(gifImage: UIImage)
        case video(video: String)
        case stillImage(image: UIImage)
        case hidden
        
        init(filename: String) {
            switch filename.suffix(4){
                case ".mp4":
                    self = .video(video: filename )
                case "jpeg", ".jpg", ".png":
                    self = .stillImage(image: UIImage(named: filename) ?? UIImage(named: "two.jpeg")!  )
                case ".gif":
                    //FIXME: Is the try! robust....? Feels quite possible we will send some bad data in at some point
                    self = .gifImage(gifImage: try! UIImage(gifName: filename))
                default: self = .hidden
            }
            
           
        }
        
        init() {
            self = .hidden
        }
    }

    let imageView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        self.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: imageView.trailingAnchor).isActive = true
        self.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
    }
    
    
    func update(state: State) {
        ///imageView.setGifImage(state.gifImage, loopCount: -1)
        switch state {
            case .gifImage( let gifImage):
                imageView.setGifImage(gifImage, loopCount: -1)
            default:
                return
        }
    }

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
        avatar: AvatarView.State(image: try! UIImage(imageName: "one.jpeg")!),
        media: MediaView.State(filename: "giphy30.gif")
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
