//
//  Canvas.swift
//  Flipbook
//
//  Created by Will Bishop on 18/1/21.
//

import Foundation
import PencilKit

class DrawingPad: UIView {
	
	var canvas: PKCanvasView
	var toolPicker: PKToolPicker
	var background: UIImageView
	
	var hideBackground = false {
		didSet {
			self.background.isHidden = hideBackground
		}
	}
	
	override init(frame: CGRect) {
		self.toolPicker = PKToolPicker()
		self.background = UIImageView(image: nil)
		self.canvas = PKCanvasView(frame: .zero)
		super.init(frame: frame)
		
		self.addSubview(canvas)
		canvas.translatesAutoresizingMaskIntoConstraints = false
		toolPicker.addObserver(self.canvas)
		toolPicker.setVisible(true, forFirstResponder: self.canvas)
		self.canvas.becomeFirstResponder()
		
		self.canvas.isOpaque = false
		self.canvas.backgroundColor = .clear

		background.alpha = 0.5
		self.insertSubview(background, at: 0)

		let blankView = UIView()
		blankView.backgroundColor = .systemBackground
		blankView.translatesAutoresizingMaskIntoConstraints = false
		self.insertSubview(blankView, at: 0)
		
		background.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			canvas.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			canvas.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			canvas.topAnchor.constraint(equalTo: self.topAnchor),
			canvas.bottomAnchor.constraint(equalTo: self.bottomAnchor),
			background.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			background.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			background.topAnchor.constraint(equalTo: self.topAnchor),
			background.bottomAnchor.constraint(equalTo: self.bottomAnchor),
			blankView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			blankView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			blankView.topAnchor.constraint(equalTo: self.topAnchor),
			blankView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
		])
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
