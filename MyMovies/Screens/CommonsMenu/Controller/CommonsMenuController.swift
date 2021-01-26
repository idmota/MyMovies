//
//  CommonsMenuController.swift
//  MyMovies
//
//  Created by link on 12/4/20.
//

import UIKit

final class CommonsMenuController: UIViewController {
	
	var presenter: CommonsMenuPresenter?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setipView()
		presenter?.didLoadView()
	}
	
	private func setipView() {
		[
			menuTable
		].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			view.addSubview($0)
		}
		
		setypLayout()
	}
	
	private func setypLayout() {
		let array = [
			menuTable.topAnchor.constraint(equalTo: view.topAnchor),
			menuTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			menuTable.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -Space.heghtBottomControlPanel),
			menuTable.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		]
		NSLayoutConstraint.activate(array)
	}
	private lazy var menuTable:UITableView = {
		let t = UITableView(frame: CGRect.zero, style: .plain)
		t.register(CommonsMenuTableViewCell.self)
		t.delegate = self
		t.dataSource = self
		t.separatorStyle = .none
		t.isScrollEnabled = false
		return t
	}()
	
}
extension CommonsMenuController:CommonsMenuControllerProtocol, UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let lPresenter = presenter else {return 0}
		return lPresenter.totalCount
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell:CommonsMenuTableViewCell = tableView.dequeueReusableCell(for: indexPath)
		guard let lPresenter = presenter else {return cell}
		cell.make(menuModel: lPresenter.itemMenu(at: indexPath.row))
		
		return cell
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		presenter?.didOpenScreen(at: indexPath.row)
	}
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "MyMovie"
	}
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
}


