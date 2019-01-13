//
//  FillCoreData.swift
//  signLanguage
//
//  Created by Zdeno Bacik on 09/01/2019.
//  Copyright © 2019 Zdeno Bacik. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import os.log

/*
 Testing propose - fill core datas
*/


struct DictionaryStruct {
    var name : String?
    var dificulty : Int
    var category : Int
    var favorite : Bool
}

struct SentenceStruct {
    var data : String?
}

let sharedFillCoreData = FillCoreData()

class FillCoreData {
    
     private let appDelegate : AppDelegate?
     private let managedObjectContext : NSManagedObjectContext?
    
    init() {
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = appDelegate!.persistentContainer.viewContext
        

        if isCoreDataEmpty() {
            fillCoreData()
        }
    }
    
    func isCoreDataEmpty() -> Bool {
        
        var isEmpty = true
        
        do {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DBDictionary")
            let count = try managedObjectContext!.count(for:fetchRequest)
            isEmpty =  (count == 0)
        } catch let error as NSError {
            os_log("Unable to count core data. Error: %{public}@", log: Log.general, type: .error, error.localizedDescription)
            isEmpty  = true
        }
        
        return isEmpty
    }
    
    func fillCoreData() {
        
        //Fill sentence
        let sentences = getSentece()
        for sentence in sentences {
            
            let dbSentence = DBSentence(context: managedObjectContext!)
            dbSentence.data = sentence.data
            self.managedObjectContext!.insert(dbSentence)
        }
        appDelegate!.saveContext()
        
        //Fill Dictionary
        let dictionaries = getDictionary()
        for dictionary in dictionaries {
            
            let dbDictionary = DBDictionary(context: managedObjectContext!)
            dbDictionary.dictionary = dictionary.name
            dbDictionary.category = Int32(dictionary.category)
            dbDictionary.level = Int32(dictionary.dificulty)
            dbDictionary.favorite = dictionary.favorite
            
            //dbDictionary.addToSentence(<#T##value: DBSentence##DBSentence#>)
            
            self.managedObjectContext!.insert(dbDictionary)
        }
        appDelegate!.saveContext()
        
    }
    
    func getDictionary() -> Array<DictionaryStruct>{
        
        var dictionary = Array<DictionaryStruct>()
        
        //Category 0
        dictionary.append(DictionaryStruct(name: "Behat", dificulty: 1, category: 0, favorite: false))
        dictionary.append(DictionaryStruct(name: "Spievat", dificulty: 1, category: 0, favorite: false))
        dictionary.append(DictionaryStruct(name: "Pisat", dificulty: 1, category: 0, favorite: false))
        
        //Category 1
        dictionary.append(DictionaryStruct(name: "Stol", dificulty: 1, category: 1, favorite: false))
        dictionary.append(DictionaryStruct(name: "Stolicka", dificulty: 1, category: 1, favorite: false))
        dictionary.append(DictionaryStruct(name: "Obrus", dificulty: 2, category: 1, favorite: false))
        
        //Category 3
        dictionary.append(DictionaryStruct(name: "Tanier", dificulty: 1, category: 2, favorite: false))
        dictionary.append(DictionaryStruct(name: "Pohar", dificulty: 2, category: 2, favorite: false))
        dictionary.append(DictionaryStruct(name: "Nozik", dificulty: 2, category: 2, favorite: false))
        
        return dictionary;
    }
    
    func getSentece()-> Array<SentenceStruct>{
        
        var sentence = Array<SentenceStruct>();
        
        sentence.append(SentenceStruct(data: "Ja idem behat"))
        
        return sentence
    }
    
}
