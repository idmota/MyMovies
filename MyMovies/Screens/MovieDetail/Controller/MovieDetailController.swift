//
//  MovieDetailController.swift
//  MyMovies
//
//  Created by link on 11/19/20.
//

import UIKit

final class MovieDetailController: UIViewController {
	var presenter: MovieDetailPresenter!
	
	init(model:MovieModel) {
		super.init(nibName: nil, bundle: nil)
		
	}
	init() {
		super.init(nibName: nil, bundle: nil)
		
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = ColorMode.background
		
		navigationController?.isNavigationBarHidden = true
		
		let dView = DetailView(delegate: self)
		dView.fillViewFromModel(presenter.model!)
		view = dView
		
		setupView()
	}
	override func viewDidDisappear(_ animated: Bool) {
		navigationController?.isNavigationBarHidden = false
		super.viewDidDisappear(animated)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		navigationController?.isNavigationBarHidden = false
		super.viewWillDisappear(animated)
	}
	
	private lazy var navigView:UIView = {
		let v = UIView()
		let color = UIColor.lightGray
		
		v.backgroundColor = color.withAlphaComponent(0.2)
		v.translatesAutoresizingMaskIntoConstraints = false
		
		return v
	}()
	
	private lazy var backButton:UIButton = {
		let bb = UIButton()
		bb.addTarget(self, action: #selector(backAction), for: .touchUpInside)
		bb.setTitle(" \("System.Back".localized)", for: .normal)
		let img = UIImage(systemName: "arrow.uturn.left")
		
		bb.setImage(img?.withTintColor(ColorMode.background, renderingMode: .alwaysOriginal), for: .normal)
		bb.setTitleColor(ColorMode.background, for: .normal)
		return bb
	}()
	
	private lazy var shareButton:UIButton = {
		let sb = UIButton()
		sb.setImage(UIImage(named: "shareico")?.withTintColor(ColorMode.background, renderingMode: .alwaysOriginal), for: .normal)
		sb.addTarget(self, action: #selector(shareAction), for: .touchUpInside)
		return sb
	}()
	
	private func setupView() {
		[
			backButton,
			shareButton
		].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			navigView.addSubview($0)
		}
		view.addSubview(navigView)
		
		setupLayout()
	}
	private func setupLayout() {
		let constraints = [
			
			navigView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			navigView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			navigView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			
			backButton.topAnchor.constraint(equalTo: navigView.topAnchor, constant: Space.single),
			backButton.leadingAnchor.constraint(equalTo: navigView.leadingAnchor, constant: Space.single),
			backButton.bottomAnchor.constraint(equalTo: navigView.bottomAnchor, constant: -Space.single),
			
			shareButton.topAnchor.constraint(equalTo: navigView.topAnchor, constant: Space.single),
			shareButton.trailingAnchor.constraint(equalTo: navigView.trailingAnchor, constant: -Space.single),
			shareButton.bottomAnchor.constraint(equalTo: navigView.bottomAnchor, constant: -Space.single)
			
		]
		NSLayoutConstraint.activate(constraints)
		
	}
	
	@objc private func backAction() {
		navigationController?.popViewController(animated: true)
		
	}
	@objc private func shareAction() {
		let activityViewController = UIActivityViewController(activityItems: [presenter.movie!.originalTitle], applicationActivities: .none)
		self.present(activityViewController, animated: true, completion: nil)
	}
	
}

extension MovieDetailController: MovieDetailViewDelegateOutput {
	
	func dowloadPictures(pathURL: URL?, completion: @escaping (UIImage?) -> Void) {
		presenter.dowloadPictures(pathURL: pathURL, completion: completion)
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
