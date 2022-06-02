//
//  HomeTableViewController.swift
//  Finance_App01
//
//  Created by a-robota on 5/31/22.
//

// TODO : 1. FETCH FINANCE DOCS 2. SET UP NEWSPAPER API. 3. LIVE NEWS FEED UNDER SEARCHRESULTS 4. PDF SCANNER 5. ROTATE VIEWS FOR CALC

import UIKit
import Combine


// Impliments User-timer
class AppTimer  {

    @Published var counter: Int = 0
    var subscribers = Set<AnyCancellable>()

    init() { setupTimer() }

    func setupTimer() {
        Timer
            .publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] count in
                guard let self = self else { return }
                self.counter+=1
               // print("[!][COUNTER] \(count)")
            }
            .store(in: &subscribers)
    }
}

enum homePublishError : Error {
    case dataError
    case smallInput
}

extension homePublishError {
    public var errorDescription: String {
        switch self {
            case .dataError : return "Error in home data publisher"
            case .smallInput : return "input is too small to validate (input < 2) "
        }
    }
}
//let subscription = publishedTextVal
//        .sink { completion in
//            switch completion {
//                case .finished:
//                    print("[-] Subscription Finished")
//                case .failure(let error as homePublishError):
//                    print("[-] Subscription Failure \(homePublishError.dataError)")
//                case .failure (let error) :
//                    print("[-] Subscription Failure \(error.localizedDescription)")
//            }
//        receiveValue: { message in
//            print("[+] Home Subscription Recieved Value \(message)")
//        }
//        }
//func setupTextSubscriptions() {
//    print("[!] Setting Up Subscriptions")
//    NotificationCenter
//        .default
//        .publisher(for: UITextField.textDidChangeNotification, object: homeTextField)
//        .compactMap({ ($0.object as? UITextField)?.text })
//        .tryMap(validateHomePublisher(publisherArray: homeTextField?))
//        .map { "User Entered \($0)" }
//        .assign(to: \.text, on: UITextField)
//        .store(in: &subscriptions)
//}


func validateHomePublisher(publisherArray: String?) throws -> String {
    print("[!] Validating Home Publisher")
    guard let publisherArray = publisherArray else { throw homePublishError.dataError }
    if publisherArray.count >= 2 { return publisherArray
    } else if publisherArray.count < 2 { throw homePublishError.smallInput
    } else { throw homePublishError.dataError
    }
}

@IBDesignable
class HomeViewController: ViewControllerLogger {

    var timer = AppTimer()

    var homeTextValue: String?

    private let banner = """
          __,
         (           o  /) _/_
          `.  , , , ,  //  /
        (___)(_(_/_(_ //_ (__
                     /)
                    (/

        version 0.0.1 Beta
        copyleft, [all wrongs reserved] @elit_haxxor


        """

    override func viewDidLoad() {
        super.viewDidLoad()
        print(banner)
        timer.setupTimer()
        createLogFile()
        NSLog("[LOGGING--> <START> [HOME VC]")
    }

    var subscriptions = Set<AnyCancellable>() // for fetch
    var cancellables = Set<AnyCancellable>() // for fetch

    let publishedTextVal: Publishers.Sequence<[String?], Never> = [].publisher

    @Published var homeTextValuePublished: String = ""
    @Published var textIsValid: Bool = false

    func addTextFieldSubscriber(){
        $homeTextValuePublished
            .map { (homeTextField) -> Bool in
                if homeTextField.count > 2 {
                    return true
                }
                return false
            }
            .sink(receiveValue: { [self] (isValid) in
                self.homeTextValue = homeTextValuePublished
                print("[!] HomeViewController publishedvalue \(homeTextValuePublished)")
            })
            .store(in: &subscriptions)
    }


    @IBAction func homeDocsBtn(_ sender: UIButton) {
        print("[!] Home to Docs Button pressed")
        performSegue(withIdentifier: "homeDocsBtn", sender: self)
    }


    // MARK: HomeVC Actions
    @IBAction func homeSearchBtn(_ sender: UIButton) {
        print("[!] Home Search BTN")
        performSegue(withIdentifier: "homeBtn2search", sender: self)
    }


    @IBAction func homeCalcBtn(_ sender: UIButton) { print("[!] Home Calc Btn Pressed ")
        performSegue(withIdentifier: "home2calc", sender: self)
    }

    @IBAction func homeNewsBtn(_ sender: UIButton) {
        print("[!] Home News Btn Pressed ")
        performSegue(withIdentifier: "home2news", sender: self)
    }
    @IBAction func homeTwitterBtn(_ sender: UIButton) {
        print("[!] Home Twitter Btn Pressed ")
        performSegue(withIdentifier: "home2twitter", sender: self)
    }
    @IBAction func homeTextField(_ sender: UITextField) {
        print("[!] User is searching for stock symbol")
        sender.text = homeTextValue
        //homeTextField.text = homeTextValue
        print("[!] \(String(describing: homeTextValue))")
        print("[!] Performing Segue upon finish. ")
        performSegue(withIdentifier: "text2search", sender: self)
    }

    // MARK: - HomeVC Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "home2twitter" {
            let home2twitter = segue.destination as? TwitterPredictViewController
            home2twitter?.textField?.text = homeTextValue
        }


        if segue.identifier == "home2search" { let home2search = segue.destination as? SearchTableViewController }
        if segue.identifier == "home2news" { let home2news = segue.destination as? NewsTableViewController }

        if segue.identifier == "home2calc" {
            let home2calc = segue.destination as? CalculatorIII }

        if segue.identifier == "text2search" {
            let text2search = segue.destination as? SearchTableViewController
            text2search?.homeTextValueVC = homeTextValue
        }
        if segue.identifier == "homeBtn2search" {
            let homeBtn2search = segue.destination as? SearchTableViewController
            homeBtn2search?.homeTextValueVC = homeTextValue
            homeBtn2search?.searchInput?.text = homeTextValue
        }
        if segue.identifier == "homeDocsBtn" { let homeDocsBtn = segue.destination as? FinanceDocumentsViewController }

    }
}

