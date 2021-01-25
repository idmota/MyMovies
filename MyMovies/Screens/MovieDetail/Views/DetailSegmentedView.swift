//
//  DetailSegmentedView.swift
//  MyMovies
//
//  Created by link on 1/6/21.
//

import Foundation
import youtube_ios_player_helper

protocol DetailSegmentedViewInput:class {
	func playLastTrailler()
	func fillSegmentViewFromModel(model:MovieDetailModel)
}
protocol DetailSegmentedViewOutput:class {
	func getLastTrailer() -> YTPlayerView
}


final class DetailSegmentedView: UIView, DetailSegmentedViewInput {
	
	
	private var segmentData: [SegmentDetailModel]!
	
	func fillSegmentViewFromModel(model: MovieDetailModel) {
		
		overviewLabel.text = model.overview
		addVideoView(model.videos.results, widthSizeVideo: trailerScrollView.frame.size.width)
		
	}
	func playLastTrailler() {
		if let lastTrailler = stackView.subviews.last as? YTPlayerView {
			lastTrailler.playVideo()
			playLast = true
		}
	}
	private var playLast:Bool = false
	
	init() {
		super.init(frame: CGRect.zero)
		segmentData = [
			SegmentDetailModel(name: "Info", view: infoView),
			SegmentDetailModel(name: "Trailer", view: trailerScrollView)
		]
		[
			segmentedControl,
			segmentView
		].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			self.addSubview($0)
		}
		
		setupLayout()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	private func setupLayout() {
		let array = [
			segmentedControl.topAnchor.constraint(equalTo: self.topAnchor, constant: Space.single),
			segmentedControl.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			segmentedControl.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			segmentedControl.heightAnchor.constraint(equalToConstant: Space.quadruple),
			
			segmentView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: Space.single),
			segmentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Space.single),
			segmentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Space.single),
			segmentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Space.single)
		]
		NSLayoutConstraint.activate(array)
	}
	private lazy var segmentedControl:UISegmentedControl = {
		let sc = UISegmentedControl(items: segmentData.map { $0.name })
		sc.selectedSegmentIndex = 0
		sc.addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged)
		return sc
	}()
	
	@objc private func valueChanged(_ selector:UISegmentedControl) {
		segmentView.bringSubviewToFront(segmentData[selector.selectedSegmentIndex].view)
	}
	private lazy var segmentView:UIView = {
		let v = UIView()
		
		segmentData.forEach {
			$0.view.translatesAutoresizingMaskIntoConstraints = false
			v.addSubview($0.view)
			
			$0.view.topAnchor.constraint(equalTo: v.topAnchor).isActive = true
			$0.view.leadingAnchor.constraint(equalTo: v.leadingAnchor).isActive = true
			$0.view.trailingAnchor.constraint(equalTo: v.trailingAnchor).isActive = true
			$0.view.bottomAnchor.constraint(equalTo: v.bottomAnchor).isActive = true
		}
		v.bringSubviewToFront(segmentData[0].view)
		
		return v
	}()
	
	
	private lazy var infoView:UIView = {
		let iv = UIView()
		iv.backgroundColor = ColorMode.background
		iv.addSubview(overviewLabel)
		
		overviewLabel.translatesAutoresizingMaskIntoConstraints = false
		overviewLabel.topAnchor.constraint(equalTo: iv.topAnchor).isActive = true
		overviewLabel.leadingAnchor.constraint(equalTo: iv.leadingAnchor).isActive = true
		overviewLabel.trailingAnchor.constraint(equalTo: iv.trailingAnchor).isActive = true
		overviewLabel.bottomAnchor.constraint(lessThanOrEqualTo: iv.bottomAnchor).isActive = true
		
		return iv
	}()
	
	private lazy var overviewLabel: UILabel = {
		var l = UILabel()
		l.numberOfLines = 0
		l.backgroundColor = ColorMode.background
		return l
	}()
	private lazy var trailerScrollView: UIScrollView = {
		var l = UIScrollView()
		l.backgroundColor = ColorMode.background
		stackView.translatesAutoresizingMaskIntoConstraints = false
		l.addSubview(stackView)
		stackView.topAnchor.constraint(equalTo: l.topAnchor).isActive = true
		stackView.leadingAnchor.constraint(equalTo: l.leadingAnchor).isActive = true
		stackView.trailingAnchor.constraint(equalTo: l.trailingAnchor).isActive = true
		stackView.bottomAnchor.constraint(equalTo: l.bottomAnchor).isActive = true
		return l
	}()
	
	private lazy var stackView: UIStackView = {
		let sv = UIStackView()
		sv.backgroundColor = ColorMode.background
		sv.axis = .vertical
		sv.distribution = .fillProportionally
		sv.alignment = .center
		sv.spacing = Space.single
		return sv
	}()
	private func addVideoView(_ videoModel:[VideoModel], widthSizeVideo:CGFloat) {
		videoModel.forEach {
			let yp = YTPlayerView()
			yp.load(withVideoId: $0.key)
			yp.delegate = self
			yp.widthAnchor.constraint(equalToConstant: widthSizeVideo).isActive = true
			yp.heightAnchor.constraint(equalToConstant: widthSizeVideo*0.5).isActive = true
			stackView.addArrangedSubview(yp)
		}
	}
	deinit {
		stackView.subviews.forEach{
			($0 as? YTPlayerView)?.stopVideo()
		}
	}
	
}

extension DetailSegmentedView: YTPlayerViewDelegate{
	func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
		if let lastTrailler = stackView.subviews.last as? YTPlayerView, lastTrailler == playerView {
			if playLast {
				lastTrailler.playVideo()
			}
		}
	}
}
