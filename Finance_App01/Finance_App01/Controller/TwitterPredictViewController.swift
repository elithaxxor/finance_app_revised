//
//  TwitterPredictViewController.swift
//  Finance_App00
//
//  Created by a-robota on 5/28/22.
//

// api key 6HE1wYuuAOF9UQvxtI9aMlcfX
// secret key r0XWPP9uUT0FW9q1yQ9KrnkT8Kxgmr2oiL9MeC7c70HyUlgc39
// bearer token AAAAAAAAAAAAAAAAAAAAAHZudAEAAAAAQVQhVshdEIqL5ViZAPg8rVDYVgg%3DNvwO9U3BCfGgPs8kqYWBFcTR91qcbsbkzZX7qlfSpy2vzvKLzE




import UIKit
import SwiftyJSON
import CoreML
import SwifteriOS // Embedded Twitter Framework
import Combine

public enum predictionsError: Error {
    case badPrediction
    case badInput
}
public enum twitterAPIerr : Error {
    case encoding
    case badRequest
    case success
    case failure
} // error handling


@IBDesignable
class TwitterPredictViewController: ViewControllerLogger {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField! { didSet { fetchTweets(textField.text ?? "DEBUG ME") } }
    @IBOutlet weak var sentimentLabel: UILabel!

    @IBAction func fetchBtn(_sender: Any) {
        print("[!] From FetchBtn--> \(String(describing: textField.text))")

        fetchTweets(textField.text ?? "DEBUG ME")
    }

    let consumerKey: String = "6HE1wYuuAOF9UQvxtI9aMlcfX"
    let privKey: String = "r0XWPP9uUT0FW9q1yQ9KrnkT8Kxgmr2oiL9MeC7c70HyUlgc39"
    let twitterPath: String = "/Users/adelal-aali/Desktop/Finance_App01/twitter-sanders-apple3.csv"
    let classificationPath: String = "/Users/adelal-aali/Desktop/Finance_App01/TwitterClassifer.mlmodel"

   // @Published var subscribers = Set<AnyCancellable>() // for fetch
    var stock : String = ""

    // MARK: Varibles from SearchView Controller
    var searchViewTextView: String? {
        didSet {
            print("[!] searchview text field passed \(String(describing: searchViewTextView))")
            fetchBtn(_sender: self.searchViewTextView ?? "DEBUG ME")
        }
    }
    

    // TODO: Mark For Debugging !!
    //let twitterClassifer = TwitterClassifer()
    let twitterClassifer: TwitterClassifer = {
        do {
            let config = MLModelConfiguration()
            return try TwitterClassifer(configuration: config)
        } catch {
            print(" [!] Error in creating twitterClassfier obj \(error)")
            fatalError("Couldn't create Twitter Classifier")
        }
    }()

  //  let swifter = Swifter(consumerKey: consumerKey , consumerSecret: privKey )

    override func viewDidLoad() {
        super.viewDidLoad()
        createLogFile()
        let swifter = Swifter(consumerKey: consumerKey , consumerSecret: privKey )
        NSLog("[LOGGING--> <START> [Twitter-Classifcation VC]")
        //TODO: MAY HAVE TO DEBUG
        if textField.text != nil {
            fetchTweets(swifter.self)
        }
    }


    @IBAction func fetchTweets(_ sender: Any) {
        //   let TwitterClassifer = TwitterClassifer()

        let maxTweetCount = 100
        let swifter = Swifter(consumerKey: consumerKey , consumerSecret: privKey )

        // TODO: Debug this
        let textInput = textField.text
        let textInput00 = sender.self
        //  let prediction = try! TwitterClassifer.prediction(text: textInput ?? "DEBUG ME")

        print("[!] \(String(describing: textInput))")
        print("[!] \(textInput00)")


        swifter.searchTweet(using: textField.text ?? "DEBUG ME", lang: "en", count: maxTweetCount, tweetMode: .extended, success:
                                { (results, metaData) in

            var tweets = [TwitterClassiferInput]()
            print("[+] Tweets Metadata \(metaData)]")
            print("[+] API Fetch Results [\(results)]")
            print("[+] Tweets \(tweets)]")

            for i in 0..<maxTweetCount {
                if let tweet = results[i]["full_text"].string {
                    print("[+] [TWEETS] [\(i)] \(tweet)")
                    let tweetForClassification = TwitterClassiferInput(text: tweet)
                    tweets.append(tweetForClassification)
                }
            }
            do {
                let predictions = try self.twitterClassifer.predictions(inputs: tweets)

                var sentimentScore = 0
                for pred in predictions {
                    let sentiment = pred.label
                    print("[+] Sentiment \(sentiment) + \(pred)")
                    if sentiment == "Pos" { sentimentScore += 1
                    } else if sentiment == "Neg"{ sentimentScore -= 1}
                    self.updateUI(sentimentScore: sentimentScore)
                }

                print("[+] Predictions \(predictions)")
                print("[+] Predictions Label [SCORE] \(sentimentScore) \(predictions[0].label)")
                print("[+] What Twitter Thinks: [Classification-Score] \(sentimentScore)")

            } catch { print("[-] Error in Twitter Prediction \(error)") }

        }, failure: { error in
            print("[-] Error in [func]fetchingTweets api \(error)")

        })
    }

    func updateUI(sentimentScore: Int ) {

        if sentimentScore > 20 {
            self.sentimentLabel.text = "😍"
        } else if sentimentScore > 10 {
            self.sentimentLabel.text = "😀"
        } else if sentimentScore > 0 {
            self.sentimentLabel.text = "🙂"
        } else if sentimentScore == 0 {
            self.sentimentLabel.text = "😐"
        } else if sentimentScore > -10 {
            self.sentimentLabel.text = "😕"
        } else if sentimentScore > -20 {
            self.sentimentLabel.text = "😡"
        } else {
            self.sentimentLabel.text = "🤮"
        }
    }
}



// TODO: Move prediction model from ^ @IBACTION
//    private func makePrediction(with tweets: String, predictions: [TwitterClassiferInput]) throws -> predictionsError {
////        do {
//            var sentimentScore = 0
//            for pred in predictions {
//                let sentiment = pred.label
//                if sentiment == "Pos" { sentiment += 1
//                } else if sentiment == "Neg"{ sentimentScore -= 1}
//                updateUI(sentimentScore: sentimentScore)
//            }
//        } catch { throw predictionsError.badPrediction }
//    }



//
//public func searchTweet(using Query: String,
//                        geoCode: String? = nil,
//                        lang:String? = nil,
//                        locale:String? = nil,
//                        resultType:String? = nil,
//                        count:Int? = nil,
//                        until: String? = nil,
//                        sinceID: String? = nil,
//                        maxID: String? = nil,
//                        includeEntities: Bool,
//                        callBack: String? = nil,
//                        tweetMode: TweetMode = TweetMode.default,
//                        success: twitterAPIerr? = nil,
//                        failure: @escaping FailureHandler) throws -> predictionsError {
//    let path = "search/tweets.json"
//
//
//    //        var parameters = [String : Any](){
//    //            paramaters["q"] = query
//    //            paramaters["geocode"] ??= geoCode
//    //            paramaters["lang"] ??= lang
//    //            paramaters["locale"] ??= locale
//    //            paramaters["resultType"] ??= resultType
//    //            paramaters["sinceID"] ??= sinceID
//    //            paramaters["maxID"] ??= maxID
//    //            paramaters["includeEntities"] ??= includeEntities
//    //            paramaters["callBack"] ??= callBack
//    //            paramaters["tweetMode"] ??= tweetMode
//    //            paramaters["success"] ??= success
//    //            paramaters["failure"] ??= failure
//    //
//    //        }
//    }
