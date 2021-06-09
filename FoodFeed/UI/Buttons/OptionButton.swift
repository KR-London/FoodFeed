import UIKit

public enum OptionType {
    case one, two, notSure
    
    func getColor() -> UIColor {
        switch self {
        case .one:
            return Colors.coral
        case .two:
            return Colors.creamsicle
        case .notSure:
            return Colors.teal
        }
    }
}

public class OptionButton: UIButton {
    public var type: OptionType = .one
    
    public var video:String = ""
    public var answer:String = ""
    
    convenience init(video: String) {
        self.init(frame: CGRect(x: 10, y: 10, width: 10, height: 10), type: .one)
        self.video = video
        self.answer = answer
    }
    
    private var shadowLayer: CAShapeLayer!
//
    public override var isHighlighted: Bool {
        didSet {
            if isPicked == false{
                backgroundColor = isHighlighted ? type.getColor() : .white
                shadowLayer.fillColor = isHighlighted ? type.getColor().cgColor : UIColor.white.cgColor
            }
           // backgroundColor = isSelected ? type.getColor() : .white
          //  shadowLayer.fillColor = isSelected ? type.getColor().cgColor : UIColor.white.cgColor
        }
    }

        // Bool property
    var isPicked: Bool = false {
        didSet {
            if isPicked == true {
                backgroundColor = type.getColor()
                shadowLayer.fillColor =  type.getColor().cgColor

            } else {
                backgroundColor = .white
                shadowLayer.fillColor = UIColor.white.cgColor

            }
        }
    }
    
    public override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? .white : Colors.lightGrey
            layer.borderColor = isEnabled ? type.getColor().cgColor : Colors.grey.cgColor
        }
    }
    
    public init(frame: CGRect, type: OptionType) {
        self.type = type
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 5.0).cgPath
            shadowLayer.fillColor = UIColor.white.cgColor

            shadowLayer.shadowColor = #colorLiteral(red: 0.8745098039, green: 0.8745098039, blue: 0.8745098039, alpha: 1)
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 5.0, height: 15.0)
            shadowLayer.shadowOpacity = 0.4
            shadowLayer.shadowRadius = 5.0
            
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
    
    func setupInitialState(with type: OptionType) {
        self.type = type
        
        clipsToBounds = true
        
        layer.borderWidth = 1.0
        
        titleLabel?.alpha = 1.0
        
        layer.cornerRadius = 6.0
        layer.masksToBounds = false
        layer.borderColor = type.getColor().cgColor
        
        titleLabel?.font = Fonts.defaultMediumFont
        
        setTitleColor(type.getColor(), for: .normal)
        setTitleColor(.white, for: .highlighted)
        setTitleColor(.white, for: .selected)
        setTitleColor(type.getColor(), for: .disabled)
       // setTitleColor(Colors.grey, for: .disabled)
        
//        let attributedString = NSMutableAttributedString(string: currentTitle ?? "")
//        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(1.0), range: NSRange(location: 0, length: attributedString.length))
//        setAttributedTitle(attributedString, for: .normal)
        
        if !isEnabled {
            backgroundColor = Colors.lightGrey
            layer.borderColor = Colors.grey.cgColor
        }
    }
}
