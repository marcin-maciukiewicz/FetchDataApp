import Foundation

private class Anchor: AnyObject {}

extension Bundle {
    static var testBundle: Bundle {
        Bundle(for: Anchor.self)
    }
}
