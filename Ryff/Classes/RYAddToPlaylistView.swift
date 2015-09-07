//
//  RYAddToPlaylistView.swift
//  Ryff
//
//  Created by Christopher Laganiere on 9/7/15.
//  Copyright (c) 2015 Chris Laganiere. All rights reserved.
//

import UIKit

class RYAddToPlaylistView: UIView {
    
    private let imageView = UIImageView(frame: CGRectZero)
    private let label = UILabel(frame: CGRectZero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.image = UIImage(named: "plus")
        imageView.tintColor = RYStyleSheet.postActionColor()
        imageView.contentMode = .ScaleAspectFit
        imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        addSubview(imageView)
        
        label.text = "Add to Playlist"
        label.textColor = RYStyleSheet.postActionColor()
        label.textAlignment = .Right
        label.setDynamicStyle(TextStyle.Body, fontStyle: .Regular)
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        addSubview(label)
        
        NSLayoutConstraint.activateConstraints(subviewContraints())
    }
    
    @availability(*, unavailable)
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func subviewContraints() -> [NSLayoutConstraint] {
        let views = ["image": imageView, "text": label]
        let metrics = ["relatedPadding": Constants.Global.RelatedElementPadding, "actionDimension": Constants.Post.AudioActionHeightSmall]
        
        var constraints: [AnyObject] = []
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|[text]-(relatedPadding)-[image(actionDimension)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views)
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|[image(actionDimension)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views)
        constraints += [NSLayoutConstraint(item: label, attribute: .CenterY, relatedBy: .Equal, toItem: imageView, attribute: .CenterY, multiplier: 1.0, constant: 0.0)]
        return constraints as? [NSLayoutConstraint] ?? []
    }

}