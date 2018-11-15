import UIKit

enum DeviceSize {
    case small
    case medium
    case large
    case extraLarge
    
    static func size() -> DeviceSize {
        let height = UIApplication.shared.statusBarOrientation.isPortrait ?
            UIScreen.main.bounds.size.height :
            UIScreen.main.bounds.size.width
        
        if height <= 568 { return .small }
        else if height <= 667 { return .medium }
        else if height <= 1024 { return .large }
        else { return .extraLarge }
    }
    
    static func value<T>(small: T? = nil, medium: T? = nil, large: T? = nil, extraLarge: T) -> T {
        let size = DeviceSize.size()
        
        switch size {
        case .small: return small ?? medium ?? large ?? extraLarge
        case .medium: return medium ?? large ?? extraLarge
        case .large: return large ?? extraLarge
        case .extraLarge: return extraLarge
        }
    }
}
