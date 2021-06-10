import UIKit

final class CherryButton: OptionButton {
    public init(frame: CGRect) {
        super.init(frame: frame, type: .one)
        super.setupInitialState(with: .two)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        super.setupInitialState(with: .one)
    }
}
