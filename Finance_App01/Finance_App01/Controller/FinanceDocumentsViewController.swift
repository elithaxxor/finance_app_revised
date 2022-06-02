//
//  NewsTableViewController.swift
//  Financial_Calc_II
//
//  Created by a-robota on 4/27/22.
//

import UIKit



// pnmVOrapMEyGBt2uOl2GBLKvM40CSjsD

@IBDesignable
class FinanceDocumentsViewController: TableViewControllerLogger, ObservableObject {

    @Published var docs: docsResults
    @Published var financialDocsPublisher: FinanceDocs? = nil
    private var docsResults: [docsResults] = []

    init(docs: docsResults, financialDocsPublisher: FinanceDocs, docsResults: [docsResults]  ) {
        self.docs = docs
        self.financialDocsPublisher = financialDocsPublisher
        self.docsResults = docsResults
        super.init(nibName: nil, bundle: nil)
        guard let parsed_data = try? getDocResults() else { return }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        createLogFile()
        NSLog("[LOGGING--> <START> [NEWS-TABLE VC]")
        try? getData()
        self.clearsSelectionOnViewWillAppear = false
        NSLog("[LOGGING--> <END> [NEWS-TABLE VC]")
    }


    private func getData() throws {
        guard let data = try? getDocResults() else { throw docFetchError.getDataError }
        guard let stringifyData = String(data: data, encoding: .utf8) else { throw docFetchError.stringifyDataError}
        guard let retrievedData = data as? [String: Any] else { throw docFetchError.getDataError }

        self.financialDocsPublisher = try? JSONDecoder().decode(FinanceDocs.self, from: data)
        let retrievedDataPubliser = retrievedData.publisher

        print("[+] Fetched Financial [Data] \(String(describing: data))")
        print("[+] Fetched Financial [Retrieved Data] \(String(describing: retrievedData))")
        print("[+] Fetched Financial [Retrieved Publisher] \(String(describing: retrievedDataPubliser))")
        print("[+] Stringified Fetched Financial [Stringified Data] \(String(describing: stringifyData))")
    }

    private func getDocResults() throws -> Data? {
        let docResult = docsResults
        let modelData = FinanceDocs(request_id: "1", status: "OK", allDocsResults: docResult)
        guard let jsonData = try? JSONEncoder().encode(modelData) else { throw docFetchError.jsonFetchError }

        print("[+] Model Data \(modelData)")
        return jsonData
    }

    private func encodeData () throws {
        print("[!] Encoding Data")
        guard let data = try? getDocResults() else { throw docFetchError.getDataError }
        guard let jsonData = try? JSONSerialization.data(withJSONObject: data, options: []) else { throw docFetchError.jsonFetchError }
    }



    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return docsResults.count

    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_id", for: indexPath) as! DocsTableViewCell
        let docResult = docsResults[indexPath.item]
        let index = indexPath.item
        cell.configure(with: docs)
        return cell
    }


    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

}


// MARK: Doc Fetching Catch Errors
public enum docFetchError : Error {
    case jsonFetchError
    case getDataError
    case stringifyDataError
}
extension docFetchError {
    public var docFetchErrorDescription : String {
        switch self {
            case .jsonFetchError : return "Error in Fetching Finance Docs .JSON data"
            case .getDataError : return "Error in Getting Data From Models"
            case .stringifyDataError : return "Error in stringifing model JSON"
        }
    }
}
