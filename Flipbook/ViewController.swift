//
//  ViewController.swift
//  Flipbook
//
//  Created by Will Bishop on 18/1/21.
//

import UIKit
import PencilKit

struct Flipbook: Codable {
	var pages: [Flippage]
}

struct Flippage: Codable {
	var drawing: PKDrawing?
	
	var image: UIImage? {
		get {
			guard let drawing = drawing else {
				return nil
			}
			return drawing.image(from: drawing.bounds, scale: UIScreen.main.scale)
		}
	}
}

class ViewController: UIViewController, PKCanvasViewDelegate {
	
	var book = Flipbook(pages: [])
	var currentIndex = 0
	let drawingPad = DrawingPad(frame: .zero)
	let nextButton = UIButton(type: .system)
	let previousButton = UIButton(type: .system)
	let playButton = UIButton(type: .system)
	var isPlaying = false
	var playbackTimer: Timer?
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		self.view.backgroundColor = .secondarySystemBackground
		self.book.pages.append(Flippage(drawing: nil))
		self.previousButton.isEnabled = false
		drawingPad.canvas.delegate = self
		self.view.addSubview(drawingPad)
		drawingPad.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			drawingPad.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
			drawingPad.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
			drawingPad.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5),
			drawingPad.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.5),
		])
		
		playButton.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
		nextButton.setImage(UIImage(systemName: "arrow.right.circle.fill"), for: .normal)
		previousButton.setImage(UIImage(systemName: "arrow.left.circle.fill"), for: .normal)
		
		nextButton.translatesAutoresizingMaskIntoConstraints = false
		nextButton.addTarget(self, action: #selector(goToNextPage), for: .touchUpInside)
		
		previousButton.translatesAutoresizingMaskIntoConstraints = false
		previousButton.addTarget(self, action: #selector(goToPreviousPage), for: .touchUpInside)
		
		playButton.translatesAutoresizingMaskIntoConstraints = false
		playButton.addTarget(self, action: #selector(togglePlayback), for: .touchUpInside)
		
		
		self.view.addSubview(nextButton)
		self.view.addSubview(previousButton)
		self.view.addSubview(playButton)
		
		NSLayoutConstraint.activate([
			previousButton.trailingAnchor.constraint(equalTo: drawingPad.leadingAnchor, constant: -8.0),
			previousButton.centerYAnchor.constraint(equalTo: drawingPad.centerYAnchor),
			nextButton.leadingAnchor.constraint(equalTo: drawingPad.trailingAnchor, constant: 8.0),
			nextButton.centerYAnchor.constraint(equalTo: drawingPad.centerYAnchor),
			playButton.centerXAnchor.constraint(equalTo: drawingPad.centerXAnchor),
			playButton.topAnchor.constraint(equalTo: drawingPad.bottomAnchor, constant: 8.0)
		])
		
	}
	
	@objc func goToPreviousPage() {
		currentIndex = max(currentIndex - 1, 0)
		if currentIndex == 0 {
			self.previousButton.isEnabled = false
		}
		pageChanged()
	}
	
	@objc func goToNextPage() {
		currentIndex += 1
		self.book.pages.append(Flippage(drawing: self.drawingPad.canvas.drawing))
		self.previousButton.isEnabled = true
		pageChanged()
	}
	
	@objc func togglePlayback() {
		isPlaying.toggle()
		if isPlaying {
			playButton.setImage(UIImage(systemName: "stop.circle.fill"), for: .normal)
			self.drawingPad.canvas.isHidden = true
			self.drawingPad.background.alpha = 1.0
			
			let pageCount = self.book.pages.count
			
			var playIndex = self.currentIndex
			playbackTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] (_) in
				guard let self = self else { return }
				self.drawingPad.background.image = self.book.pages[playIndex].drawing?.image(from: self.drawingPad.bounds, scale: UIScreen.main.scale)
				playIndex += 1
				if playIndex >= pageCount {
					playIndex = 0
				}
			}
		} else {
			playbackTimer?.invalidate()
			playButton.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
			self.drawingPad.canvas.isHidden = false
			self.drawingPad.background.alpha = 0.5
			pageChanged()
		}
	}
	
	func pageChanged() {
		self.drawingPad.canvas.drawing = self.book.pages[currentIndex].drawing ?? PKDrawing()
		if currentIndex > 0 {
			self.drawingPad.background.image = self.book.pages[currentIndex - 1].drawing?.image(from: drawingPad.bounds, scale: UIScreen.main.scale)
		}
	}
	
	func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
		self.book.pages[currentIndex].drawing = canvasView.drawing
	}
	
	
}

