//
//  rippleButton.swift
//  Orai Trial App
//
//  Created by Chris Thompson on 11/18/17.
//  Copyright © 2017 Chris Thompson. All rights reserved.
//

import UIKit

class rippleButton: UIButton {
    var circleShape = CALayer()
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let width: CGFloat = self.bounds.size.width
        let height: CGFloat = self.bounds.size.height
        if (self.imageView!.image != nil) {
            self.circleShape = self.createImageShapeWithPosition(position: CGPoint(x: width / 2, y: height / 2), pathRect: CGRectMake(-CGRectGetMidX(self.bounds), -CGRectGetMidY(self.bounds), self.imageView!.image!.size.width, self.imageView!.image!.size.height))
            self.circleShape.contents = (self.imageView!.image!.cgImage! as AnyObject)
        }
        else {
            self.circleShape = self.createCircleShapeWithPosition(position: CGPointMake(width / 2, height / 2), pathRect: CGRectMake(-CGRectGetMidX(self.bounds), -CGRectGetMidY(self.bounds), width, height), radius: self.layer.cornerRadius)
        }
        self.layer.addSublayer(self.circleShape)
        return true
    }
    
    
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        let point = touch!.location(in: self)
        if point.x < 0 || point.y < 0 || point.x > self.bounds.size.width || point.y > self.bounds.size.height {
            self.circleShape.removeFromSuperlayer()
        }
        else {
            let scale: CGFloat = 2.5
            let groupAnimation = self.createFlashAnimationWithScale(scale: scale, duration: 0.5)
            //
            //groupAnimation["circleShaperLayer"] = self!.circleShape
            groupAnimation.delegate = self as? CAAnimationDelegate
            self.circleShape.add(groupAnimation, forKey: nil)
        }
    }
    
    
    func createImageShapeWithPosition(position: CGPoint, pathRect rect: CGRect) -> CALayer {
        let imageLayer = CALayer()
        imageLayer.bounds = rect
        imageLayer.position = position
        return imageLayer
    }
    
    
    func createCircleShapeWithPosition(position: CGPoint, pathRect rect: CGRect, radius: CGFloat) -> CAShapeLayer {
        let circleShape = CAShapeLayer()
        circleShape.path = self.createCirclePathWithRadius(frame: rect, radius: radius)
        circleShape.position = position
        circleShape.fillColor = UIColor.clear.cgColor
        circleShape.strokeColor = UIColor.purple.cgColor
        circleShape.opacity = 0
        circleShape.lineWidth = 1
        return circleShape
    }
    
    
    func createFlashAnimationWithScale(scale: CGFloat, duration: CGFloat) -> CAAnimationGroup {
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
        scaleAnimation.toValue = NSValue(caTransform3D: CATransform3DMakeScale(scale, scale, 1))
        let alphaAnimation = CABasicAnimation(keyPath: "opacity")
        alphaAnimation.fromValue = 1
        alphaAnimation.toValue = 0
        let animation = CAAnimationGroup()
        animation.animations = [scaleAnimation, alphaAnimation]
        animation.duration = 1.0
        return animation
    }
    
    
    func createCirclePathWithRadius(frame: CGRect, radius: CGFloat) -> CGPath {
        return UIBezierPath(roundedRect: frame, cornerRadius: radius).cgPath
    }
    
    


}
