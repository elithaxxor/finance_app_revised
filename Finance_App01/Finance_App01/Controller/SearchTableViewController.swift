//
//  ViewController.swift
//  Financial_Calc_II
//
//  Created by a-robota on 4/20/22.
//
//
//  ViewController.swift
//  FinanceApp
//
//  Created by a-robota on 4/20/22.
//
//
// https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=IBM&interval=5min&apikey=demo
// https://www.alphavantage.co/documentation/
// https://developer.apple.com/documentation/combine



// TODO : 1. FETCH FINANCE DOCS 2. SET UP NEWSPAPER API. 3. LIVE NEWS FEED UNDER SEARCHRESULTS 4. PDF SCANNER 5. ROTATE VIEWS FOR CALC
import UIKit
import Combine
import MBProgressHUD
import SwiftUI

@IBDesignable
class SearchTableViewController: TableViewControllerLogger, MBProgAnimate {

    private enum Mode {
        case onboarding // homescreen (no search)
        case search // renders users result
    }
    
    // Class Instances //
    private let runAPI = APIWorker()
    private let viewCell = SearchTableViewCell()


    private var searchResults: SearchResults? // return Models fetched from API
    var subscribers = Set<AnyCancellable>() // for fetch
    

    @Published private var mode: Mode = .onboarding // UI state (onboarding or searcahing)
    @Published private var searchQuery = String() // search query (nav bar)

    var homeTextValueVC: String?


    // [ensures UISearchBar loads everytime]-- instantiates UISearchController
    private lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        sc.delegate = self
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "Enter Company Name or $Ticker"
        sc.searchBar.autocapitalizationType = .allCharacters
        return sc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createLogFile()
        NSLog("[LOGGING--> <START> [SEARCH VC]")
        print(homeTextValueVC ?? "DEBUG ME")
        setupNavBar()
        setupTableView() // FOR UI, when no search results.
        observeForm()

        NSLog("[LOGGING--> <END> [CALCULATOR VC]")

    }


    override func viewWillAppear(_ animated: Bool) {
       // viewCell.configure(with: searchResults.self)
    }
    
    private func setupNavBar() {
        navigationItem.searchController = searchController
        navigationItem.title = "Search"
    }
    
    
    @IBAction func calcBtn(_ sender: UIBarButtonItem) {
        print("[+] Segue to Basic Calcualtor")
        self.performSegue(withIdentifier: "toBasicCalc", sender: self)
    }


    @IBAction func twitterBtn(_sender: Any) {
        print("[!] Twitter Btn Pressed! ")
        //        guard self.performSegue(withIdentifier: "toBasicCalc", sender: sender) else { fatalError("failed to segue twitter btn") }
    }


    private func setupTableView(){
        tableView.tableFooterView = UIView() // removes lineitems on navviews
    }


    
    
    @IBAction func searchBtn (_ sender: UIButton) {
        print("[!] SearchTable button pressed")
        performSegue(withIdentifier: "searchBtn2FinCalc", sender: self)
    }
    
    // [COMPANY SEARCH BOTTOM NAV ITEMS]
    @IBAction func dcf2news(_ sender: UIButton) {
        print("User pressed search new btn on Company Search, moving to news page")
        print (sender.buttonType)
        performSegue(withIdentifier: "search2news", sender: self)
    }
    
    @IBAction func searchClassicCalc(_ sender: UIButton) {
        print("User pressed search new btn on Company Search, moving to calc page")
        print (sender.buttonType)
        performSegue(withIdentifier: "search2calc", sender: self)
    }
    

    // [DCF PAGE]
    @IBAction func dcf2News(_ sender: UIBarButtonItem) {
        print("User pressed search new btn on [DCF page,] moving to news ")
        performSegue(withIdentifier: "dcf2News", sender: self)
    }
    @IBAction func dcf2Calc(_ sender: UIBarButtonItem) {
        print("User pressed search new btn on [DCF page], moving to [calc] ")
        performSegue(withIdentifier: "dcf2Calc", sender: self)
    }

    @IBOutlet weak var searchInput : UITextField! {
        didSet {
            print("[!] Search Input passed From homeView \(String(describing: searchInput.text))")
        }
    }



    
    // set up timer for response, while watches for Publisher to change [creates a waitingQueue (.debounce) on main thread) for NavBar in
    private func observeForm(){
        $searchQuery
            .debounce(for: .milliseconds(1000), scheduler: RunLoop.main)
            .sink { [ unowned self ] (searchQuery) in
                MBProgressHUD.showAdded(to: self.view, animated: true)
                guard !searchQuery.isEmpty else  { return }

                self.showLoadingAnimation()
                print("[+] Search Query Returned \(searchQuery)")
                self.runAPI.fetchSymbols(keywords: searchQuery).sink { (completion) in
                    switch completion {
                        case .failure(let error):
                            print(error.localizedDescription)
                        case .finished: break
                    }
                } receiveValue: { ( searchResults) in
                    self.searchResults = searchResults
                    self.tableView.reloadData()
                    print(self.searchResults ?? "DEBUG ME--> SearchTable observeForm() ")
                }.store(in: &self.subscribers)
            }
        
        
        guard !searchQuery.isEmpty else {
            print("search navbar is empty")
            return
        }
        

        showLoadingAnimation()
        self.runAPI.fetchSymbols(keywords: searchQuery).sink { (completion) in
            switch completion {
                case .failure(let error):
                    print("Error, observedForm \(error)")
                    print(error.localizedDescription)

                case.finished: break
            }
        }
        
    receiveValue: { (searchResults ) in
        self.searchResults = searchResults
        self.tableView.reloadData() // maintains state ui persistance
        self.tableView.isScrollEnabled = true
    }.store(in: &subscribers)

        
        $mode.sink { [unowned self] (mode) in
            switch mode {
                case .onboarding:
                    self.tableView.backgroundView = nil
                case .search:
                    self.tableView.backgroundView = nil


            }
        }.store(in: &subscribers)

    }
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! SearchTableViewCell
        if let searchResults = self.searchResults
        {
            let searchResult  = searchResults.allResults[indexPath.row]
            cell.configure(with: searchResult)
            return cell 
        }
        return cell
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults?.allResults.count ?? 0
    }

    // MARK: Segues into Stock Calculator screen
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let searchResults = self.searchResults {
            let searchResult = searchResults.allResults[indexPath.item]
            let symbol = searchResult.symbol

            handleSelection(for: symbol, searchResult: searchResult)
        }
    }

    // MARK: To handle indivdual cell seletion
    private func handleSelection(for symbol: String, searchResult: SearchResult) {
        showLoadingAnimation()
        runAPI.fetchMonthlyAdjustedObj(keywords: symbol).sink { [weak self] (completionResult) in
            self?.hideLoadingAnimation()
            switch completionResult {
                case.failure(let error):
                    print("[!] Error in hanlding CellView Selection \(error) ")
                case.finished:
                    print("[+] Completed Processing CellView Selection")
                    break
            }
        } receiveValue: { [weak self] (TimeByMonthModel) in
            print("perfomring segue transfer to DCA Calc")
            let asset = Asset(searchResults: searchResult, TimeByMonthModel: TimeByMonthModel)
            self?.performSegue(withIdentifier: "showCalculator", sender: asset)
            print("success \( TimeByMonthModel.getMonthInfo())")
        }.store(in: &subscribers)
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any? ) {
        if segue.identifier == "showCalcualtor" {
            let destination = segue.destination as? CalculatorViewTableControllerViewController
            let asset = sender as? Asset
            destination?.asset = asset

        }
        if segue.identifier == "searchBtn2FinCalc" {
            let searchBtnDestination = segue.destination as? CalculatorViewTableControllerViewController
            searchBtnDestination?.searchTableSearchResults = searchResults
            searchBtnDestination?.searchTableSubscribers = subscribers
            searchBtnDestination?.searchTableSearchQuery = searchQuery
        }

    }
}




// [ Search Nav Bar  ]
extension SearchTableViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        print(searchController.searchBar.text ?? "DEBUG ME")
        guard let searchQuery = searchController.searchBar.text, !searchQuery.isEmpty else { return }
        print("User Input \(searchQuery)")
        self.searchQuery = searchQuery
    }

    func willPresentSearchController(_ searchController: UISearchController) {
        print("switiching modes")
        mode = .search
    }
}



/*
 // Class Instances //
 private let runAPI = APIWorker()
 private var searchResults: SearchResults? // return Models fetched from API
 var subscribers = Set<AnyCancellable>() // for fetch


 @Published private var mode: Mode = .onboarding // UI state (onboarding or searcahing)
 @Published private var searchQuery = String() // search query (nav bar)

 */
