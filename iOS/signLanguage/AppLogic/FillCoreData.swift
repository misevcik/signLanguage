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
    var lection : Int
    var videoFront : String
}

struct Lection {
    var id : Int
    var title : String
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
        
        let lections = getLection()
        
        for i in 0...lections.count - 1 {
            
            let lection = lections[i]
            
            let dbLection = DBLesson(context: context!)
            dbLection.id = Int32(lection.id)
            dbLection.locked = (i != 0)
            dbLection.title = lection.title
            dbLection.image = lection.image
            
            fillLesson(lection.id, dbLection)
            self.context!.insert(dbLection)
            
            appDelegate!.saveContext()
        }
    }
    
    fileprivate func fillDictionary() {
        
        let dictionaries = getDictionary()
        
//        var addSentence = true
        for word in dictionaries {
            
            let dbWord = DBWord(context: context!)
            dbWord.word = word.name
            dbWord.lesson = Int32(word.lection)
            dbWord.favorite = false
            dbWord.videoFront = word.videoFront
            
//            if addSentence == true {
//                let dbSentence1 = DBSentence(context: context!)
//                let dbSentence2 = DBSentence(context: context!)
//
//                dbSentence1.sentence = "Ja idem behat"
//                dbSentence1.video = "sample_1"
//                dbSentence2.sentence = "Beham vela"
//                dbSentence2.video = "sample_2"
//
//                dbWord.addToRelSentence(dbSentence1)
//                dbWord.addToRelSentence(dbSentence2)
//
//                addSentence = false
//            }
            
            self.context!.insert(dbWord)
            appDelegate!.saveContext()
        }
    }
    
    func getLection() -> Array<Lection> {
        
        var lection = Array<Lection>()
        
        lection.append(Lection(id: 0, title: "Prvý kontakt I.", image: "predmety-top" ))
        lection.append(Lection(id: 1, title: "Prvý kontakt II.", image: "kitchen-top" ))
        lection.append(Lection(id: 2, title: "Prvý kontakt III.", image: "nemo-top" ))
        lection.append(Lection(id: 3, title: "Rodina I.", image: "nemo-top" ))
        lection.append(Lection(id: 4, title: "Rodina II.", image: "nemo-top" ))
        lection.append(Lection(id: 5, title: "Čísla I.", image: "nemo-top" ))
        lection.append(Lection(id: 6, title: "Čísla II.", image: "nemo-top" ))
        lection.append(Lection(id: 7, title: "Materiály a farby I.", image: "nemo-top" ))
        lection.append(Lection(id: 8, title: "Materiály a farby I.", image: "nemo-top" ))
        
        return lection
    }
    
    func getDictionary() -> Array<Word>{
        
        var dictionary = Array<Word>()
        
        //Lesson 1 - Prvy kontakt I
        dictionary.append(Word(name: "Ahoj", lection: 0, videoFront: "sample_1"))
        dictionary.append(Word(name: "Ja", lection: 0,  videoFront: "sample_2"))
        dictionary.append(Word(name: "Ty", lection: 0, videoFront: "sample_1"))
        dictionary.append(Word(name: "On/Ona", lection: 0, videoFront: "sample_2"))
        dictionary.append(Word(name: "Áno", lection: 0, videoFront: "sample_1"))
        dictionary.append(Word(name: "Nie", lection: 0, videoFront: "sample_2"))
        dictionary.append(Word(name: "Nepočujúci", lection: 0, videoFront: "sample_2"))
        dictionary.append(Word(name: "Počujúci", lection: 0, videoFront: "sample_2"))
        dictionary.append(Word(name: "Rozumieť", lection: 0, videoFront: "sample_2"))
        dictionary.append(Word(name: "Nerozumieť", lection: 0, videoFront: "sample_2"))
        dictionary.append(Word(name: "Nedoslýchaví", lection: 0, videoFront: "sample_2"))
        dictionary.append(Word(name: "Muž", lection: 0, videoFront: "sample_2"))
        dictionary.append(Word(name: "Žena", lection: 0, videoFront: "sample_2"))
        dictionary.append(Word(name: "Chlapec", lection: 0, videoFront: "sample_2"))
        dictionary.append(Word(name: "Dievča", lection: 0, videoFront: "sample_2"))
        
        //Lesson 2 - - Prvy kontakt II
        dictionary.append(Word(name: "Meno", lection: 1, videoFront: "sample_2"))
        dictionary.append(Word(name: "Moje", lection: 1, videoFront: "sample_2"))
        dictionary.append(Word(name: "Tvoje", lection: 1, videoFront: "sample_2"))
        dictionary.append(Word(name: "Jeho/Jej", lection: 1, videoFront: "sample_2"))
        dictionary.append(Word(name: "Kto", lection: 1, videoFront: "sample_2"))
        dictionary.append(Word(name: "My", lection: 1, videoFront: "sample_2"))
        dictionary.append(Word(name: "Vy", lection: 1, videoFront: "sample_2"))
        dictionary.append(Word(name: "Rovnako", lection: 1, videoFront: "sample_2"))
        dictionary.append(Word(name: "Čo", lection: 1, videoFront: "sample_2"))
        dictionary.append(Word(name: "Ako", lection: 1, videoFront: "sample_2"))
        dictionary.append(Word(name: "Alebo", lection: 1, videoFront: "sample_2"))
        dictionary.append(Word(name: "Dobre", lection: 1, videoFront: "sample_2"))
        dictionary.append(Word(name: "Zle", lection: 1, videoFront: "sample_2"))
        dictionary.append(Word(name: "Prosiť", lection: 1, videoFront: "sample_2"))
        dictionary.append(Word(name: "Prepáč", lection: 1, videoFront: "sample_2"))

        //Lesson 3 - Prvy kontakt III
        dictionary.append(Word(name: "Ráno", lection: 2, videoFront: "sample_2"))
        dictionary.append(Word(name: "Obed", lection: 2, videoFront: "sample_2"))
        dictionary.append(Word(name: "Poobede", lection: 2, videoFront: "sample_2"))
        dictionary.append(Word(name: "Večer", lection: 2,  videoFront: "sample_2"))
        dictionary.append(Word(name: "Noc", lection: 2, videoFront: "sample_2"))
        dictionary.append(Word(name: "Deň", lection: 2, videoFront: "sample_2"))
        dictionary.append(Word(name: "Osoba", lection: 2, videoFront: "sample_2"))
        dictionary.append(Word(name: "Kamarát/ka", lection: 2, videoFront: "sample_2"))
        dictionary.append(Word(name: "Kolega/Kolegyňa", lection: 2, videoFront: "sample_2"))
        dictionary.append(Word(name: "Ďakujem", lection: 2, videoFront: "sample_2"))
        dictionary.append(Word(name: "Pozdraviť", lection: 2, videoFront: "sample_2"))
        dictionary.append(Word(name: "Poznať", lection: 2, videoFront: "sample_2"))
        dictionary.append(Word(name: "Tešiť sa", lection: 2, videoFront: "sample_2"))
        dictionary.append(Word(name: "Stretnúť", lection: 2, videoFront: "sample_2"))
        dictionary.append(Word(name: "Opakovať", lection: 2, videoFront: "sample_2"))
        
        //Lesson 4 - Rodina I
        dictionary.append(Word(name: "Mama", lection: 3, videoFront: "sample_2"))
        dictionary.append(Word(name: "Otec", lection: 3,  videoFront: "sample_2"))
        dictionary.append(Word(name: "Dcéra", lection: 3,  videoFront: "sample_2"))
        dictionary.append(Word(name: "Syn", lection: 3,   videoFront: "sample_2"))
        dictionary.append(Word(name: "Rodina", lection: 3, videoFront: "sample_2"))
        dictionary.append(Word(name: "Brat", lection: 3, videoFront: "sample_2"))
        dictionary.append(Word(name: "Sestra", lection: 3, videoFront: "sample_2"))
        dictionary.append(Word(name: "Deti", lection: 3, videoFront: "sample_2"))
        dictionary.append(Word(name: "Mám", lection: 3, videoFront: "sample_2"))
        dictionary.append(Word(name: "Nemám", lection: 3, videoFront: "sample_2"))
        dictionary.append(Word(name: "Babka", lection: 3, videoFront: "sample_2"))
        dictionary.append(Word(name: "Dedko", lection: 3, videoFront: "sample_2"))
        dictionary.append(Word(name: "Dieťa", lection: 3, videoFront: "sample_2"))
        dictionary.append(Word(name: "Ženatý/Vydatá", lection: 3, videoFront: "sample_2"))
        dictionary.append(Word(name: "Slobodný/á", lection: 3, videoFront: "sample_2"))
        
        //Lesson 5 - Rodina II
        dictionary.append(Word(name: "Vnuk", lection: 4, videoFront: "sample_2"))
        dictionary.append(Word(name: "Vnučka", lection: 4, videoFront: "sample_2"))
        dictionary.append(Word(name: "Manžel/ka", lection: 4, videoFront: "sample_2"))
        dictionary.append(Word(name: "Rozvedený/á", lection: 4, videoFront: "sample_2"))
        dictionary.append(Word(name: "Manželia", lection: 4, videoFront: "sample_2"))
        dictionary.append(Word(name: "Frajer/ka", lection: 4, videoFront: "sample_2"))
        dictionary.append(Word(name: "Priateľ/ka", lection: 4, videoFront: "sample_2"))
        dictionary.append(Word(name: "Druh/Družka", lection: 4, videoFront: "sample_2"))
        dictionary.append(Word(name: "Teta", lection: 4, videoFront: "sample_2"))
        dictionary.append(Word(name: "Ujo", lection: 4, videoFront: "sample_2"))
        dictionary.append(Word(name: "Žiť", lection: 4, videoFront: "sample_2"))
        dictionary.append(Word(name: "Spolu", lection: 4, videoFront: "sample_2"))
        dictionary.append(Word(name: "Rozvod/Rozchod", lection: 4, videoFront: "sample_2"))
        dictionary.append(Word(name: "Rande", lection: 4, videoFront: "sample_2"))
        dictionary.append(Word(name: "Láska", lection: 4, videoFront: "sample_2"))
        
        //Lesson 6 - Čísla I.
        dictionary.append(Word(name: "0-5", lection: 5, videoFront: "sample_2"))
        dictionary.append(Word(name: "6-10", lection: 5, videoFront: "sample_2"))
        dictionary.append(Word(name: "11-15", lection: 5, videoFront: "sample_2"))
        dictionary.append(Word(name: "16-20", lection: 5, videoFront: "sample_2"))
        dictionary.append(Word(name: "21-25", lection: 5, videoFront: "sample_2"))
        dictionary.append(Word(name: "26-30", lection: 5, videoFront: "sample_2"))
        dictionary.append(Word(name: "31-35", lection: 5, videoFront: "sample_2"))
        dictionary.append(Word(name: "46-50", lection: 5, videoFront: "sample_2"))
        dictionary.append(Word(name: "51-55", lection: 5, videoFront: "sample_2"))
        dictionary.append(Word(name: "66-80", lection: 5, videoFront: "sample_2"))
        dictionary.append(Word(name: "81-85", lection: 5, videoFront: "sample_2"))
        dictionary.append(Word(name: "96-99", lection: 5, videoFront: "sample_2"))
        dictionary.append(Word(name: "Číslo", lection: 5, videoFront: "sample_2"))
        dictionary.append(Word(name: "+/-/*/:/=", lection: 5, videoFront: "sample_2"))
        dictionary.append(Word(name: "Rokov", lection: 5, videoFront: "sample_2"))
        
        //Lesson 7 - Čísla II.
        dictionary.append(Word(name: "100 - 500", lection: 6, videoFront: "sample_2"))
        dictionary.append(Word(name: "600 - 900", lection: 6, videoFront: "sample_2"))
        dictionary.append(Word(name: "1000 - 5000", lection: 6, videoFront: "sample_2"))
        dictionary.append(Word(name: "6000 - 10000", lection: 6, videoFront: "sample_2"))
        dictionary.append(Word(name: "200000 - 50000", lection: 6, videoFront: "sample_2"))
        dictionary.append(Word(name: "100 000", lection: 6, videoFront: "sample_2"))
        dictionary.append(Word(name: "250 000", lection: 6, videoFront: "sample_2"))
        dictionary.append(Word(name: "700 000", lection: 6, videoFront: "sample_2"))
        dictionary.append(Word(name: "1 000 000", lection: 6, videoFront: "sample_2"))
        dictionary.append(Word(name: "10 000 000", lection: 6, videoFront: "sample_2"))
        dictionary.append(Word(name: "Starý", lection: 6, videoFront: "sample_2"))
        dictionary.append(Word(name: "Mladý", lection: 6, videoFront: "sample_2"))
        dictionary.append(Word(name: "Koľko", lection: 6, videoFront: "sample_2"))
        dictionary.append(Word(name: "Správne", lection: 6, videoFront: "sample_2"))
        dictionary.append(Word(name: "Nesprávne", lection: 6, videoFront: "sample_2"))
        
        //Lesson 8 - Materiály a farby I.
        dictionary.append(Word(name: "Farba", lection: 7, videoFront: "sample_2"))
        dictionary.append(Word(name: "Biela", lection: 7, videoFront: "sample_2"))
        dictionary.append(Word(name: "Žltá", lection: 7, videoFront: "sample_2"))
        dictionary.append(Word(name: "Ružová", lection: 7, videoFront: "sample_2"))
        dictionary.append(Word(name: "Oranžová", lection: 7, videoFront: "sample_2"))
        dictionary.append(Word(name: "Červená", lection: 7, videoFront: "sample_2"))
        dictionary.append(Word(name: "Fialová", lection: 7, videoFront: "sample_2"))
        dictionary.append(Word(name: "Svetlá", lection: 7, videoFront: "sample_2"))
        dictionary.append(Word(name: "Tmavá", lection: 7, videoFront: "sample_2"))
        dictionary.append(Word(name: "Farebná", lection: 7, videoFront: "sample_2"))
        dictionary.append(Word(name: "Milovať", lection: 7, videoFront: "sample_2"))
        dictionary.append(Word(name: "Neznášať", lection: 7, videoFront: "sample_2"))
        dictionary.append(Word(name: "Pekná", lection: 7, videoFront: "sample_2"))
        dictionary.append(Word(name: "Škaredá", lection: 7, videoFront: "sample_2"))
        dictionary.append(Word(name: "Moderná", lection: 7, videoFront: "sample_2"))
        
        //Lesson 9 - Materiály a farby II.
        dictionary.append(Word(name: "Modrá", lection: 8, videoFront: "sample_2"))
        dictionary.append(Word(name: "Hnedá", lection: 8, videoFront: "sample_2"))
        dictionary.append(Word(name: "Zelená", lection: 8, videoFront: "sample_2"))
        dictionary.append(Word(name: "Sivá", lection: 8, videoFront: "sample_2"))
        dictionary.append(Word(name: "Čierna", lection: 8, videoFront: "sample_2"))
        dictionary.append(Word(name: "Materiál", lection: 8, videoFront: "sample_2"))
        dictionary.append(Word(name: "Papier", lection: 8, videoFront: "sample_2"))
        dictionary.append(Word(name: "Drevo", lection: 8, videoFront: "sample_2"))
        dictionary.append(Word(name: "Železo/Kov", lection: 8, videoFront: "sample_2"))
        dictionary.append(Word(name: "Sklo", lection: 8, videoFront: "sample_2"))
        dictionary.append(Word(name: "Keramika", lection: 8, videoFront: "sample_2"))
        dictionary.append(Word(name: "Látka", lection: 8, videoFront: "sample_2"))
        dictionary.append(Word(name: "Koža", lection: 8, videoFront: "sample_2"))
        dictionary.append(Word(name: "Tvrdá", lection: 8, videoFront: "sample_2"))
        dictionary.append(Word(name: "Mäkká", lection: 8, videoFront: "sample_2"))
    
        

        return dictionary;
    }
    
}
