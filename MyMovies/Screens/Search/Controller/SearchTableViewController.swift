//
//  SearchTableViewController.swift
//  MyMovies
//
//  Created by link on 1/10/21.
//

import UIKit

class SearchTableViewController: UITableViewController {

	var presenter: SearchPresenterInput!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		navigationItem.title = "Search movie"
		tableView.register(MoviesListTableViewCell.self)
//		tv.prefetchDataSource = self // top update indicator
		tableView.delegate = self
		tableView.prefetchDataSource = self
		tableView.dataSource = self
		tableView.separatorStyle = .none
		navigationItem.searchController = SearchController()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
		
		let searchView = SearchView()
		searchView.delegate = self
		searchView.becomeFirstResponder()
		navigationItem.titleView = searchView

//		navigationItem.titleView?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
	
	@objc func actionBack() {
		navigationController?.popViewController(animated: true)
	}
	
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//		return presenter.
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
		return presenter.currentCount
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell:MoviesListTableViewCell = tableView.dequeueReusableCell(for: indexPath)
		let movie = presenter!.movie(at: indexPath.row)
		
		cell.fill(model:movie)

		return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension SearchTableViewController: UITableViewDataSourcePrefetching {
	func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
		if indexPaths.contains(where: isLoadingCell) {
			presenter.getNextPage()
		}
	}
}
private extension SearchTableViewController {
	func isLoadingCell(for indexPath: IndexPath) -> Bool {
		return indexPath.row >= presenter.currentCount-1
	}
}
extension SearchTableViewController: SearchProtocol {
	func succes() {
		print("succes")
		tableView.reloadData()
	}
	
	func failure(error: Error) {
		tableView.reloadData()
		print(error)
	}
	

	
	
}
extension SearchTableViewController: UITextFieldDelegate {
	func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
		if let searchText = textField.text {
			presenter.didPressSearchButton(searchText: searchText)
		}
	}
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return false
	}
}
