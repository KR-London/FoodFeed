import UIKit

public final class CherryButton: UIButton {
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialState()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CherryButton {
    func setupInitialState() {
        clipsToBounds = true
        
        layer.cornerRadius = 5.0
        titleLabel?.font = Fonts.defaultMediumFont
        
        setTitleColor(Colors.coral, for: .normal)
        setTitleColor(.white, for: .highlighted)
        setTitleColor(Colors.darkGrey, for: .disabled)
        
        setBackgroundColor(color: .white, forState: .normal)
        setBackgroundColor(color: Colors.coral, forState: .highlighted)
        setBackgroundColor(color: Colors.grey, forState: .disabled)
    }
    
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            setBackgroundImage(colorImage, for: forState)
        }
    }
}
