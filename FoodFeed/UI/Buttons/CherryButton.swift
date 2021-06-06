import UIKit

public final class CherryButton: OptionButton {
    public init(frame: CGRect) {
        super.init(frame: frame, type: .one)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        super.setupInitialState(with: .one)
    }
}
