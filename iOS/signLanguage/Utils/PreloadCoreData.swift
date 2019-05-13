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
    var videoSide : String
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
    
    init(coreDataStack : CoreDataStack) {
        
        coreDataStack.storeContainer.performBackgroundTask { context in
            
            self.preloadSentences(context: context)
            self.preloadDictionary(context: context)
            self.preloadLections(context: context)
        }
    }

    private func preloadSentences(context : NSManagedObjectContext) {
        
        let sentences = getSentences()
        
        for sentence in sentences {
            
            let dbSentence = DBSentence(context: context)
            dbSentence.id = Int32(sentence.id)
            dbSentence.sentence = sentence.sentence
            dbSentence.video = sentence.video
            
            context.insert(dbSentence)
        }
        
        self.saveContext(context: context)
    }
    
    private func addSentenceToWord(sentences : [Int], dbWord : DBWord, context : NSManagedObjectContext) {
        
        do {
            let fetchRequest: NSFetchRequest<DBSentence> = DBSentence.fetchRequest()
            
            fetchRequest.predicate = NSPredicate(format: "id IN %@", sentences)
            let records  = try context.fetch(fetchRequest)
            
            for record in records {
                dbWord.addToRelSentence(record)
            }
        }
        catch {
            print ("addSentenceToWord - fetch task failed", error)
        }
    }
    
    
    private func preloadDictionary(context : NSManagedObjectContext) {
        
        let dictionaries = getDictionary()
        
        for word in dictionaries {
            
            let dbWord = DBWord(context: context)
            dbWord.inDictionary = word.inDictionary
            dbWord.word = word.name
            dbWord.lesson = Int32(word.lection)
            dbWord.favorite = false
            dbWord.videoFront = word.videoFront
            dbWord.videoSide = word.videoSide
            
            if word.sentence!.count != 0 {
                addSentenceToWord(sentences: word.sentence!, dbWord: dbWord, context: context)
            }
            
            context.insert(dbWord)
        }
        self.saveContext(context: context)
    }
    
    private func addWordsToLection(lessonId : Int, dbLesson : DBLesson, context : NSManagedObjectContext) {
        
        do {
            let fetchRequest: NSFetchRequest<DBWord> = DBWord.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "lesson == %d", lessonId)
            let records  = try context.fetch(fetchRequest)
            
            for record in records {
                dbLesson.addToRelDictionary(record)
            }
        }
        catch {
            print ("addWordsToLection - fetch task failed", error)
        }
    }
    
    private func preloadLections(context : NSManagedObjectContext) {
        
        let lections = getLection()
        
        for lection in lections {
            
            let dbLection = DBLesson(context: context)
            dbLection.id = Int32(lection.id)
            dbLection.locked = false
            dbLection.title = lection.title
            dbLection.image = lection.image
            
            addWordsToLection(lessonId: lection.id, dbLesson: dbLection, context: context)
            context.insert(dbLection)
            
        }
        
        self.saveContext(context: context)
    }
    
    
    private func saveContext(context : NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print("backgroudnContext.save() ", error)
        }
    }
    
    private func getLection() -> Array<Lection> {

        let id = ID(-1)
        
        var lection = Array<Lection>()
        
        lection.append(Lection(id: id.increment(), title: "Prvý kontakt I.", image: "firstContact_I" ))
        lection.append(Lection(id: id.increment(), title: "Prvý kontakt II.", image: "firstContact_II" ))
        lection.append(Lection(id: id.increment(), title: "Prvý kontakt III.", image: "firstContact_III" ))
        lection.append(Lection(id: id.increment(), title: "Rodina I.", image: "nemo-top" ))
        lection.append(Lection(id: id.increment(), title: "Rodina II.", image: "nemo-top" ))
        lection.append(Lection(id: id.increment(), title: "Čísla I.", image: "nemo-top" ))
        lection.append(Lection(id: id.increment(), title: "Čísla II.", image: "nemo-top" ))
        lection.append(Lection(id: id.increment(), title: "Farby I.", image: "nemo-top" ))
        lection.append(Lection(id: id.increment(), title: "Farby II.", image: "nemo-top" ))
        lection.append(Lection(id: id.increment(), title: "Bývanie I.", image: "nemo-top" ))
        lection.append(Lection(id: id.increment(), title: "Bývanie II.", image: "nemo-top" ))
        lection.append(Lection(id: id.increment(), title: "Inštitúcie I.", image: "nemo-top" ))
        lection.append(Lection(id: id.increment(), title: "Inštitúcie II.", image: "nemo-top" ))
        lection.append(Lection(id: id.increment(), title: "Mestá I.", image: "nemo-top" ))
        lection.append(Lection(id: id.increment(), title: "Mestá II.", image: "nemo-top" ))
        lection.append(Lection(id: id.increment(), title: "Doprava I.", image: "nemo-top" ))
        lection.append(Lection(id: id.increment(), title: "Doprava II.", image: "nemo-top" ))
        lection.append(Lection(id: id.increment(), title: "Čas I.", image: "nemo-top" ))
        lection.append(Lection(id: id.increment(), title: "Čas II.", image: "nemo-top" ))
        lection.append(Lection(id: id.increment(), title: "Kalendár I.", image: "nemo-top" ))
        lection.append(Lection(id: id.increment(), title: "Kalendár II.", image: "nemo-top" ))
        lection.append(Lection(id: id.increment(), title: "Zvierata I.", image: "nemo-top" ))
        lection.append(Lection(id: id.increment(), title: "Zvierata II.", image: "nemo-top" ))
        lection.append(Lection(id: id.increment(), title: "Zvierata III.", image: "nemo-top" ))
        lection.append(Lection(id: id.increment(), title: "Ovocie", image: "nemo-top" ))
        lection.append(Lection(id: id.increment(), title: "Zelenina", image: "nemo-top" ))
        lection.append(Lection(id: id.increment(), title: "Ročné obdobie I.", image: "nemo-top" ))
        lection.append(Lection(id: id.increment(), title: "Ročné obdobie II.", image: "nemo-top" ))
        
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
        //ID = 17
        sentence.append(Sentence(id: id.increment(), sentence: "Mám počujúcu sestru.", video: "sample_2"))
        sentence.append(Sentence(id: id.increment(), sentence: "Poznám jeho rodičov.", video: "sample_2"))
        sentence.append(Sentence(id: id.increment(), sentence: "Môj brat je ženatý.", video: "sample_2"))
        sentence.append(Sentence(id: id.increment(), sentence: "On má nepočujúcu dcéru.", video: "sample_2"))
        sentence.append(Sentence(id: id.increment(), sentence: "Nemám súrodencov.", video: "sample_2"))
        sentence.append(Sentence(id: id.increment(), sentence: "Moje dieťa v noci spí.", video: "sample_2"))
        
        //Lesson 5 - Rodina I
        //ID = 23
        sentence.append(Sentence(id: id.increment(), sentence: "Mám priateľa.", video: "sample_2"))
        sentence.append(Sentence(id: id.increment(), sentence: "Jej babka má vnučku?", video: "sample_2"))
        sentence.append(Sentence(id: id.increment(), sentence: "Moja mama je rozvedená.", video: "sample_2"))
        sentence.append(Sentence(id: id.increment(), sentence: "Druh a družka majú deti.", video: "sample_2"))
        sentence.append(Sentence(id: id.increment(), sentence: "Ako sa volá tvoj druh?", video: "sample_2"))
        sentence.append(Sentence(id: id.increment(), sentence: "Manželia nemajú deti.", video: "sample_2"))
        
        //Lesson 6 - Cisla I
        //ID = 29
        sentence.append(Sentence(id: id.increment(), sentence: "Mám tri kamarátky.", video: "sample_2"))
        sentence.append(Sentence(id: id.increment(), sentence: "Mám štyroch bratov.", video: "sample_2"))
        sentence.append(Sentence(id: id.increment(), sentence: "Môj otec má 37 rokov.", video: "sample_2"))
        sentence.append(Sentence(id: id.increment(), sentence: "Moja kolegyňa je vydatá a má 4 deti.", video: "sample_2"))
        sentence.append(Sentence(id: id.increment(), sentence: "Manželia sú spolu už 19 rokov.", video: "sample_2"))
        sentence.append(Sentence(id: id.increment(), sentence: "Chlapec má 12 rokov.", video: "sample_2"))
        
        //Lesson 7 - Cisla II
        //ID = 35
        sentence.append(Sentence(id: id.increment(), sentence: "Koľko máš rokov?", video: "sample_2"))
        sentence.append(Sentence(id: id.increment(), sentence: "67 – 12 = ?", video: "sample_2"))
        sentence.append(Sentence(id: id.increment(), sentence: "Chlapec má 12 rokov.", video: "sample_2"))
        sentence.append(Sentence(id: id.increment(), sentence: "Starý muž má 70 rokov.", video: "sample_2"))
        sentence.append(Sentence(id: id.increment(), sentence: "30 + 50 = 80. Je to správne?", video: "sample_2"))
        sentence.append(Sentence(id: id.increment(), sentence: "Mladá žena má 27 rokov.", video: "sample_2"))
        
        //Lesson 8 - Meterialy a farby I
        //ID = 41
        sentence.append(Sentence(id: id.increment(), sentence: "Oranžové, fialové a červené farby sú pekné.", video: "sample_2"))
        sentence.append(Sentence(id: id.increment(), sentence: "Otec má rád tmavé farby.", video: "sample_2"))
        sentence.append(Sentence(id: id.increment(), sentence: "Milujem žltú farbu a neznášam čiernu farbu.", video: "sample_2"))
        sentence.append(Sentence(id: id.increment(), sentence: "Milujem svetlú červenú farbu.", video: "sample_2"))
        sentence.append(Sentence(id: id.increment(), sentence: "Nemám rád hnedú a čiernu farbu.", video: "sample_2"))
        sentence.append(Sentence(id: id.increment(), sentence: "Tá žena je škaredá.", video: "sample_2"))
        
        //Lesson 9 - Meterialy a farby II
        //ID = 47
        sentence.append(Sentence(id: id.increment(), sentence: "Modrá keramika je pekná.", video: "sample_2"))
        sentence.append(Sentence(id: id.increment(), sentence: "Mám rád tmavé drevo.", video: "sample_2"))
        sentence.append(Sentence(id: id.increment(), sentence: "Jeho žena má rada zelenú farbu.", video: "sample_2"))
        sentence.append(Sentence(id: id.increment(), sentence: "Neznášam tvrdú kožu.", video: "sample_2"))
        sentence.append(Sentence(id: id.increment(), sentence: "Tmavo sivý kov je pekný a moderný.", video: "sample_2"))
        sentence.append(Sentence(id: id.increment(), sentence: "Milujem moderné sklá.", video: "sample_2"))
        
        return sentence
    }
    
    private func getDictionary() -> Array<Word>{
        
        var dictionary = Array<Word>()
        
        //Lesson 1 - Prvy kontakt I
        dictionary.append(Word(name: "Ahoj", lection: 0, videoFront: "sample_1", videoSide: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Ja", lection: 0,  videoFront: "sample_2", videoSide: "sample_1", inDictionary: true, sentence: [4, 5, 11]))
        dictionary.append(Word(name: "Ty", lection: 0, videoFront: "sample_1", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "On/Ona", lection: 0, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [0, 16]))
        dictionary.append(Word(name: "Áno", lection: 0, videoFront: "sample_1", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Nie", lection: 0, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Nepočujúci", lection: 0, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [0, 4, 15, 16]))
        dictionary.append(Word(name: "Počujúci", lection: 0, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [2, 9]))
        dictionary.append(Word(name: "Rozumieť", lection: 0, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [3]))
        dictionary.append(Word(name: "Nerozumieť", lection: 0, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [5, 11]))
        dictionary.append(Word(name: "Nedoslýchaví", lection: 0, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [17]))
        dictionary.append(Word(name: "Muž", lection: 0, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [16, 38]))
        dictionary.append(Word(name: "Žena", lection: 0, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [4, 10, 40]))
        dictionary.append(Word(name: "Chlapec", lection: 0, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [1, 37]))
        dictionary.append(Word(name: "Dievča", lection: 0, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [2]))
        
        //Lesson 2 - - Prvy kontakt II
        dictionary.append(Word(name: "Meno", lection: 1, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [6]))
        dictionary.append(Word(name: "Moje", lection: 1, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [6, 17]))
        dictionary.append(Word(name: "Tvoje", lection: 1, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [15]))
        dictionary.append(Word(name: "Jeho/Jej", lection: 1, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [49, 18]))
        dictionary.append(Word(name: "Kto", lection: 1, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [7]))
        dictionary.append(Word(name: "My", lection: 1, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [9]))
        dictionary.append(Word(name: "Vy", lection: 1, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Rovnako", lection: 1, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Čo", lection: 1, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Ako", lection: 1, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [8]))
        dictionary.append(Word(name: "Alebo", lection: 1, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Dobre", lection: 1, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [ 12, 13, 14 ]))
        dictionary.append(Word(name: "Zle", lection: 1, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [10]))
        dictionary.append(Word(name: "Prosiť", lection: 1, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Prepáč", lection: 1, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [11]))
   

        //Lesson 3 - Prvy kontakt III
        dictionary.append(Word(name: "Ráno", lection: 2, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [12]))
        dictionary.append(Word(name: "Obed", lection: 2, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Poobede", lection: 2, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Večer", lection: 2,  videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [14]))
        dictionary.append(Word(name: "Noc", lection: 2, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Deň", lection: 2, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [13]))
        dictionary.append(Word(name: "Osoba", lection: 2, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Kamarát/ka", lection: 2, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [15]))
        dictionary.append(Word(name: "Kolega/Kolegyňa", lection: 2, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [17]))
        dictionary.append(Word(name: "Ďakujem", lection: 2, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Pozdraviť", lection: 2, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Poznať", lection: 2, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [16, 18]))
        dictionary.append(Word(name: "Tešiť sa", lection: 2, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Stretnúť", lection: 2, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Opakovať", lection: 2, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))

        //Lesson 4 - Rodina I
        dictionary.append(Word(name: "Mama", lection: 3, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [25]))
        dictionary.append(Word(name: "Otec", lection: 3,  videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [31]))
        dictionary.append(Word(name: "Dcéra", lection: 3,  videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [20]))
        dictionary.append(Word(name: "Syn", lection: 3,   videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Rodina", lection: 3, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Brat", lection: 3, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [19, 30]))
        dictionary.append(Word(name: "Sestra", lection: 3, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [17]))
        dictionary.append(Word(name: "Deti", lection: 3, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [22, 26, 28]))
        dictionary.append(Word(name: "Mám", lection: 3, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [17]))
        dictionary.append(Word(name: "Nemám", lection: 3, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [21, 28]))
        dictionary.append(Word(name: "Babka", lection: 3, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [24]))
        dictionary.append(Word(name: "Dedko", lection: 3, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Dieťa", lection: 3, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Ženatý/Vydatá", lection: 3, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [19, 32]))
        dictionary.append(Word(name: "Slobodný/á", lection: 3, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        

        //Lesson 5 - Rodina II
        dictionary.append(Word(name: "Vnuk", lection: 4, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Vnučka", lection: 4, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [24]))
        dictionary.append(Word(name: "Manžel/ka", lection: 4, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [28, 33]))
        dictionary.append(Word(name: "Rozvedený/á", lection: 4, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [25]))
        dictionary.append(Word(name: "Manželia", lection: 4, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Frajer/ka", lection: 4, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Priateľ/ka", lection: 4, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [23, 29]))
        dictionary.append(Word(name: "Druh/Družka", lection: 4, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [26, 27]))
        dictionary.append(Word(name: "Teta", lection: 4, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Ujo", lection: 4, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Žiť", lection: 4, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Spolu", lection: 4, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Rozvod/Rozchod", lection: 4, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Rande", lection: 4, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Láska", lection: 4, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))

        //Lesson 6 - Čísla I.
        dictionary.append(Word(name: "0-5", lection: 5, videoFront: "sample_2", videoSide: "", inDictionary: false, sentence: [29, 30, 32]))
        dictionary.append(Word(name: "6-10", lection: 5, videoFront: "sample_2", videoSide: "", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "11-15", lection: 5, videoFront: "sample_2", videoSide: "", inDictionary: false, sentence: [34]))
        dictionary.append(Word(name: "16-20", lection: 5, videoFront: "sample_2", videoSide: "", inDictionary: false, sentence: [33]))
        dictionary.append(Word(name: "21-25", lection: 5, videoFront: "sample_2", videoSide: "", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "26-30", lection: 5, videoFront: "sample_2", videoSide: "", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "31-35", lection: 5, videoFront: "sample_2", videoSide: "", inDictionary: false, sentence: [31]))
        dictionary.append(Word(name: "46-50", lection: 5, videoFront: "sample_2", videoSide: "", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "51-55", lection: 5, videoFront: "sample_2", videoSide: "", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "66-80", lection: 5, videoFront: "sample_2", videoSide: "", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "81-85", lection: 5, videoFront: "sample_2", videoSide: "", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "96-99", lection: 5, videoFront: "sample_2", videoSide: "", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "Číslo", lection: 5, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "+/-/*/:/=", lection: 5, videoFront: "sample_2", videoSide: "", inDictionary: false, sentence: [36, 39]))
        dictionary.append(Word(name: "Rokov", lection: 5, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [35, 37, 38]))

        //Lesson 7 - Čísla II.
        dictionary.append(Word(name: "100 - 500", lection: 6, videoFront: "sample_2", videoSide: "", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "600 - 900", lection: 6, videoFront: "sample_2", videoSide: "", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "1000 - 5000", lection: 6, videoFront: "sample_2", videoSide: "", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "6000 - 10000", lection: 6, videoFront: "sample_2", videoSide: "", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "200000 - 50000", lection: 6, videoFront: "sample_2", videoSide: "", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "100 000", lection: 6, videoFront: "sample_2", videoSide: "", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "250 000", lection: 6, videoFront: "sample_2", videoSide: "", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "700 000", lection: 6, videoFront: "sample_2", videoSide: "", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "1 000 000", lection: 6, videoFront: "sample_2", videoSide: "", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "10 000 000", lection: 6, videoFront: "sample_2", videoSide: "", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "Starý", lection: 6, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [38]))
        dictionary.append(Word(name: "Mladý", lection: 6, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [40]))
        dictionary.append(Word(name: "Koľko", lection: 6, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [35]))
        dictionary.append(Word(name: "Správne", lection: 6, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [39]))
        dictionary.append(Word(name: "Nesprávne", lection: 6, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
   
        //Lesson 8 - Materiály a farby I.
        dictionary.append(Word(name: "Farba", lection: 7, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [41, 42]))
        dictionary.append(Word(name: "Biela", lection: 7, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Žltá", lection: 7, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [43]))
        dictionary.append(Word(name: "Ružová", lection: 7, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Oranžová", lection: 7, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [41]))
        dictionary.append(Word(name: "Červená", lection: 7, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [41, 44]))
        dictionary.append(Word(name: "Fialová", lection: 7, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [41]))
        dictionary.append(Word(name: "Svetlá", lection: 7, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [44]))
        dictionary.append(Word(name: "Tmavá", lection: 7, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [42, 48, 51]))
        dictionary.append(Word(name: "Farebná", lection: 7, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Milovať", lection: 7, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [43, 44]))
        dictionary.append(Word(name: "Neznášať", lection: 7, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [43]))
        dictionary.append(Word(name: "Pekná", lection: 7, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [41]))
        dictionary.append(Word(name: "Škaredá", lection: 7, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [46]))
        dictionary.append(Word(name: "Moderná", lection: 7, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [51, 52]))
        
        //Lesson 9 - Materiály a farby II.
        dictionary.append(Word(name: "Modrá", lection: 8, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [47]))
        dictionary.append(Word(name: "Hnedá", lection: 8, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [45]))
        dictionary.append(Word(name: "Zelená", lection: 8, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [49]))
        dictionary.append(Word(name: "Sivá", lection: 8, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [51]))
        dictionary.append(Word(name: "Čierna", lection: 8, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [43, 45]))
        dictionary.append(Word(name: "Materiál", lection: 8, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Papier", lection: 8, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Drevo", lection: 8, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [48]))
        dictionary.append(Word(name: "Železo/Kov", lection: 8, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [51]))
        dictionary.append(Word(name: "Sklo", lection: 8, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [52]))
        dictionary.append(Word(name: "Keramika", lection: 8, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [47]))
        dictionary.append(Word(name: "Látka", lection: 8, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Koža", lection: 8, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [50]))
        dictionary.append(Word(name: "Tvrdá", lection: 8, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [50]))
        dictionary.append(Word(name: "Mäkká", lection: 8, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
    
        //-------- VETY pokracovat ----------
        //Lesson 10 - Bývanie I.
        dictionary.append(Word(name: "Byt", lection: 9, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Dom", lection: 9, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Panelák", lection: 9, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Doma", lection: 9, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Domov", lection: 9, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Sused/ka", lection: 9, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Izba", lection: 9, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Poschodie", lection: 9, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Podnájom", lection: 9, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Prenájom", lection: 9, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Nový", lection: 9, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Vlastný", lection: 9, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Kde", lection: 9, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Kam", lection: 9, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        
        //Lesson 11 - Bývanie II.
        dictionary.append(Word(name: "Ubytovanie", lection: 10, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Internát", lection: 10, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Chata", lection: 10, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Môže", lection: 10, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Nemôže", lection: 10, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Bývať", lection: 10, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Prísť", lection: 10, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Odísť", lection: 10, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Sťahovať", lection: 10, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Nevštíviť", lection: 10, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Malý", lection: 10, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Veľký", lection: 10, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Preč", lection: 10, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Chodiť", lection: 10, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Isť do", lection: 10, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        
    
        //Lesson 12 - Inštitúcie I.
        dictionary.append(Word(name: "Nemocnica", lection: 11, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Škola", lection: 11, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Pošta", lection: 11, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Polícia", lection: 11, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Televízia", lection: 11, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Kostol", lection: 11, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Úrad", lection: 11, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Reštaurácia", lection: 11, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Banka", lection: 11, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Obchod", lection: 11, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Vedľa", lection: 11, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Blízko", lection: 11, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Ďaleko", lection: 11, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Otvorené", lection: 11, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Zatvorené", lection: 11, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
    
        //Lesson 13 - Inštitúcie II.
        dictionary.append(Word(name: "Kino", lection: 12, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Múzeum", lection: 12, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Hrad", lection: 12, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Zámok", lection: 12, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Divadlo", lection: 12, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Centrum", lection: 12, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Námestie", lection: 12, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Ulica", lection: 12, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Park", lection: 12, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Hotel", lection: 12, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Služba", lection: 12, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Firma", lection: 12, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Oproti", lection: 12, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Všetko", lection: 12, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Prechádzať", lection: 12, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        
        
        //Lesson 14 - Mestá I.
        dictionary.append(Word(name: "Bratislava", lection: 13, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Košice", lection: 13, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Nitra", lection: 13, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Žilina", lection: 13, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Banská Bystrica", lection: 13, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Lučenec", lection: 13, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Poprad", lection: 13, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Liptovský Mikuláš", lection: 13, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Prešov", lection: 13, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Trnava", lection: 13, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Mesto", lection: 13, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Dedina", lection: 13, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Okres", lection: 13, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Pekné", lection: 13, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Škaredé", lection: 13, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        
        
        //Lesson 15 - Mestá II.
        dictionary.append(Word(name: "Zvolen", lection: 14, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Trenčín", lection: 14, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Prievidza", lection: 14, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Martin", lection: 14, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Púchov", lection: 14, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Vysoké Tatry", lection: 14, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Ružomberok", lection: 14, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Žiar nad Hronom", lection: 14, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Dunajská Streda", lection: 14, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Piešťany", lection: 14, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Chcieť", lection: 14, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Nechcieť", lection: 14, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Pochádzať", lection: 14, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Cestovať", lection: 14, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Odkiaľ", lection: 14, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        
        //Lesson 16 - Doprava I.
        dictionary.append(Word(name: "Auto", lection: 15, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Motorka", lection: 15, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Autobus", lection: 15, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Vlak", lection: 15, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Trolejbus", lection: 15, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Električka", lection: 15, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Lietadlo", lection: 15, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Bicykel", lection: 15, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Loď", lection: 15, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Doprava", lection: 15, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Jazdiť", lection: 15, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Pomaly", lection: 15, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Rýchlo", lection: 15, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Dráha", lection: 15, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Lacná", lection: 15, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        
        //Lesson 16 - Doprava II.
        dictionary.append(Word(name: "Metro", lection: 16, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Most", lection: 16, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Diaľnica", lection: 16, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Cesta", lection: 16, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Parkovisko", lection: 16, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Taxi", lection: 16, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Semafor", lection: 16, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Nehoda", lection: 16, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Turbulencia", lection: 16, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Rieka", lection: 16, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Šofér", lection: 16, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Pri", lection: 16, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Problém", lection: 16, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Pokuta", lection: 16, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        
        //Lesson 17 - Čas I.
        dictionary.append(Word(name: "Čas", lection: 17, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Sekudna", lection: 17, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Minúta", lection: 17, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Hodina", lection: 17, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Hodiny", lection: 17, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "1h - 5h", lection: 17, videoFront: "sample_2", videoSide: "", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "6h - 10h", lection: 17, videoFront: "sample_2", videoSide: "", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "11h - 12h", lection: 17, videoFront: "sample_2", videoSide: "", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "o 1h - o 6h", lection: 17, videoFront: "sample_2", videoSide: "", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "o 7h - o 12h", lection: 17, videoFront: "sample_2", videoSide: "", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "O koľkej", lection: 17, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Kedy", lection: 17, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Meškať", lection: 17, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Čakať", lection: 17, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Vstávať", lection: 17, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        
        //Lesson 19 - Čas II.
        dictionary.append(Word(name: "Práca", lection: 18, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Dovolenka", lection: 18, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Voľno", lection: 18, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Teraz", lection: 18, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Každý", lection: 18, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Pravidelne", lection: 18, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Nepravidelne", lection: 18, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Bude", lection: 18, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Bolo", lection: 18, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Jesť", lection: 18, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Odpočívať", lection: 18, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Pred", lection: 18, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Po", lection: 18, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Asi", lection: 18, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Až", lection: 18, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        
        //Lesson 20 - Kalendár I.
        dictionary.append(Word(name: "Pondelok", lection: 19, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Utorok", lection: 19, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Streda", lection: 19, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Štvrtok", lection: 19, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Piatok", lection: 19, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Sobota", lection: 19, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Nedeľa", lection: 19, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Týždeň", lection: 19, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Sviatok", lection: 19, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Dnes", lection: 19, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Včera", lection: 19, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Zajtra", lection: 19, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Kalendár", lection: 19, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Prázdniny", lection: 19, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Víkend", lection: 19, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        
        //Lesson 21 - Kalendár II.
        dictionary.append(Word(name: "Január", lection: 20, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Február", lection: 20, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Marec", lection: 20, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Apríl", lection: 20, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Máj", lection: 20, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Jún", lection: 20, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Júl", lection: 20, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "August", lection: 20, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "September", lection: 20, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Október", lection: 20, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "November", lection: 20, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "December", lection: 20, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Mesiac", lection: 20, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Rok", lection: 20, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Dátum", lection: 20, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        

        //Lesson 22 - Zvieratá I.
        dictionary.append(Word(name: "Pes", lection: 21, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Mačka", lection: 21, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Sliepka", lection: 21, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Krava", lection: 21, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Koza", lection: 21, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Prasa", lection: 21, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Kôn", lection: 21, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Zajac", lection: 21, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Ovca", lection: 21, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Hus", lection: 21, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Farma", lection: 21, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Dvor", lection: 21, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Kŕmiť", lection: 21, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Strážiť", lection: 21, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Chovať", lection: 21, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        
        
        //Lesson 23 - Zvieratá II.
        dictionary.append(Word(name: "Medveď", lection: 22, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Vlk", lection: 22, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Jeleň", lection: 22, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Srna", lection: 22, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Myš", lection: 22, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Motýľ", lection: 22, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Líška", lection: 22, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Žaba", lection: 22, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Veverička", lection: 22, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Včela", lection: 22, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Les", lection: 22, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Zviera", lection: 22, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Strom", lection: 22, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Báť sa", lection: 22, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Dôvod", lection: 22, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        
         //Lesson 24 - Zvieratá III.
        dictionary.append(Word(name: "Opica", lection: 23, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Gorila", lection: 23, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Lev", lection: 23, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Tiger", lection: 23, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Slon", lection: 23, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Had", lection: 23, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Krokodil", lection: 23, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Žirafa", lection: 23, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Korytnačka", lection: 23, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Ťava", lection: 23, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "ZOO", lection: 23, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Nebezpečný", lection: 23, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Jedovatý", lection: 23, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Hrať", lection: 23, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Niektoré", lection: 23, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        
        //Lesson 25 - Ovocie
        dictionary.append(Word(name: "Jablko", lection: 24, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Pomaranč", lection: 24, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Slivka", lection: 24, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Mandarinka", lection: 24, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Banán", lection: 24, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Čerešne", lection: 24, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Hrozno", lection: 24, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Jahoda", lection: 24, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Hruška", lection: 24, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Broskyňa", lection: 24, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Sladké", lection: 24, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Kyslé", lection: 24, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Chutné", lection: 24, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Čerstvé", lection: 24, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Ovocie", lection: 24, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        
        //Lesson 26 - Zelenina
        dictionary.append(Word(name: "Paradjaka", lection: 25, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Cibuľa", lection: 25, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Paprika", lection: 25, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Mrkva", lection: 25, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Kapusta", lection: 25, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Kukurica", lection: 25, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Uhorka", lection: 25, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Zemiaky", lection: 25, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Cesnak", lection: 25, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Hrach", lection: 25, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Ošúpať", lection: 25, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Zelenina", lection: 25, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Zdravá", lection: 25, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Tržnica", lection: 25, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Kúpiť", lection: 25, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        
        //Lesson 27 - Ročné obdobie I.
        dictionary.append(Word(name: "Jar", lection: 26, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Leto", lection: 26, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Jeseň", lection: 26, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Zima", lection: 26, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Teplo", lection: 26, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Príroda", lection: 26, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Záhrada", lection: 26, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Kvet", lection: 26, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Tráva", lection: 26, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Počasie", lection: 26, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Krásne", lection: 26, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Sadiť", lection: 26, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Rásť", lection: 26, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Kopať", lection: 26, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Oberať", lection: 26, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        
        //Lesson 28 - Ročné obdobie II.
        dictionary.append(Word(name: "More", lection: 27, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Hora", lection: 27, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Horúco", lection: 27, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Jazero", lection: 27, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "List", lection: 27, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Dážď", lection: 27, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Vianoce", lection: 27, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Oblečenie", lection: 27, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Sneh", lection: 27, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Vietor", lection: 27, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Silný", lection: 27, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Slabý", lection: 27, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Padať", lection: 27, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Tenké", lection: 27, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Hrubé", lection: 27, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        
        
        return dictionary;
    }
    
    
}
