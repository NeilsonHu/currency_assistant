//
//  ForVisaTask.swift
//  CurrencyAssistantServer
//
//  Created by neilson on 2022-04-03.
//

import Foundation
import WebKit

class ForVisaTask {
    
    static public let shared = ForVisaTask()
        
    private let request = FVRequest()
    
    private let whiteList: [String] = [
        "Ottawa",
        "Toronto"
    ]
    
    public func startTask() {
        Xlog("startTask")
        tryTaskForOnce()
        _tryFixSchedule()
    }
    
    public func tryTaskForOnce() {
        Xlog("tryTaskForOnce")
        request.startDataRequest() { [weak self] result in
            self?._processResponse(result)
        }
    }
    
    public func getWebView() -> WKWebView {
        return request.invisibleWebView
    }
    
    private func _nextTask() {
        // next loop
        DispatchQueue.main.asyncAfter(deadline: .now() + 1800) { [weak self] in
            self?.tryTaskForOnce()

            self?._nextTask()
        }
    }
    
    private func _tryFixSchedule() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            let format = DateFormatter()
            format.dateStyle = .none
            format.timeStyle = .short
            let date = format.string(from: Date())
            if date.contains(":01 ") || date.contains(":31 ") {
                self?.tryTaskForOnce()
                self?._nextTask()
            } else {
                self?._tryFixSchedule()
            }
        }
    }
    
    private func _processResponse(_ rsp: [String: [[String: Any]]]) {
        guard !rsp.isEmpty else {
            Xlog("All cities are empty")
            return
        }
        var mostRecentDay: String = "2022-12-01"
        var cityName: String = ""
        rsp.forEach { (key: String, value: [[String: Any]]) in
            guard whiteList.contains(key) else {
                Xlog("\(key) is not in the whitelist")
                return
            }
            guard !value.isEmpty else {
                Xlog("\(key) is empty")
                return
            }
            value.forEach { dict in
                guard let time = dict["date"] as? String else {
                    Xlog("\(key) is empty")
                    return
                }
                Xlog("\(key):\(time)")
                if time <= mostRecentDay {
                    mostRecentDay = time
                    cityName = key
                }
            }
        }
        if !cityName.isEmpty {
            let content = "Find \(mostRecentDay) of \(cityName) !"
            PushManager().push(PushManager.defaultToken, content: content)
        }
    }
}
