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
    var lesson : Int
    var favorite : Bool
    var image : String
}

let sharedFillCoreData = FillCoreData()

class FillCoreData {
    
     private let appDelegate : AppDelegate?
     private let context : NSManagedObjectContext?
    
    init() {
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        context = appDelegate!.persistentContainer.viewContext
        

        if isCoreDataEmpty() {
            fillCoreData()
        }
    }
    
    func isCoreDataEmpty() -> Bool {
        
        var isEmpty = true
        
        do {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DBDictionary")
            let count = try context!.count(for:fetchRequest)
            isEmpty =  (count == 0)
        } catch let error as NSError {
            os_log("Unable to count core data. Error: %{public}@", log: Log.general, type: .error, error.localizedDescription)
            isEmpty  = true
        }
        
        return isEmpty
    }
    
    func fillCoreData() {
        
        fillDictionary()
        fillLessons()
    }
    
    fileprivate func fillLesson(_ lesson : Int, _ dbLesson : DBLesson) {
    
        do {
            let fetchRequest: NSFetchRequest<DBDictionary> = DBDictionary.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "lesson == %d", lesson)
            let records  = try context!.fetch(fetchRequest)
        
            for record in records {
                dbLesson.addToRelDictionary(record)
            }
        }
        catch {
            print ("fetch task failed", error)
        }
    }
    
    fileprivate func fillLessons() {
 
        let dbLesson0 = DBLesson(context: context!)
        dbLesson0.id = 0
        dbLesson0.lock = false
        dbLesson0.detail = "Nemo"
        dbLesson0.image = "nemo-top"
        fillLesson(0, dbLesson0)
        self.context!.insert(dbLesson0)
        
         appDelegate!.saveContext()
        
        let dbLesson1 = DBLesson(context: context!)
        dbLesson1.id = 1
        dbLesson1.lock = true
        dbLesson1.detail = "Predmety"
        fillLesson(1, dbLesson1)
        self.context!.insert(dbLesson1)
        
        appDelegate!.saveContext()
        
        let dbLesson2 = DBLesson(context: context!)
        dbLesson2.id = 2
        dbLesson2.lock = true
        dbLesson2.detail = "Kuchyna"
        fillLesson(2, dbLesson2)
        self.context!.insert(dbLesson2)
        
        appDelegate!.saveContext()
    }
    
    fileprivate func fillDictionary() {
        
        let dictionaries = getDictionary()
        
        var addSentence = true
        for dictionary in dictionaries {
            
            let dbDictionary = DBDictionary(context: context!)
            dbDictionary.dictionary = dictionary.name
            dbDictionary.lesson = Int32(dictionary.lesson)
            dbDictionary.level = Int32(dictionary.dificulty)
            dbDictionary.favorite = dictionary.favorite
            dbDictionary.image = dictionary.image
            
            if addSentence == true {
                let dbSentence1 = DBSentence(context: context!)
                let dbSentence2 = DBSentence(context: context!)
                
                dbSentence1.detail = "Ja idem behat"
                dbSentence2.detail = "Beham vela"
                
                dbDictionary.addToRelSentence(dbSentence1)
                dbDictionary.addToRelSentence(dbSentence2)
                
                addSentence = false
            }
            
            self.context!.insert(dbDictionary)
            appDelegate!.saveContext()
        }
    }
    
    func getDictionary() -> Array<DictionaryStruct>{
        
        var dictionary = Array<DictionaryStruct>()
        

        //Lesson 0
        dictionary.append(DictionaryStruct(name: "Wall-E", dificulty: 1, lesson: 0, favorite: false, image: "wall-e"))
        dictionary.append(DictionaryStruct(name: "Nemo", dificulty: 1, lesson: 0, favorite: false, image: "nemo"))
        dictionary.append(DictionaryStruct(name: "Ratatouille", dificulty: 1, lesson: 0, favorite: false, image: "ratatouille"))
        dictionary.append(DictionaryStruct(name: "Buzz", dificulty: 1, lesson: 0, favorite: false, image: "buzz"))
        dictionary.append(DictionaryStruct(name: "Monster", dificulty: 1, lesson: 0, favorite: false, image: "monsters"))
        dictionary.append(DictionaryStruct(name: "Brave", dificulty: 1, lesson: 0, favorite: false, image: "brave"))
        
        //Lesson 1
        dictionary.append(DictionaryStruct(name: "Stol", dificulty: 1, lesson: 1, favorite: false, image: ""))
        dictionary.append(DictionaryStruct(name: "Stolicka", dificulty: 1, lesson: 1, favorite: false, image: ""))
        dictionary.append(DictionaryStruct(name: "Obrus", dificulty: 2, lesson: 1, favorite: false, image: ""))
        
        //Lesson 3
        dictionary.append(DictionaryStruct(name: "Tanier", dificulty: 1, lesson: 2, favorite: false, image: ""))
        dictionary.append(DictionaryStruct(name: "Pohar", dificulty: 2, lesson: 2, favorite: false, image: ""))
        dictionary.append(DictionaryStruct(name: "Nozik", dificulty: 2, lesson: 2, favorite: false, image: ""))
        
        return dictionary;
    }
    
}
