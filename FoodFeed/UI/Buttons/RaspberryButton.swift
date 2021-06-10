import UIKit

class RaspberryButton: OptionButton {
    public init(frame: CGRect) {
        super.init(frame: frame, type: .two)
        super.setupInitialState(with: .two)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        super.setupInitialState(with: .two)
    }
}
