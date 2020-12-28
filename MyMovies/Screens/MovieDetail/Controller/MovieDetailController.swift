//
//  MovieDetailController.swift
//  MyMovies
//
//  Created by link on 11/19/20.
//

import UIKit
import youtube_ios_player_helper

class MovieDetailController: UIViewController, YTPlayerViewDelegate {
	var presenter: MovieDetailPresenter!
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = ColorMode.background
//		navigationItem.title = presenter.movie?.title
//		navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//		navigationController?.navigationBar.shadowImage = UIImage()
//		navigationController?.tabBarItem.badgeColor = .cyan
//		navigationController?.navigationI
//		navigationController?.navigationBar.isTranslucent = true
//		navigationController?.navigationBar.backgroundColor = UIColor.blue.withAlphaComponent(0)

        // Do any additional setup after loading the view.

		view = MovieDetailView(delegate: self)
		
    }
	

	@objc func playVideo() {
		
//		guard let url = URL(string: "https://www.youtube.com/watch?v=2_N3VDK_dJQ") else { return }
//		let player = AVPlayer(url: url)
//		let controller = AVPlayerViewController()
//		controller.player = player
//		present(controller, animated: true){
//			player.play()
//		}
	}

	
}

extension MovieDetailController: MovieDetailViewDelegateOutput {
	func openLink() {
		print("open link")
		var yp = YTPlayerView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
		yp.delegate = self
		yp.load(withVideoId: "2_N3VDK_dJQ")
		yp.playVideo()
		yp.clipsToBounds = true
		view.addSubview(yp)
	}
	
	
}
extension MovieDetailController: MovieDetailProtocol {
	func succes() {
		guard let vv = view as? MovieDetailViewDelegateInput else {
			return
		}
		vv.fillViewFromModel(model:presenter.movie!)
		
	}
	
	func failure(error: Error) {
		Logger.handleError(error)
	}
	
	
}
