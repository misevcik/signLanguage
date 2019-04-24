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

struct Sentence {
    var id : Int
    var sentence : String?
    var video : String?
}

struct Word {
    var name : String?
    var lection : Int
    var videoFront : String
    var inDictionary : Bool
    var sentence : [Int]?
}

struct Lection {
    var id : Int
    var title : String
    var image : String
}

class ID {
    private var id = 0
    
    init(_ initId : Int ) {
        id = initId
    }
    
    func increment() -> Int {
        id += 1
        return id
    }
    
    func reset() {
        id = 0
    }
}


class PreloadCoreData {
    
    private var backgroudnContext : NSManagedObjectContext? = nil
    
    init() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        backgroudnContext = appDelegate.persistentContainer.newBackgroundContext()
        appDelegate.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        
    }
    
    func preloadCoreData() {
        
        preloadSentences()
        preloadDictionary()
        preloadLections()
    }
    
    private func isCoreDataEmpty() -> Bool {
        
        var isEmpty = true
        
        do {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DBWord")
            let count = try backgroudnContext!.count(for:fetchRequest)
            isEmpty =  (count == 0)
        } catch let error as NSError {
            os_log("Unable to count core data. Error: %{public}@", log: Log.general, type: .error, error.localizedDescription)
            isEmpty  = true
        }
        
        return isEmpty
    }
    
    private func addWordsToLection(_ lessonId : Int, _ dbLesson : DBLesson) {
    
        do {
            let fetchRequest: NSFetchRequest<DBWord> = DBWord.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "lesson == %d", lessonId)
            let records  = try backgroudnContext!.fetch(fetchRequest)
        
            for record in records {
                dbLesson.addToRelDictionary(record)
            }
        }
        catch {
            print ("fetch task failed", error)
        }
    }
    
    private func addSentenceToWord(_ sentences : [Int], _ dbWord : DBWord) {
        
        do {
            let fetchRequest: NSFetchRequest<DBSentence> = DBSentence.fetchRequest()
            
            fetchRequest.predicate = NSPredicate(format: "id IN %@", sentences)
            let records  = try backgroudnContext!.fetch(fetchRequest)
            
            for record in records {
                dbWord.addToRelSentence(record)
            }
        }
        catch {
            print ("fetch task failed", error)
        }
    }
    
    private func preloadSentences() {
        
        let sentences = getSentences()
        
        for sentence in sentences {
            
            let dbSentence = DBSentence(context: backgroudnContext!)
            dbSentence.id = Int32(sentence.id)
            dbSentence.sentence = sentence.sentence
            dbSentence.video = sentence.video
            
            backgroudnContext!.insert(dbSentence)
        }
        
        saveContext()
    }
    
    private func preloadLections() {
        
        let lections = getLection()
        
        for lection in lections {
            
            let dbLection = DBLesson(context: backgroudnContext!)
            dbLection.id = Int32(lection.id)
            dbLection.locked = false
            dbLection.title = lection.title
            dbLection.image = lection.image
            
            addWordsToLection(lection.id, dbLection)
            backgroudnContext!.insert(dbLection)
            
        }
        
        saveContext()
    }
    
    private func preloadDictionary() {
        
        let dictionaries = getDictionary()
        
        for word in dictionaries {
            
            let dbWord = DBWord(context: backgroudnContext!)
            dbWord.inDictionary = word.inDictionary
            dbWord.word = word.name
            dbWord.lesson = Int32(word.lection)
            dbWord.favorite = false
            dbWord.videoFront = word.videoFront
            
            if word.sentence!.count != 0 {
                addSentenceToWord(word.sentence!, dbWord)
            }
            
            backgroudnContext!.insert(dbWord)
        }
        saveContext()
    }
    
    private func saveContext() {
        do {
            try backgroudnContext!.save()
        } catch {
            print("backgroudnContext.save() ", error)
        }
    }
    
    private func getLection() -> Array<Lection> {

        let id = ID(-1)
        
        var lection = Array<Lection>()
        
        lection.append(Lection(id: id.increment(), title: "Prvý kontakt I.", image: "predmety-top" ))
        lection.append(Lection(id: id.increment(), title: "Prvý kontakt II.", image: "kitchen-top" ))
        lection.append(Lection(id: id.increment(), title: "Prvý kontakt III.", image: "nemo-top" ))
        lection.append(Lection(id: id.increment(), title: "Rodina I.", image: "nemo-top" ))
        lection.append(Lection(id: id.increment(), title: "Rodina II.", image: "nemo-top" ))
        lection.append(Lection(id: id.increment(), title: "Čísla I.", image: "nemo-top" ))
        lection.append(Lection(id: id.increment(), title: "Čísla II.", image: "nemo-top" ))
        lection.append(Lection(id: id.increment(), title: "Farby I.", image: "nemo-top" ))
        lection.append(Lection(id: id.increment(), title: "Farby II.", image: "nemo-top" ))
        
        return lection
    }
    
    private func getSentences() -> Array<Sentence> {

        let id = ID(-1)
        var sentence = Array<Sentence>()
        
        //Lesson 1 - Prvy kontakt I
        //ID = 0
        sentence.append(Sentence(id: id.increment(), sentence: "On je nepočujúci.", video: "sample_2"))
        sentence.append(Sentence(id: id.increment(), sentence: "Som chlapec.", video: "sample_2"))
        sentence.append(Sentence(id: id.increment(), sentence: "Dievča je počujúca.", video: "sample_2"))
        sentence.append(Sentence(id: id.increment(), sentence: "Rozumieš?", video: "sample_2"))
        sentence.append(Sentence(id: id.increment(), sentence: "Ja som nepočujúca žena.", video: "sample_2"))
        sentence.append(Sentence(id: id.increment(), sentence: "Ja ti nerozumiem.", video: "sample_2"))
        
        //Lesson 2 - - Prvy kontakt II
        //ID = 6
        sentence.append(Sentence(id: id.increment(), sentence: "Moje meno ...", video: "sample_2"))
        sentence.append(Sentence(id: id.increment(), sentence: "Kto som?", video: "sample_2"))
        sentence.append(Sentence(id: id.increment(), sentence: "Ako sa máš?", video: "sample_2"))
        sentence.append(Sentence(id: id.increment(), sentence: "My sme počujúci.", video: "sample_2"))
        sentence.append(Sentence(id: id.increment(), sentence: "Žena je zlá.", video: "sample_2"))
        sentence.append(Sentence(id: id.increment(), sentence: "Prepáč, ja ti nerozumiem.", video: "sample_2"))
        
        //Lesson 3 - Prvy kontakt III
        //ID = 11
        sentence.append(Sentence(id: id.increment(), sentence: "Dobre ráno.", video: "sample_2"))
        sentence.append(Sentence(id: id.increment(), sentence: "Dobrý deň.", video: "sample_2"))
        sentence.append(Sentence(id: id.increment(), sentence: "Dobrý večer!", video: "sample_2"))
        sentence.append(Sentence(id: id.increment(), sentence: "Tvoja kamarátka je nepočujúca?", video: "sample_2"))
        sentence.append(Sentence(id: id.increment(), sentence: "Ona pozná nepočujúceho muža.", video: "sample_2"))
        sentence.append(Sentence(id: id.increment(), sentence: "Moja kolegyňa je nedoslýchavá.", video: "sample_2"))
        
        //Lesson 4 - Rodina I
        
        return sentence
        
    }
    
    private func getDictionary() -> Array<Word>{
        
        var dictionary = Array<Word>()
        
        //Lesson 1 - Prvy kontakt I
        dictionary.append(Word(name: "Ahoj", lection: 0, videoFront: "sample_1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Ja", lection: 0,  videoFront: "sample_2", inDictionary: true, sentence: [4, 5, 11]))
        dictionary.append(Word(name: "Ty", lection: 0, videoFront: "sample_1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "On/Ona", lection: 0, videoFront: "sample_2", inDictionary: true, sentence: [0, 16]))
        dictionary.append(Word(name: "Áno", lection: 0, videoFront: "sample_1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Nie", lection: 0, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Nepočujúci", lection: 0, videoFront: "sample_2", inDictionary: true, sentence: [0, 4, 15, 16]))
        dictionary.append(Word(name: "Počujúci", lection: 0, videoFront: "sample_2", inDictionary: true, sentence: [2, 9]))
        dictionary.append(Word(name: "Rozumieť", lection: 0, videoFront: "sample_2", inDictionary: true, sentence: [3]))
        dictionary.append(Word(name: "Nerozumieť", lection: 0, videoFront: "sample_2", inDictionary: true, sentence: [5, 11]))
        dictionary.append(Word(name: "Nedoslýchaví", lection: 0, videoFront: "sample_2", inDictionary: true, sentence: [17]))
        dictionary.append(Word(name: "Muž", lection: 0, videoFront: "sample_2", inDictionary: true, sentence: [16]))
        dictionary.append(Word(name: "Žena", lection: 0, videoFront: "sample_2", inDictionary: true, sentence: [4, 10]))
        dictionary.append(Word(name: "Chlapec", lection: 0, videoFront: "sample_2", inDictionary: true, sentence: [1]))
        dictionary.append(Word(name: "Dievča", lection: 0, videoFront: "sample_2", inDictionary: true, sentence: [2]))
        
        //Lesson 2 - - Prvy kontakt II
        dictionary.append(Word(name: "Meno", lection: 1, videoFront: "sample_2", inDictionary: true, sentence: [6]))
        dictionary.append(Word(name: "Moje", lection: 1, videoFront: "sample_2", inDictionary: true, sentence: [6, 17]))
        dictionary.append(Word(name: "Tvoje", lection: 1, videoFront: "sample_2", inDictionary: true, sentence: [15]))
        dictionary.append(Word(name: "Jeho/Jej", lection: 1, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Kto", lection: 1, videoFront: "sample_2", inDictionary: true, sentence: [7]))
        dictionary.append(Word(name: "My", lection: 1, videoFront: "sample_2", inDictionary: true, sentence: [9]))
        dictionary.append(Word(name: "Vy", lection: 1, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Rovnako", lection: 1, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Čo", lection: 1, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Ako", lection: 1, videoFront: "sample_2", inDictionary: true, sentence: [8]))
        dictionary.append(Word(name: "Alebo", lection: 1, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Dobre", lection: 1, videoFront: "sample_2", inDictionary: true, sentence: [ 12, 13, 14 ]))
        dictionary.append(Word(name: "Zle", lection: 1, videoFront: "sample_2", inDictionary: true, sentence: [10]))
        dictionary.append(Word(name: "Prosiť", lection: 1, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Prepáč", lection: 1, videoFront: "sample_2", inDictionary: true, sentence: [11]))
   

        //Lesson 3 - Prvy kontakt III
        dictionary.append(Word(name: "Ráno", lection: 2, videoFront: "sample_2", inDictionary: true, sentence: [12]))
        dictionary.append(Word(name: "Obed", lection: 2, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Poobede", lection: 2, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Večer", lection: 2,  videoFront: "sample_2", inDictionary: true, sentence: [14]))
        dictionary.append(Word(name: "Noc", lection: 2, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Deň", lection: 2, videoFront: "sample_2", inDictionary: true, sentence: [13]))
        dictionary.append(Word(name: "Osoba", lection: 2, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Kamarát/ka", lection: 2, videoFront: "sample_2", inDictionary: true, sentence: [15]))
        dictionary.append(Word(name: "Kolega/Kolegyňa", lection: 2, videoFront: "sample_2", inDictionary: true, sentence: [17]))
        dictionary.append(Word(name: "Ďakujem", lection: 2, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Pozdraviť", lection: 2, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Poznať", lection: 2, videoFront: "sample_2", inDictionary: true, sentence: [16]))
        dictionary.append(Word(name: "Tešiť sa", lection: 2, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Stretnúť", lection: 2, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Opakovať", lection: 2, videoFront: "sample_2", inDictionary: true, sentence: []))

        //Lesson 4 - Rodina I
        dictionary.append(Word(name: "Mama", lection: 3, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Otec", lection: 3,  videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Dcéra", lection: 3,  videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Syn", lection: 3,   videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Rodina", lection: 3, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Brat", lection: 3, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Sestra", lection: 3, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Deti", lection: 3, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Mám", lection: 3, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Nemám", lection: 3, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Babka", lection: 3, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Dedko", lection: 3, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Dieťa", lection: 3, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Ženatý/Vydatá", lection: 3, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Slobodný/á", lection: 3, videoFront: "sample_2", inDictionary: true, sentence: []))
        
        //Lesson 5 - Rodina II
        dictionary.append(Word(name: "Vnuk", lection: 4, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Vnučka", lection: 4, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Manžel/ka", lection: 4, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Rozvedený/á", lection: 4, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Manželia", lection: 4, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Frajer/ka", lection: 4, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Priateľ/ka", lection: 4, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Druh/Družka", lection: 4, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Teta", lection: 4, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Ujo", lection: 4, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Žiť", lection: 4, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Spolu", lection: 4, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Rozvod/Rozchod", lection: 4, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Rande", lection: 4, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Láska", lection: 4, videoFront: "sample_2", inDictionary: true, sentence: []))

        //Lesson 6 - Čísla I.
        dictionary.append(Word(name: "0-5", lection: 5, videoFront: "sample_2", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "6-10", lection: 5, videoFront: "sample_2", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "11-15", lection: 5, videoFront: "sample_2", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "16-20", lection: 5, videoFront: "sample_2", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "21-25", lection: 5, videoFront: "sample_2", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "26-30", lection: 5, videoFront: "sample_2", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "31-35", lection: 5, videoFront: "sample_2", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "46-50", lection: 5, videoFront: "sample_2", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "51-55", lection: 5, videoFront: "sample_2", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "66-80", lection: 5, videoFront: "sample_2", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "81-85", lection: 5, videoFront: "sample_2", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "96-99", lection: 5, videoFront: "sample_2", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "Číslo", lection: 5, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "+/-/*/:/=", lection: 5, videoFront: "sample_2", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "Rokov", lection: 5, videoFront: "sample_2", inDictionary: true, sentence: []))

        //Lesson 7 - Čísla II.
        dictionary.append(Word(name: "100 - 500", lection: 6, videoFront: "sample_2", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "600 - 900", lection: 6, videoFront: "sample_2", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "1000 - 5000", lection: 6, videoFront: "sample_2", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "6000 - 10000", lection: 6, videoFront: "sample_2", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "200000 - 50000", lection: 6, videoFront: "sample_2", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "100 000", lection: 6, videoFront: "sample_2", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "250 000", lection: 6, videoFront: "sample_2", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "700 000", lection: 6, videoFront: "sample_2", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "1 000 000", lection: 6, videoFront: "sample_2", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "10 000 000", lection: 6, videoFront: "sample_2", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "Starý", lection: 6, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Mladý", lection: 6, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Koľko", lection: 6, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Správne", lection: 6, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Nesprávne", lection: 6, videoFront: "sample_2", inDictionary: true, sentence: []))

        //Lesson 8 - Materiály a farby I.
        dictionary.append(Word(name: "Farba", lection: 7, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Biela", lection: 7, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Žltá", lection: 7, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Ružová", lection: 7, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Oranžová", lection: 7, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Červená", lection: 7, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Fialová", lection: 7, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Svetlá", lection: 7, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Tmavá", lection: 7, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Farebná", lection: 7, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Milovať", lection: 7, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Neznášať", lection: 7, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Pekná", lection: 7, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Škaredá", lection: 7, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Moderná", lection: 7, videoFront: "sample_2", inDictionary: true, sentence: []))
        
        //Lesson 9 - Materiály a farby II.
        dictionary.append(Word(name: "Modrá", lection: 8, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Hnedá", lection: 8, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Zelená", lection: 8, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Sivá", lection: 8, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Čierna", lection: 8, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Materiál", lection: 8, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Papier", lection: 8, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Drevo", lection: 8, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Železo/Kov", lection: 8, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Sklo", lection: 8, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Keramika", lection: 8, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Látka", lection: 8, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Koža", lection: 8, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Tvrdá", lection: 8, videoFront: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Mäkká", lection: 8, videoFront: "sample_2", inDictionary: true, sentence: []))
    
    
        return dictionary;
    }
    
    
}
