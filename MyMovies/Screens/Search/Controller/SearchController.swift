//
//  SearchController.swift
//  MyMovies
//
//  Created by link on 1/7/21.
//

import UIKit

class SearchController: UISearchController, UISearchControllerDelegate {
	var presenter: SearchPresenterInput!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.searchResultsUpdater = self
		// 2
		self.obscuresBackgroundDuringPresentation = false
		// 3
		self.searchBar.placeholder = "Search movie"
//		self.isModalInPresentation = true
//		self.searchBar.scopeButtonTitles = ["Title", "Genre"]
		self.searchBar.showsSearchResultsButton = true
//		self.delegate = self
		self.searchBar.delegate = self
		self.searchResultsUpdater = self
        // Do any additional setup after loading the view.
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
extension SearchController: SearchProtocol {
//	var presenter: SearchPresenterInput {
//		
//	}
	

	func succes() {
		
	}
	
	func failure(error: Error) {
		
	}
	
	
}

extension SearchController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
//	let searchBar = searchController.searchBar
//	let category = Candy.Category(rawValue:
//	  searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex])
//	filterContentForSearchText(searchBar.text!, category: category)
	
  }
}

extension SearchController: UISearchBarDelegate {
	@objc(setToketForIndexWithIndex:) func setToketForIndex(index:Int){
		searchBar.searchTextField.tokens.removeAll()
		guard let scopeTitles = self.searchBar.scopeButtonTitles else {return}
		let textToken = scopeTitles[index]
	
		let shopToken = UISearchToken (icon: nil, text: textToken)
		searchBar.searchTextField.insertToken (shopToken, at: 0)
	}
}


