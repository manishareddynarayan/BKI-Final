import Foundation
import  UIKit

extension UITableView
{
    func registerReusableCell<T: UITableViewCell>(_: T.Type) where T: Reusable
    {
        if let nib = T.nib
        {
            self.register(nib, forCellReuseIdentifier: T.reuseIdentifier)
        }
        else
        {
            self.register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
        }
    }
    
    func dequeueReusableCell<T: UITableViewCell>(indexPath: IndexPath) -> T where T: Reusable
    {
        return self.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
    
    func registerReusableHeaderFooterView<T: UITableViewHeaderFooterView>(_: T.Type) where T: Reusable
    {
        if let nib = T.nib
        {
            self.register(nib, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
        }
        else
        {
            self.register(T.self, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
        }
    }
    
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T? where T: Reusable
    {
        return self.dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as! T?
    }
}
