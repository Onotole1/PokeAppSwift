//
// Created by Анатолий Спитченко on 31.05.2021.
//

import UIKit

extension UIScrollView {
    var isReachingEnd: Bool {
        contentOffset.y >= 0
                && contentOffset.y >= (contentSize.height - frame.size.height)
    }
}
