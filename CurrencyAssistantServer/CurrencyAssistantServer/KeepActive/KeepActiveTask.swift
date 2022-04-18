//
//  KeepActiveTask.swift
//  CurrencyAssistantServer
//
//  Created by neilson on 2022-04-02.
//

import Foundation
import IOKit.pwr_mgt

///
/// to keep mac active
/// 
class KeepActiveTask {
    
    private var assertionID: IOPMAssertionID = 0
    
    public func onSwitchKeepActive(_ active: Bool) {
        if active == true {
            let success = IOPMAssertionCreateWithName(kIOPMAssertPreventUserIdleDisplaySleep as CFString,
                                                      IOPMAssertionLevel(kIOPMAssertionLevelOn),
                                                      "Active By Custom" as CFString,
                                                      &assertionID)
            if success == kIOReturnSuccess {
                Xlog("Keep Active...");
            } else {
                Xlog("Auto Sleep Enabled.");
            }
        } else {
            let success = IOPMAssertionRelease(assertionID);
            // The system will be able to sleep again.
            if success == kIOReturnSuccess {
                Xlog("Auto Sleep Enabled.")
            } else {
                Xlog("Keep Active...")
            }
        }
    }
}
