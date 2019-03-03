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


struct Word {
    var name : String?
    var dificulty : Int
    var lesson : Int
    var favorite : Bool
    var image : String
    var videoFront : String
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
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DBWord")
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
            let fetchRequest: NSFetchRequest<DBWord> = DBWord.fetchRequest()
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
        dbLesson0.locked = false
        dbLesson0.title = "Nemo"
        dbLesson0.image = "nemo-top"
        fillLesson(0, dbLesson0)
        self.context!.insert(dbLesson0)
        
         appDelegate!.saveContext()
        
        let dbLesson1 = DBLesson(context: context!)
        dbLesson1.id = 1
        dbLesson1.locked = false
        dbLesson1.title = "Predmety"
        dbLesson1.image = "predmety-top"
        fillLesson(1, dbLesson1)
        self.context!.insert(dbLesson1)
        
        appDelegate!.saveContext()
        
        let dbLesson2 = DBLesson(context: context!)
        dbLesson2.id = 2
        dbLesson2.locked = true
        dbLesson2.title = "Kuchyna"
        dbLesson2.image = "kitchen-top"
        fillLesson(2, dbLesson2)
        self.context!.insert(dbLesson2)
        
        appDelegate!.saveContext()
        
        let dbLesson3 = DBLesson(context: context!)
        dbLesson3.id = 3
        dbLesson3.locked = true
        dbLesson3.title = "Technika"
        dbLesson3.image = "kitchen-top"
        fillLesson(3, dbLesson3)
        self.context!.insert(dbLesson3)
        
        appDelegate!.saveContext()
        
        let dbLesson4 = DBLesson(context: context!)
        dbLesson4.id = 4
        dbLesson4.locked = true
        dbLesson4.title = "Dom"
        dbLesson4.image = "kitchen-top"
        fillLesson(4, dbLesson4)
        self.context!.insert(dbLesson4)
        
        appDelegate!.saveContext()
        
        let dbLesson5 = DBLesson(context: context!)
        dbLesson5.id = 5
        dbLesson5.locked = true
        dbLesson5.title = "Zviera"
        dbLesson5.image = "kitchen-top"
        fillLesson(5, dbLesson5)
        self.context!.insert(dbLesson5)
        
        appDelegate!.saveContext()
        
        let dbLesson6 = DBLesson(context: context!)
        dbLesson6.id = 6
        dbLesson6.locked = true
        dbLesson6.title = "Meno"
        dbLesson6.image = "kitchen-top"
        fillLesson(6, dbLesson6)
        self.context!.insert(dbLesson6)
        
        appDelegate!.saveContext()
    }
    
    fileprivate func fillDictionary() {
        
        let dictionaries = getDictionary()
        
        var addSentence = true
        for word in dictionaries {
            
            let dbWord = DBWord(context: context!)
            dbWord.word = word.name
            dbWord.lesson = Int32(word.lesson)
            dbWord.level = Int32(word.dificulty)
            dbWord.favorite = word.favorite
            dbWord.image = word.image
            dbWord.videoFront = word.videoFront
            
            if addSentence == true {
                let dbSentence1 = DBSentence(context: context!)
                let dbSentence2 = DBSentence(context: context!)
                
                dbSentence1.sentence = "Ja idem behat"
                dbSentence1.video = "sample_1"
                dbSentence2.sentence = "Beham vela"
                dbSentence2.video = "sample_2"
                
                dbWord.addToRelSentence(dbSentence1)
                dbWord.addToRelSentence(dbSentence2)
                
                addSentence = false
            }
            
            self.context!.insert(dbWord)
            appDelegate!.saveContext()
        }
    }
    
    func getDictionary() -> Array<Word>{
        
        var dictionary = Array<Word>()
        

        //Lesson 0
        dictionary.append(Word(name: "Wall-E", dificulty: 1, lesson: 0, favorite: false, image: "wall-e", videoFront: "sample_1"))
        dictionary.append(Word(name: "Nemo", dificulty: 1, lesson: 0, favorite: false, image: "nemo",  videoFront: "sample_2"))
        dictionary.append(Word(name: "Ratatouille", dificulty: 1, lesson: 0, favorite: false, image: "ratatouille" , videoFront: "sample_1"))
        dictionary.append(Word(name: "Buzz", dificulty: 1, lesson: 0, favorite: false, image: "buzz", videoFront: "sample_2"))
        dictionary.append(Word(name: "Monster", dificulty: 1, lesson: 0, favorite: false, image: "monsters", videoFront: "sample_1"))
        dictionary.append(Word(name: "Brave", dificulty: 1, lesson: 0, favorite: false, image: "brave", videoFront: "sample_2"))
        
        //Lesson 1
        dictionary.append(Word(name: "Stol", dificulty: 1, lesson: 1, favorite: false, image: "", videoFront: ""))
        dictionary.append(Word(name: "Stolicka", dificulty: 1, lesson: 1, favorite: false, image: "", videoFront: ""))
        dictionary.append(Word(name: "Obrus", dificulty: 2, lesson: 1, favorite: false, image: "", videoFront: ""))
        
        //Lesson 2
        dictionary.append(Word(name: "Tanier", dificulty: 1, lesson: 2, favorite: false, image: "", videoFront: ""))
        dictionary.append(Word(name: "Pohar", dificulty: 2, lesson: 2, favorite: false, image: "", videoFront: ""))
        dictionary.append(Word(name: "Nozik", dificulty: 2, lesson: 2, favorite: false, image: "", videoFront: ""))
        
        //Lesson 3,4,5,6
        dictionary.append(Word(name: "Mobil", dificulty: 1, lesson: 3, favorite: false, image: "", videoFront: ""))
        dictionary.append(Word(name: "Okno", dificulty: 2, lesson: 4, favorite: false, image: "", videoFront: ""))
        dictionary.append(Word(name: "Lama", dificulty: 2, lesson: 5, favorite: false, image: "", videoFront: ""))
        dictionary.append(Word(name: "Dorotka", dificulty: 2, lesson: 6, favorite: false, image: "", videoFront: ""))
        
        return dictionary;
    }
    
}
