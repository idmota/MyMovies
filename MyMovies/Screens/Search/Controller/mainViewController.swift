//
//  MainViewController.swift
//  testNavigationController
//
//  Created by link on 1/24/21.
//

import UIKit

class MainViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		view.addSubview(btn)

		// Do any additional setup after loading the view.
	}
	var number: Int
	init(_ number: Int ) {
		self.number = number
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	lazy var btn:UIButton = {
		let b = UIButton(frame: CGRect(x: 0, y: 60, width: 100, height: 30))
		b.setTitle("click \(number)", for: .normal)
		b.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clc)))
		return b
	}()
	@objc func clc() {
		number = number + 1
		let vc = MainViewController(number)
		navigationController?.pushViewController(vc, animated: true)
	}

	/*
	// MARK: - Navigation

	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		// Get the new view controller using segue.destination.
		// Pass the selected object to the new view controller.
	}
	*/

}
