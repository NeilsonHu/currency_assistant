//
//  FVRequestManager.swift
//  CurrencyAssistantServer
//
//  Created by neilson on 2022-03-31.
//

import Foundation
import WebKit

class FVRequest: NSObject {
        
    private let mainURL = "https://ais.usvisa-info.com/en-ca/niv/schedule/37859079/appointment"
    private let suffixURL = ".json?appointments%5Bexpedite%5D=false"
    
    public let invisibleWebView: WKWebView = WKWebView.init(frame: .zero)
    private let cityMap: [Int: String] = [
        89: "Calgary",
        90: "Halifax",
        91: "Montréal",
        92: "Ottawa",
        93: "Québec",
        94: "Toronto",
        95: "Vancouver"
    ]
    private var resultMap: [String: [[String: Any]]] = [String: [[String: Any]]]()
    
    private var firstLoad: Bool = true
    private var currentCity: Int = 89
    
    private var _completionBlock: (([String: [[String: Any]]])->(Void))?
    
    override init() {
        super.init()
        _setupWebView()
    }
    
    public func startDataRequest(_ completionBlock: (([String: [[String: Any]]])->(Void))?) {
        firstLoad = true
        _completionBlock = completionBlock
        if let url = URL(string: mainURL) {
            let request = URLRequest.init(url: url)
            invisibleWebView.load(request)
            
            let format = DateFormatter()
            format.dateStyle = .long
            format.timeStyle = .long
            let date = format.string(from: Date())
            Xlog(date)
        }
    }
}

extension FVRequest: WKNavigationDelegate {
    private func _setupWebView() {
//        invisibleWebView.isHidden = true
        invisibleWebView.navigationDelegate = self
    }
    
    private func _loadNextCity() {
        guard currentCity < 96 else {
            // all finished
            if let block = _completionBlock {
                let format = DateFormatter()
                format.dateStyle = .long
                format.timeStyle = .long
                let date = format.string(from: Date())
                Xlog("allFinished" + date)
                block(resultMap)
            }
            return
        }
        let cityURL = "\(mainURL)/days/\(currentCity)\(suffixURL)"
        if let url = URL(string: cityURL) {
            let request = URLRequest.init(url: url)
            invisibleWebView.load(request)
        }
    }
    
    private func _mockLoginOnFirstLoad() {
        guard let name = ConfigCenter.shared.config["visa-name"],
              let password = ConfigCenter.shared.config["visa-password"] else {
            return
        }
        Xlog("mockLoginOnFirstLoad")
        
        let js = "document.getElementById(\"user_email\").name"
        invisibleWebView.evaluateJavaScript(js) {[weak self] result, error in
            guard let s = self, let r = result as? String, r == "user[email]" else {
                if let url = URL(string: self?.mainURL ?? "") {
                    let request = URLRequest.init(url: url)
                    self?.invisibleWebView.load(request)
                }
                return
            }
            
            let js = "let d = document;"
            + "d.getElementById(\"user_email\").value = \"\(name)\";"
            + "d.getElementById(\"user_password\").value = \"\(password)\";"
            + "d.getElementById(\"policy_confirmed\").click();"
            + "document.getElementsByName(\"commit\")[0].click();"
            s.invisibleWebView.evaluateJavaScript(js)
        }
    }
    
    private func _processCityJson(_ completion: @escaping (()->(Void))) {
        let js = "document.body.outerHTML"
        invisibleWebView.evaluateJavaScript(js) {[weak self] result, error in
            guard let _ = self, let content = result as? String, !content.isEmpty else {
                completion()
                return
            }
            var tempStr = content.components(separatedBy: ">")[2]
            if let range = tempStr.range(of: "</pre") {
                tempStr.removeSubrange(range)
            }
            let jsonData = tempStr.data(using: .utf8)
            var resultAry: [[String: Any]]?
            if let data = jsonData, !data.isEmpty {
                do {
                    resultAry = try JSONSerialization.jsonObject(with: data, options: []) as? [[String:Any]]
                } catch {
                    completion()
                    return
                }
            }
            if let currentCity = self?.currentCity, let cityName = self?.cityMap[currentCity], !cityName.isEmpty, let ary = resultAry {
                self?.resultMap[cityName] = ary
            }
            completion()
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard let webViewURL = webView.url?.absoluteString else {
            return
        }
        if firstLoad {
            firstLoad = false
            _mockLoginOnFirstLoad()
        } else if webViewURL == mainURL {
            // load first city
            currentCity = 89
            _loadNextCity()
        } else if webViewURL.hasSuffix(suffixURL) {
            // on one city load finished
            _processCityJson {[weak self] in
                // load next city
                if let sSelf = self {
                    sSelf.currentCity += 1
                    sSelf._loadNextCity()
                }
            }
        }
    }
}

