//
// Created by Анатолий Спитченко on 29.05.2021.
//

import UIKit

extension UIView {
    var isVisible: Bool {
        set {
            isHidden = !newValue
        }
        get {
            !isHidden
        }
    }
}
