//
//  Extensions.swift
//  Interview
//
//  Created by Andres Wang on 2018/4/16.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import Foundation
import UIKit

extension Data {
    func parseTo<T: Codable>(jsonType: T.Type) -> T? {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(jsonType, from: self)
            return result
        } catch {
            print("JSON Error: \(error)")
            return nil
        }
    }
}
extension UIView {
    func showActivityPanel(message: String) -> UIVisualEffectView {
        // Label Width
        let font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        let attributedString = NSAttributedString(string: message, attributes: [NSAttributedStringKey.font: font])
        let sizeToFit = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 46)
        let labelWidth = attributedString.boundingRect(with: sizeToFit, options: .usesLineFragmentOrigin, context: nil).width.rounded(.up)
        
        // Panel
        let panel = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        panel.translatesAutoresizingMaskIntoConstraints = false
        let panelHeight = panel.heightAnchor.constraint(equalToConstant: 46)
        let panelWidth = panel.widthAnchor.constraint(equalToConstant: 46 + labelWidth + 15)
        panel.addConstraints([panelHeight, panelWidth])
        panel.clipsToBounds = true
        panel.layer.cornerRadius = 9
        panel.tag = 300
        
        // Indicator
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        activityIndicator.startAnimating()
        panel.contentView.addSubview(activityIndicator)
        
        // Label
        let label = UILabel(frame: CGRect(x: 46, y: 0, width: labelWidth, height: 46))
        label.text = message
        label.font = font
        label.textColor = #colorLiteral(red: 0.4808454055, green: 0.4808454055, blue: 0.4808454055, alpha: 1)
        panel.contentView.addSubview(label)
        
        // Show Panel (Remove old panels if there is any)
        if let superView = self.superview {
            for oldPanel in (superView.subviews.filter {$0.tag == 300}) {oldPanel.removeFromSuperview()}
            superView.addSubview(panel)
            let panelXCenter = panel.centerXAnchor.constraint(equalTo: superView.centerXAnchor)
            let panelYCenter = panel.centerYAnchor.constraint(equalTo: superView.centerYAnchor)
            superView.addConstraints([panelXCenter, panelYCenter])
        }
        return panel
    }
}

extension UIViewController {
    func showNetworkError() {
        let alert = UIAlertController(title: NSLocalizedString("Whoops...", comment: "Network error title"), message: NSLocalizedString("There was an error accessing Moviedb database. Please try again.", comment: "Network error message"), preferredStyle: .alert)
        let action = UIAlertAction(title: NSLocalizedString("OK", comment: "Confirm Button"), style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    func showNothingFoundError() {
        let alert = UIAlertController(title: NSLocalizedString("Sorry...", comment: "Nothing found error title"), message: NSLocalizedString("Nothing found in our database. Please try other names.", comment: "Nothing found error message"), preferredStyle: .alert)
        let action = UIAlertAction(title: NSLocalizedString("OK", comment: "Confirm Button"), style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

protocol ActivityIndicatable: class {
    var activityView: UIVisualEffectView? {get set}
}

extension ActivityIndicatable where Self: UIViewController {
    func startActivityIndicator() {
        activityView = view.showActivityPanel(message: NSLocalizedString("Loading...", comment: "Network working"))
    }
    func stopActivityIndicator() {
        activityView?.removeFromSuperview()
        activityView = nil
    }
}


