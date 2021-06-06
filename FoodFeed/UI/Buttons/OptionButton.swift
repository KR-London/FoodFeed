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
    
    private var shadowLayer: CAShapeLayer!
    
    public override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? type.getColor() : .white
            shadowLayer.fillColor = isHighlighted ? type.getColor().cgColor : UIColor.white.cgColor
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

            shadowLayer.shadowColor = Colors.grey.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 10.0, height: 10.0)
            shadowLayer.shadowOpacity = 0.3
            shadowLayer.shadowRadius = 5.0

            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
    
    func setupInitialState(with type: OptionType) {
        self.type = type
        
        clipsToBounds = true
        
        layer.borderWidth = 2.0
        
        titleLabel?.alpha = 1.0
        
        layer.cornerRadius = 6.0
        layer.masksToBounds = false
        layer.borderColor = type.getColor().cgColor
        
        titleLabel?.font = Fonts.defaultMediumFont
        
        setTitleColor(type.getColor(), for: .normal)
        setTitleColor(.white, for: .highlighted)
        setTitleColor(Colors.grey, for: .disabled)
        
        if !isEnabled {
            backgroundColor = Colors.lightGrey
            layer.borderColor = Colors.grey.cgColor
        }
    }
}
