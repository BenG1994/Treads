//
//  CurrentRunViewController.swift
//  Treads
//
//  Created by Ben Gauger on 2/14/23.
//

import UIKit

class CurrentRunViewController: LocationViewController {

    @IBOutlet weak var sliderBackgroundImageView: UIImageView!
    @IBOutlet weak var sliderImageView: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(endRunSwiped(sender:)))
        sliderImageView.addGestureRecognizer(swipeGesture)
        sliderImageView.isUserInteractionEnabled = true
        swipeGesture.delegate = self as? UIGestureRecognizerDelegate
    }
    

    @objc func endRunSwiped(sender: UIPanGestureRecognizer) {
        let minAdjust: CGFloat = 78
        let maxAdjust: CGFloat = 128
        if let sliderView = sender.view {
            if sender.state == UIGestureRecognizer.State.began || sender.state == UIGestureRecognizer.State.changed {
                let translation = sender.translation(in: self.view)
                if sliderView.center.x >= (sliderBackgroundImageView.center.x - minAdjust) && sliderView.center.x <= (sliderBackgroundImageView.center.x + maxAdjust) {
                    sliderView.center = CGPoint(x: sliderView.center.x + translation.x, y: sliderView.center.y)
                }else if sliderView.center.x >= (sliderBackgroundImageView.center.x + maxAdjust) {
                    sliderView.center.x = sliderBackgroundImageView.center.x + maxAdjust
//                    end run code goes here
                    dismiss(animated: true)
                }else {
                    sliderView.center.x = sliderBackgroundImageView.center.x - minAdjust
                }
                sender.setTranslation(CGPoint.zero, in: self.view)
            }else if sender.state == UIGestureRecognizer.State.ended {
                UIView.animate(withDuration: 0.1) {
                    sliderView.center.x = self.sliderBackgroundImageView.center.x - minAdjust
                }
            }
        }
    }

}
