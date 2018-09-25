//
//  IntentHandler.swift
//  Menu Intent
//
//  Created by Cal Stephens on 9/25/18.
//  Copyright © 2018 Cal Stephens. All rights reserved.
//

import Intents

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        if intent is MenuIntent {
            return MenuIntentHandler()
        } else {
            fatalError()
        }
    }
    
}
