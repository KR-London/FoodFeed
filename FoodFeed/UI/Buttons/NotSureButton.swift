import UIKit

public final class NotSureButton: OptionButton {
    public init(frame: CGRect) {
        super.init(frame: frame, type: .notSure)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        super.setupInitialState(with: .notSure)
    }
}
