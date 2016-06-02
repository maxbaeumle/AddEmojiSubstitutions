//
//  main.swift
//  AddEmojiSubstitutions
//
//  Created by Max Bäumle on 02.06.16.
//  Copyright © 2016 Max Bäumle. All rights reserved.
//

import Foundation

func addAllEmoji() {
    guard let url = NSURL(string: "https://github.com/github/gemoji/raw/master/db/emoji.json") else { return }
    guard let data = NSData(contentsOfURL: url) else { return }
    
    do {
        guard let allEmoji = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [[String : AnyObject]] else { return }
        
        var replacementItems = [String]()
        
        for emoji in allEmoji {
            guard let aliases = emoji["aliases"] as? [String] else { continue }
            guard let character = emoji["emoji"] as? String else { continue }
            
            replacementItems += aliases.map({"{on=1;replace=':\($0):';with='\(character)';}"})
        }
        
        let task = NSTask()
        task.launchPath = "/usr/bin/defaults"
        task.arguments = ["write", "-g", "NSUserDictionaryReplacementItems", "-array-add"] + replacementItems
        task.launch()
        task.waitUntilExit()
    } catch { }
}

addAllEmoji()
