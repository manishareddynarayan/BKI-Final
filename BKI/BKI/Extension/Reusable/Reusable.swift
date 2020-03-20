import Foundation
import UIKit


protocol Reusable: class
{
    static var reuseIdentifier: String { get }
    static var nib: UINib? { get }
}

extension Reusable
{
    static var reuseIdentifier: String { return String(describing: self) }
    static var nib: UINib? { return nil }
}


