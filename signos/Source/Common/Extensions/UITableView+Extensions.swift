//
//  UITableView+Extensions.swift
//  signos
//
//  Created by Eric Ertl on 16/10/2021.
//

import UIKit

extension UITableView {
    func setEmptyView(title: String, message: String) {
        let emptyView = UIView(frame: CGRect(x: center.x, y: center.y, width: bounds.size.width, height: bounds.size.height))
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        messageLabel.textColor = UIColor.lightGray
        messageLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20),
            messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20)
        ])
        titleLabel.text = title
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        
        backgroundView = emptyView
        separatorStyle = .none
    }
    
    func restore() {
        backgroundView = nil
        separatorStyle = .singleLine
    }
}
