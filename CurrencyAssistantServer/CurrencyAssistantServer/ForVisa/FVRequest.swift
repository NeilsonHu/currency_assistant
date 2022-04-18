//
//  FVRequestManager.swift
//  CurrencyAssistantServer
//
//  Created by neilson on 2022-03-31.
//

import Foundation
import WebKit

///
/// for request all cities' time schedule
///
class FVRequest: NSObject {
        
    // webview instance for all requests
    public let embedWebView: WKWebView = WKWebView.init(frame: .zero)
    
    private var resultMap: [String: [[String: Any]]] = [:]
    private var firstLoad: Bool = true // 用于标记加载顺序
    private var currentCity: Int = 89 // 默认从第一个城市开始
    private var _completionBlock: (([String: [[String: Any]]])->(Void))?
    private var _whiteList: [String]?
    
    private let mainURL = "https://ais.usvisa-info.com/en-ca/niv/schedule/37859079/appointment"
    private let suffixURL = ".json?appointments%5Bexpedite%5D=false"
    private let allCitiesMap: [Int: String] = [ // key from 89 to 95
        89: "Calgary",
        90: "Halifax",
        91: "Montréal",
        92: "Ottawa",
        93: "Québec",
        94: "Toronto",
        95: "Vancouver"
    ]

    override init() {
        super.init()
        _setupWebView()
    }
    
    public func startDataRequest(whiteList: [String]?,
                                 _ completionBlock: (([String: [[String: Any]]])->(Void))?) {
        firstLoad = true
        _whiteList = whiteList
        _completionBlock = completionBlock
        if let url = URL(string: mainURL) {
            let request = URLRequest.init(url: url)
            embedWebView.load(request)
            Xlog(_getCurrentTime())
        }
    }
}

///
/// private methods
///
extension FVRequest {
    
    private func _getCurrentTime() -> String {
        let format = DateFormatter()
        format.dateStyle = .long
        format.timeStyle = .long
        return format.string(from: Date())
    }
    
    private func _setupWebView() {
//        invisibleWebView.isHidden = true
        embedWebView.navigationDelegate = self
    }
    
    private func _loadNextCity() {
        guard currentCity < 96 else {
            // all finished
            if let block = _completionBlock {
                Xlog("allFinished" + _getCurrentTime())
                block(resultMap)
            }
            return
        }
        
        if let whiteList = _whiteList, !whiteList.isEmpty,
           let cityName = allCitiesMap[currentCity], !cityName.isEmpty,
           !whiteList.contains(cityName) {
            currentCity += 1
            _loadNextCity()
            return
        }
        
        let cityURL = "\(mainURL)/days/\(currentCity)\(suffixURL)"
        if let url = URL(string: cityURL) {
            let request = URLRequest.init(url: url)
            embedWebView.load(request)
        }
    }
    
    private func _mockLoginOnFirstLoad() {
        guard let name = ConfigCenter.shared.config["visa-name"],
              let password = ConfigCenter.shared.config["visa-password"],
              !name.isEmpty, !password.isEmpty else {
            return
        }
        Xlog("mockLoginOnFirstLoad")
        
        let js = "document.getElementById(\"user_email\").name"
        embedWebView.evaluateJavaScript(js) {[weak self] result, error in
            guard let s = self, let r = result as? String, r == "user[email]" else {
                if let url = URL(string: self?.mainURL ?? "") {
                    let request = URLRequest.init(url: url)
                    self?.embedWebView.load(request)
                }
                return
            }
            
            let js = "let d = document;"
            + "d.getElementById(\"user_email\").value = \"\(name)\";"
            + "d.getElementById(\"user_password\").value = \"\(password)\";"
            + "d.getElementById(\"policy_confirmed\").click();"
            + "document.getElementsByName(\"commit\")[0].click();"
            s.embedWebView.evaluateJavaScript(js)
        }
    }
    
    private func _processCityJson(_ completion: @escaping (()->(Void))) {
        let js = "document.body.outerHTML"
        embedWebView.evaluateJavaScript(js) {[weak self] result, error in
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
            if let currentCity = self?.currentCity, let cityName = self?.allCitiesMap[currentCity], !cityName.isEmpty, let ary = resultAry {
                self?.resultMap[cityName] = ary
            }
            completion()
        }
    }
}

///
/// WKNavigationDelegate
///
extension FVRequest: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard let webViewURL = webView.url?.absoluteString else {
            return
        }
        Xlog(webViewURL)
        if firstLoad {
            firstLoad = false
            _mockLoginOnFirstLoad()
        } else if webViewURL == mainURL {
            // load first city
            currentCity = 89 // 默认从第一个城市开始
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

