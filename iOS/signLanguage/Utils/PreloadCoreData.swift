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
    var order : Int
    var videoFront : String
    var videoSide : String
    var inDictionary : Bool
    var sentence : [Int]?
    
//    init(_ name : String, _ lection: Int, _ order :Int, _ videoFront: String, _ videoSide: String, _ inDictionary : Bool, _ sentence: [Int]) {
//        self.name = name
//        self.lection = lection
//        self.order = order
//        self.videoFront = videoFront
//        self.videoSide = videoSide
//        self.inDictionary = inDictionary
//        self.sentence = sentence
//    }
}

struct Lection {
    var id : Int
    var title : String
    var image : String
}

class ID {
    private var id = 0
    
    init() {
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

        var lection = Array<Lection>()
        
        lection.append(Lection(id: 0, title: "Prvý kontakt I.", image: "firstContact_I" ))
        lection.append(Lection(id: 1, title: "Prvý kontakt II.", image: "firstContact_II" ))
        lection.append(Lection(id: 2, title: "Prvý kontakt III.", image: "firstContact_III" ))
        lection.append(Lection(id: 3, title: "Rodina I.", image: "family_I" ))
        lection.append(Lection(id: 4, title: "Rodina II.", image: "family_II" ))
        lection.append(Lection(id: 5, title: "Čísla I.", image: "numbers_I" ))
        lection.append(Lection(id: 6, title: "Čísla II.", image: "numbers_II" ))
        lection.append(Lection(id: 7, title: "Farby I.", image: "colors_I" ))
        lection.append(Lection(id: 8, title: "Farby II.", image: "colors_II" ))
        lection.append(Lection(id: 9, title: "Bývanie I.", image: "live_I" ))
        lection.append(Lection(id: 10, title: "Bývanie II.", image: "live_II" ))
        lection.append(Lection(id: 11, title: "Inštitúcie I.", image: "institution_I" ))
        lection.append(Lection(id: 12, title: "Inštitúcie II.", image: "institution_II" ))
        lection.append(Lection(id: 13, title: "Mestá I.", image: "city_I" ))
        lection.append(Lection(id: 14, title: "Mestá II.", image: "city_II" ))
        lection.append(Lection(id: 15, title: "Doprava I.", image: "transport_I" ))
        lection.append(Lection(id: 16, title: "Doprava II.", image: "transport_II" ))
        lection.append(Lection(id: 17, title: "Čas I.", image: "time_I" ))
        lection.append(Lection(id: 18, title: "Čas II.", image: "time_II" ))
        lection.append(Lection(id: 19, title: "Kalendár I.", image: "calendar_I" ))
        lection.append(Lection(id: 20, title: "Kalendár II.", image: "calendar_II" ))
        lection.append(Lection(id: 21, title: "Zvierata I.", image: "animals_I" ))
        lection.append(Lection(id: 22, title: "Zvierata II.", image: "animals_II" ))
        lection.append(Lection(id: 23, title: "Zvierata III.", image: "animals_III" ))
        lection.append(Lection(id: 24, title: "Ovocie", image: "fruits_I" ))
        lection.append(Lection(id: 25, title: "Zelenina", image: "vegetables_I" ))
        lection.append(Lection(id: 26, title: "Ročné obdobie I.", image: "season_I" ))
        lection.append(Lection(id: 27, title: "Ročné obdobie II.", image: "season_II" ))
        
        return lection
    }
    
    private func getSentences() -> Array<Sentence> {

        var sentence = Array<Sentence>()
        
        //Lesson 1 - Prvy kontakt I
        sentence.append(Sentence(id: 0, sentence: "On je nepočujúci.", video: "sample_2"))
        sentence.append(Sentence(id: 1, sentence: "Som chlapec.", video: "sample_2"))
        sentence.append(Sentence(id: 2, sentence: "Dievča je počujúca.", video: "sample_2"))
        sentence.append(Sentence(id: 3, sentence: "Rozumieš?", video: "sample_2"))
        sentence.append(Sentence(id: 4, sentence: "Ja som nepočujúca žena.", video: "sample_2"))
        sentence.append(Sentence(id: 5, sentence: "Ja ti nerozumiem.", video: "sample_2"))
        
        //Lesson 2 - - Prvy kontakt II
        sentence.append(Sentence(id: 6, sentence: "Moje meno ...", video: "sample_2"))
        sentence.append(Sentence(id: 7, sentence: "Kto som?", video: "sample_2"))
        sentence.append(Sentence(id: 8, sentence: "Ako sa máš?", video: "sample_2"))
        sentence.append(Sentence(id: 9, sentence: "My sme počujúci.", video: "sample_2"))
        sentence.append(Sentence(id: 10, sentence: "Žena je zlá.", video: "sample_2"))
        sentence.append(Sentence(id: 11, sentence: "Prepáč, ja ti nerozumiem.", video: "sample_2"))
        
        //Lesson 3 - Prvy kontakt III
        sentence.append(Sentence(id: 12, sentence: "Dobre ráno.", video: "sample_2"))
        sentence.append(Sentence(id: 13, sentence: "Dobrý deň.", video: "sample_2"))
        sentence.append(Sentence(id: 14, sentence: "Dobrý večer.", video: "sample_2"))
        sentence.append(Sentence(id: 15, sentence: "Tvoja kamarátka je nepočujúca?", video: "sample_2"))
        sentence.append(Sentence(id: 16, sentence: "Ona pozná nepočujúceho muža.", video: "sample_2"))
        sentence.append(Sentence(id: 17, sentence: "Moja kolegyňa je nedoslýchavá.", video: "sample_2"))
        
        //Lesson 4 - Rodina I
        sentence.append(Sentence(id: 18, sentence: "Mám počujúcu sestru.", video: "sample_2"))
        sentence.append(Sentence(id: 19, sentence: "Poznám jeho rodičov.", video: "sample_2"))
        sentence.append(Sentence(id: 20, sentence: "Môj brat je ženatý.", video: "sample_2"))
        sentence.append(Sentence(id: 21, sentence: "On má nepočujúcu dcéru.", video: "sample_2"))
        sentence.append(Sentence(id: 22, sentence: "Nemám súrodencov.", video: "sample_2"))
        sentence.append(Sentence(id: 23, sentence: "Moje dieťa v noci spí.", video: "sample_2"))
        
        //Lesson 5 - Rodina I
        sentence.append(Sentence(id: 24, sentence: "Mám priateľa.", video: "sample_2"))
        sentence.append(Sentence(id: 25, sentence: "Jej babka má vnučku?", video: "sample_2"))
        sentence.append(Sentence(id: 26, sentence: "Moja mama je rozvedená.", video: "sample_2"))
        sentence.append(Sentence(id: 27, sentence: "Druh a družka majú deti.", video: "sample_2"))
        sentence.append(Sentence(id: 28, sentence: "Ako sa volá tvoj druh?", video: "sample_2"))
        sentence.append(Sentence(id: 29, sentence: "Manželia nemajú deti.", video: "sample_2"))
        
        //Lesson 6 - Cisla I
        sentence.append(Sentence(id: 30, sentence: "Mám tri kamarátky.", video: "sample_2"))
        sentence.append(Sentence(id: 31, sentence: "Mám štyroch bratov.", video: "sample_2"))
        sentence.append(Sentence(id: 32, sentence: "Môj otec má 37 rokov.", video: "sample_2"))
        sentence.append(Sentence(id: 33, sentence: "Moja kolegyňa je vydatá a má 4 deti.", video: "sample_2"))
        sentence.append(Sentence(id: 34, sentence: "Manželia sú spolu už 19 rokov.", video: "sample_2"))
        sentence.append(Sentence(id: 35, sentence: "Chlapec má 12 rokov.", video: "sample_2"))
        
        //Lesson 7 - Cisla II
        sentence.append(Sentence(id: 36, sentence: "Koľko máš rokov?", video: "sample_2"))
        sentence.append(Sentence(id: 37, sentence: "67 – 12 = ?", video: "sample_2"))
        sentence.append(Sentence(id: 38, sentence: "Chlapec má 12 rokov.", video: "sample_2"))
        sentence.append(Sentence(id: 39, sentence: "Starý muž má 70 rokov.", video: "sample_2"))
        sentence.append(Sentence(id: 40, sentence: "30 + 50 = 80. Je to správne?", video: "sample_2"))
        sentence.append(Sentence(id: 41, sentence: "Mladá žena má 27 rokov.", video: "sample_2"))
        
        //Lesson 8 - Meterialy a farby I
        sentence.append(Sentence(id: 42, sentence: "Oranžové, fialové a červené farby sú pekné.", video: "sample_2"))
        sentence.append(Sentence(id: 43, sentence: "Otec má rád tmavé farby.", video: "sample_2"))
        sentence.append(Sentence(id: 44, sentence: "Milujem žltú farbu a neznášam čiernu farbu.", video: "sample_2"))
        sentence.append(Sentence(id: 45, sentence: "Milujem svetlú červenú farbu.", video: "sample_2"))
        sentence.append(Sentence(id: 46, sentence: "Nemám rád hnedú a čiernu farbu.", video: "sample_2"))
        sentence.append(Sentence(id: 47, sentence: "Tá žena je škaredá.", video: "sample_2"))
        
        //Lesson 9 - Meterialy a farby II
        sentence.append(Sentence(id: 48, sentence: "Modrá keramika je pekná.", video: "sample_2"))
        sentence.append(Sentence(id: 49, sentence: "Mám rád tmavé drevo.", video: "sample_2"))
        sentence.append(Sentence(id: 50, sentence: "Jeho žena má rada zelenú farbu.", video: "sample_2"))
        sentence.append(Sentence(id: 51, sentence: "Neznášam tvrdú kožu.", video: "sample_2"))
        sentence.append(Sentence(id: 52, sentence: "Tmavo sivý kov je pekný a moderný.", video: "sample_2"))
        sentence.append(Sentence(id: 53, sentence: "Milujem moderné sklá.", video: "sample_2"))
        
        //Lection 10 - Byvanie I.
        sentence.append(Sentence(id: 54, sentence: "Mám starý dom.", video: "sample_2"))
        sentence.append(Sentence(id: 55, sentence: "Babka má vlastný byt.", video: "sample_2"))
        sentence.append(Sentence(id: 56, sentence: "On sa teší domov.", video: "sample_2"))
        sentence.append(Sentence(id: 57, sentence: "Poznáš jej susedku?", video: "sample_2"))
        sentence.append(Sentence(id: 58, sentence: "Kde bývaš?", video: "sample_2"))
        sentence.append(Sentence(id: 59, sentence: "Môj kolega býva v prenájme.", video: "sample_2"))
        
        //Lection 11 - Byvani II
        sentence.append(Sentence(id: 60, sentence: "Bývam na internáte.", video: "sample_2"))
        sentence.append(Sentence(id: 61, sentence: "Ja mám veľký byt.", video: "sample_2"))
        sentence.append(Sentence(id: 62, sentence: "Kam ideš?", video: "sample_2"))
        sentence.append(Sentence(id: 63, sentence: "Susedia v noci odišli preč.", video: "sample_2"))
        sentence.append(Sentence(id: 64, sentence: "Na ktorom poschodí bývaš?", video: "sample_2"))
        sentence.append(Sentence(id: 65, sentence: "Tvoja chata je stará alebo nová?", video: "sample_2"))
        
        //Lection 12 - Institucie I.
        sentence.append(Sentence(id: 66, sentence: "Ideme do centra, je to blízko.", video: "sample_2"))
        sentence.append(Sentence(id: 67, sentence: "Môj dedko býva ďaleko.", video: "sample_2"))
        sentence.append(Sentence(id: 68, sentence: "Nerád chodím na úrad.", video: "sample_2"))
        sentence.append(Sentence(id: 69, sentence: "Pošta má modro-žltú farbu.", video: "sample_2"))
        sentence.append(Sentence(id: 70, sentence: "Idem do školy.", video: "sample_2"))
        sentence.append(Sentence(id: 71, sentence: "Veľké obchody sú zatvorené.", video: "sample_2"))
        
        //Lection 13 - Institucie II.
        sentence.append(Sentence(id: 72, sentence: "Môj otec rád chodí do kina.", video: "sample_2"))
        sentence.append(Sentence(id: 73, sentence: "Na námestí reštaurácie sú otvorené.", video: "sample_2"))
        sentence.append(Sentence(id: 74, sentence: "Oproti divadlu je múzeum.", video: "sample_2"))
        sentence.append(Sentence(id: 75, sentence: "Vedľa múzea je hnedý zámok.", video: "sample_2"))
        sentence.append(Sentence(id: 76, sentence: "Rád sa prechádzam v parku.", video: "sample_2"))
        sentence.append(Sentence(id: 77, sentence: "Na ulici je tam starý hotel.", video: "sample_2"))
        
        //Lection 14 - Mestá I.
        sentence.append(Sentence(id: 78, sentence: "Môj brat býva v Žiline.", video: "sample_2"))
        sentence.append(Sentence(id: 79, sentence: "V Bratislave sú staré červeno-žlté električky.", video: "sample_2"))
        sentence.append(Sentence(id: 80, sentence: "Neznášam dedinu.", video: "sample_2"))
        sentence.append(Sentence(id: 81, sentence: "Prešov je pekné mesto.", video: "sample_2"))
        sentence.append(Sentence(id: 82, sentence: "Tešíš sa ísť do Popradu?", video: "sample_2"))
        sentence.append(Sentence(id: 83, sentence: "Na dedine sú farebné domy a biely kostol.", video: "sample_2"))
        
        //Lection 15 - Mestá II.
        sentence.append(Sentence(id: 84, sentence: "Blízko Prievidze je zámok.", video: "sample_2"))
        sentence.append(Sentence(id: 85, sentence: "Odkiaľ si?", video: "sample_2"))
        sentence.append(Sentence(id: 86, sentence: "Žijem vo Zvolene.", video: "sample_2"))
        sentence.append(Sentence(id: 87, sentence: "Nechcem bývať v Ružomberku.", video: "sample_2"))
        sentence.append(Sentence(id: 88, sentence: "Moja rodina pochádza z Košíc.", video: "sample_2"))
        sentence.append(Sentence(id: 89, sentence: "Druhovia spolu žijú už 13 rokov v Nitre.", video: "sample_2"))
        
        //Lection 16 - Doprava I.
        sentence.append(Sentence(id: 90, sentence: "Auto ide pomaly.", video: "sample_2"))
        sentence.append(Sentence(id: 91, sentence: "Plávať loďou.", video: "sample_2"))
        sentence.append(Sentence(id: 92, sentence: "Kto má fialové auto?", video: "sample_2"))
        sentence.append(Sentence(id: 93, sentence: "Žena išla rýchlo motorkou do nemocnice.", video: "sample_2"))
        sentence.append(Sentence(id: 94, sentence: "Môj brat má starý bicykel.", video: "sample_2"))
        sentence.append(Sentence(id: 95, sentence: "Rád chodím na starom aute.", video: "sample_2"))
        
        //Lection 17 - Doprava II.
        sentence.append(Sentence(id: 96, sentence: "V centre mesta taxík jazdí pomaly.", video: "sample_2"))
        sentence.append(Sentence(id: 97, sentence: "Nie som dobrý šofér, ale moja sestra áno.", video: "sample_2"))
        sentence.append(Sentence(id: 98, sentence: "V Bratislave nie je metro.", video: "sample_2"))
        sentence.append(Sentence(id: 99, sentence: "V centre mesta je problém s parkovaním.", video: "sample_2"))
        sentence.append(Sentence(id: 100, sentence: "Stretneme sa na parkovisku pri moste?", video: "sample_2"))
        sentence.append(Sentence(id: 101, sentence: "Včera v noci auto a autobus havarovali pri tuneli.", video: "sample_2"))
        
        //Lection 18 - Cas I.
        sentence.append(Sentence(id: 102, sentence: "9:03", video: "sample_2"))
        sentence.append(Sentence(id: 103, sentence: "6:25", video: "sample_2"))
        sentence.append(Sentence(id: 104, sentence: "14:40", video: "sample_2"))
        sentence.append(Sentence(id: 105, sentence: "20:30", video: "sample_2"))
        sentence.append(Sentence(id: 106, sentence: "Koľko je hodín?", video: "sample_2"))
        sentence.append(Sentence(id: 107, sentence: "Kedy ideš na električku?", video: "sample_2"))
        
        //Lection 19 - Cas II.
        sentence.append(Sentence(id: 108, sentence: "Každý deň chodím do práce.", video: "sample_2"))
        sentence.append(Sentence(id: 109, sentence: "Chodíš pravidelne do divadla?", video: "sample_2"))
        sentence.append(Sentence(id: 110, sentence: "Na úrade som čakala 2 hodiny.", video: "sample_2"))
        sentence.append(Sentence(id: 111, sentence: "Nechce sa mi.", video: "sample_2"))
        sentence.append(Sentence(id: 112, sentence: "Nemám čas.", video: "sample_2"))
        sentence.append(Sentence(id: 113, sentence: "Za hodinu príde vlak.", video: "sample_2"))
        
        //Lection 20 - Kalendar I.
        sentence.append(Sentence(id: 114, sentence: "Včera bola nedeľa.", video: "sample_2"))
        sentence.append(Sentence(id: 115, sentence: "Prídem v sobotu večer.", video: "sample_2"))
        sentence.append(Sentence(id: 116, sentence: "Dnes je štvrtok.", video: "sample_2"))
        sentence.append(Sentence(id: 117, sentence: "Zajtra budem mať voľno.", video: "sample_2"))
        sentence.append(Sentence(id: 118, sentence: "Cez víkend budem u babky.", video: "sample_2"))
        sentence.append(Sentence(id: 119, sentence: "V piatok sme mali stretnutie.", video: "sample_2"))
        
        //Lection 21 - Kalendar II.
        sentence.append(Sentence(id: 120, sentence: "12.5.2018", video: "sample_2"))
        sentence.append(Sentence(id: 121, sentence: "6.2.1980", video: "sample_2"))
        sentence.append(Sentence(id: 122, sentence: "20.8.2001", video: "sample_2"))
        sentence.append(Sentence(id: 123, sentence: "4.4.1944", video: "sample_2"))
        sentence.append(Sentence(id: 124, sentence: "Dňa 1.5. je sviatok práce.", video: "sample_2"))
        sentence.append(Sentence(id: 125, sentence: "Rok má 12 mesiacov.", video: "sample_2"))
        
        //Lection 22 - Zvierata I.
        sentence.append(Sentence(id: 126, sentence: "Môj dedo choval ovce, kravy aj kone.", video: "sample_2"))
        sentence.append(Sentence(id: 127, sentence: "Prasa zje všetko.", video: "sample_2"))
        sentence.append(Sentence(id: 128, sentence: "Pes vie dobre strážiť.", video: "sample_2"))
        sentence.append(Sentence(id: 129, sentence: "Na dedine je tam veľká farma.", video: "sample_2"))
        sentence.append(Sentence(id: 130, sentence: "Babka mojej kamarátky má veľký dvor.", video: "sample_2"))
        sentence.append(Sentence(id: 131, sentence: "Chová tam sliepky, husi, zajace a kozy.", video: "sample_2"))
        sentence.append(Sentence(id: 132, sentence: "Dedina pri Zolene má krásny dvor. ", video: "sample_2"))
        sentence.append(Sentence(id: 133, sentence: "Vo dvore chovajú ovce, kozy a kone.", video: "sample_2"))
        
        //Lection 23 - Zvierata II.
        sentence.append(Sentence(id: 134, sentence: "Veverička žije na strome.", video: "sample_2"))
        sentence.append(Sentence(id: 135, sentence: "Moja mama sa bojí myší.", video: "sample_2"))
        sentence.append(Sentence(id: 136, sentence: "Medveď biely má rád zimu.", video: "sample_2"))
        sentence.append(Sentence(id: 137, sentence: "Moja teta doma chová motýle.", video: "sample_2"))
        sentence.append(Sentence(id: 138, sentence: "Na chate pri lese sme videli veľa žáb.", video: "sample_2"))
        sentence.append(Sentence(id: 139, sentence: "V lese žijú medvede, srnky aj líšky.", video: "sample_2"))

        //Lection 24 - Zvierata III.
        sentence.append(Sentence(id: 140, sentence: "Opice sa radi hrajú.", video: "sample_2"))
        sentence.append(Sentence(id: 141, sentence: "Lev a tiger nie sú dobrí kamaráti.", video: "sample_2"))
        sentence.append(Sentence(id: 142, sentence: "Bojím sa chodiť sama do lesa, lebo sú tam nebezpečné zvieratá.", video: "sample_2"))
        sentence.append(Sentence(id: 143, sentence: "Moja vnučka chce mať doma hada.", video: "sample_2"))
        sentence.append(Sentence(id: 144, sentence: "Pri Prievidzi je tam ZOO.", video: "sample_2"))
        sentence.append(Sentence(id: 145, sentence: "Krokodíl, lev, tiger a niektoré hady sú nebezpečné zvieratá.", video: "sample_2"))
        
        //Lection 25 - Ovocie I.
        sentence.append(Sentence(id: 146, sentence: "V Júni bývajú jahody.", video: "sample_2"))
        sentence.append(Sentence(id: 147, sentence: "Mamička v nedeľu upiekla čerešňový koláč.", video: "sample_2"))
        sentence.append(Sentence(id: 148, sentence: "Hrozno býva kyslé aj sladké.", video: "sample_2"))
        sentence.append(Sentence(id: 149, sentence: "Pomaranče mi viac chutia v zime.", video: "sample_2"))
        sentence.append(Sentence(id: 150, sentence: "Banány môžeme kúpiť za 1 € a jablká za 80 centov.", video: "sample_2"))
        sentence.append(Sentence(id: 151, sentence: "Moje dieťa má radšej ovocie ako zeleninu.", video: "sample_2"))
        
        //Lection 26 - Zelenina I.
        sentence.append(Sentence(id: 152, sentence: "Deti musia jesť veľa ovocia a zeleniny.", video: "sample_2"))
        sentence.append(Sentence(id: 153, sentence: "Pri ceste predávajú domáce zeleniny.", video: "sample_2"))
        sentence.append(Sentence(id: 154, sentence: "Nerád šúpem zemiaky.", video: "sample_2"))
        sentence.append(Sentence(id: 155, sentence: "Na trhovisku predávajú čerstvé ovocie.", video: "sample_2"))
        sentence.append(Sentence(id: 156, sentence: "Na trhovisku môžem ochutnať kyslú kapustu.", video: "sample_2"))
        sentence.append(Sentence(id: 157, sentence: "Rád jem veľa zeleniny, preto som zdravý.", video: "sample_2"))
        
        //Lection 27 - Seasson I.
        sentence.append(Sentence(id: 158, sentence: "Na jar sadíme kvety.", video: "sample_2"))
        sentence.append(Sentence(id: 159, sentence: "Dievčaťa majú radi krásne kvety.", video: "sample_2"))
        sentence.append(Sentence(id: 160, sentence: "Na jeseň sa oberá hrozno.", video: "sample_2"))
        sentence.append(Sentence(id: 161, sentence: "Vo dvore rastie tráva.", video: "sample_2"))
        sentence.append(Sentence(id: 162, sentence: "Môj priateľ miluje jeseň, lebo je krásne farebná.", video: "sample_2"))
        sentence.append(Sentence(id: 163, sentence: "Moji starí rodičia pestujú v záhrade kapustu a mrkvu.", video: "sample_2"))
        
        //Lection 28 - Seasson II.
        sentence.append(Sentence(id: 164, sentence: "Nerád jazdím autom, keď je vonku sneh.", video: "sample_2"))
        sentence.append(Sentence(id: 165, sentence: "V júli je horúco.", video: "sample_2"))
        sentence.append(Sentence(id: 166, sentence: "Na horách bývajú silné vetry.", video: "sample_2"))
        sentence.append(Sentence(id: 167, sentence: "Vianoce je krásne obdobie.", video: "sample_2"))
        sentence.append(Sentence(id: 168, sentence: "V zime si oblečiem hrubé oblečenie.", video: "sample_2"))
        sentence.append(Sentence(id: 169, sentence: "Jablká rastú na jeseň.", video: "sample_2"))
        
        return sentence
    }
    
    private func getDictionary() -> Array<Word>{
        
        var dictionary = Array<Word>()
        
        //Lesson 1 - Prvy kontakt I
        dictionary.append(Word(name: "Ahoj",         lection: 0, order: 0,  videoFront: "sample_1", videoSide: "sample_2", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Ja",           lection: 0, order: 1,  videoFront: "sample_2", videoSide: "sample_1", inDictionary: true, sentence: [4, 5, 11]))
        dictionary.append(Word(name: "Ty",           lection: 0, order: 2,  videoFront: "sample_1", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "On/Ona",       lection: 0, order: 3,  videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [0, 16]))
        dictionary.append(Word(name: "Áno",          lection: 0, order: 4,  videoFront: "sample_1", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Nie",          lection: 0, order: 5,  videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Nepočujúci",   lection: 0, order: 6,  videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [0, 4, 15, 16]))
        dictionary.append(Word(name: "Počujúci",     lection: 0, order: 7,  videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [2, 9]))
        dictionary.append(Word(name: "Rozumieť",     lection: 0, order: 8,  videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [3]))
        dictionary.append(Word(name: "Nerozumieť",   lection: 0, order: 9,  videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [5, 11]))
        dictionary.append(Word(name: "Nedoslýchaví", lection: 0, order: 10, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [17]))
        dictionary.append(Word(name: "Muž",          lection: 0, order: 11, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [16, 39]))
        dictionary.append(Word(name: "Žena",         lection: 0, order: 12, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [4, 10, 41]))
        dictionary.append(Word(name: "Chlapec",      lection: 0, order: 13, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [1, 38]))
        dictionary.append(Word(name: "Dievča",       lection: 0, order: 14, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [2, 159]))
        
        //Lesson 2 - - Prvy kontakt II
        dictionary.append(Word(name: "Meno",     lection: 1, order: 0,  videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [6]))
        dictionary.append(Word(name: "Moje",     lection: 1, order: 1,  videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [6, 17]))
        dictionary.append(Word(name: "Tvoje",    lection: 1, order: 2,  videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [15, 28]))
        dictionary.append(Word(name: "Jeho/Jej", lection: 1, order: 3,  videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [50, 19]))
        dictionary.append(Word(name: "Kto",      lection: 1, order: 4,  videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [7, 92]))
        dictionary.append(Word(name: "My",       lection: 1, order: 5,  videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [9]))
        dictionary.append(Word(name: "Vy",       lection: 1, order: 6,  videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Rovnako",  lection: 1, order: 7,  videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Čo",       lection: 1, order: 8,  videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Ako",      lection: 1, order: 9,  videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [8]))
        dictionary.append(Word(name: "Alebo",    lection: 1, order: 10, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Dobre",    lection: 1, order: 11, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [ 12, 13, 14 ]))
        dictionary.append(Word(name: "Zle",      lection: 1, order: 12, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [10]))
        dictionary.append(Word(name: "Prosiť",   lection: 1, order: 13, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Prepáč",   lection: 1, order: 14, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [11]))
   

        //Lesson 3 - Prvy kontakt III
        dictionary.append(Word(name: "Ráno",            lection: 2, order: 0,  videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [12]))
        dictionary.append(Word(name: "Obed",            lection: 2, order: 1,  videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Poobede",         lection: 2, order: 2,  videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Večer",           lection: 2, order: 3,  videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [14, 115]))
        dictionary.append(Word(name: "Noc",             lection: 2, order: 4,  videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [63, 101]))
        dictionary.append(Word(name: "Deň",             lection: 2, order: 5,  videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [13, 108]))
        dictionary.append(Word(name: "Osoba",           lection: 2, order: 6,  videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Kamarát/ka",      lection: 2, order: 7,  videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [15, 130]))
        dictionary.append(Word(name: "Kolega/Kolegyňa", lection: 2, order: 8,  videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [17, 59]))
        dictionary.append(Word(name: "Ďakujem",         lection: 2, order: 9,  videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Pozdraviť",       lection: 2, order: 10, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Poznať",          lection: 2, order: 11, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [16, 19]))
        dictionary.append(Word(name: "Tešiť sa",        lection: 2, order: 12, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [82]))
        dictionary.append(Word(name: "Stretnúť",        lection: 2, order: 13, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [100, 119]))
        dictionary.append(Word(name: "Opakovať",        lection: 2, order: 14, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))

        //Lesson 4 - Rodina I
        dictionary.append(Word(name: "Mama",          lection: 3, order: 0, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [26, 135]))
        dictionary.append(Word(name: "Otec",          lection: 3, order: 1, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [32, 72]))
        dictionary.append(Word(name: "Dcéra",         lection: 3, order: 2, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [21]))
        dictionary.append(Word(name: "Syn",           lection: 3, order: 3,  videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Rodina",        lection: 3, order: 4, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [88]))
        dictionary.append(Word(name: "Brat",          lection: 3, order: 5, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [20, 31]))
        dictionary.append(Word(name: "Sestra",        lection: 3, order: 6, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [18]))
        dictionary.append(Word(name: "Deti",          lection: 3, order: 7, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [23, 27, 29]))
        dictionary.append(Word(name: "Mám",           lection: 3, order: 8, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [18, 54]))
        dictionary.append(Word(name: "Nemám",         lection: 3, order: 9, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [22, 29, 112]))
        dictionary.append(Word(name: "Babka",         lection: 3, order: 10, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [25, 55]))
        dictionary.append(Word(name: "Dedko",         lection: 3, order: 11, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [67]))
        dictionary.append(Word(name: "Dieťa",         lection: 3, order: 12, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [151]))
        dictionary.append(Word(name: "Ženatý/Vydatá", lection: 3, order: 13, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [20, 33]))
        dictionary.append(Word(name: "Slobodný/á",    lection: 3, order: 14, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        
        //Lesson 5 - Rodina II
        dictionary.append(Word(name: "Vnuk",            lection: 4, order: 0,  videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Vnučka",          lection: 4, order: 1,  videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [25, 143]))
        dictionary.append(Word(name: "Manžel/ka",       lection: 4, order: 2,  videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [29, 34]))
        dictionary.append(Word(name: "Rozvedený/á",     lection: 4, order: 3,  videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [26]))
        dictionary.append(Word(name: "Manželia",        lection: 4, order: 4,  videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Frajer/ka",       lection: 4, order: 5,  videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Priateľ/ka",      lection: 4, order: 6,  videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [24, 30]))
        dictionary.append(Word(name: "Druh/Družka",     lection: 4, order: 7,  videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [27, 28]))
        dictionary.append(Word(name: "Teta",            lection: 4, order: 8,  videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [137]))
        dictionary.append(Word(name: "Ujo",             lection: 4, order: 9,  videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Žiť",             lection: 4, order: 10, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [86, 134]))
        dictionary.append(Word(name: "Spolu",           lection: 4, order: 11, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [34, 89]))
        dictionary.append(Word(name: "Rozvod/Rozchod",  lection: 4, order: 12, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Rande",           lection: 4, order: 13, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Láska",           lection: 4, order: 14, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))

        //Lesson 6 - Čísla I.
        dictionary.append(Word(name: "0-5",         lection: 5, order: 0,  videoFront: "sample_2", videoSide: "", inDictionary: false, sentence: [30, 31, 33]))
        dictionary.append(Word(name: "6-10",        lection: 5, order: 1,  videoFront: "sample_2", videoSide: "", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "11-15",       lection: 5, order: 2,  videoFront: "sample_2", videoSide: "", inDictionary: false, sentence: [35]))
        dictionary.append(Word(name: "16-20",       lection: 5, order: 3,  videoFront: "sample_2", videoSide: "", inDictionary: false, sentence: [34]))
        dictionary.append(Word(name: "21-25",       lection: 5, order: 4,  videoFront: "sample_2", videoSide: "", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "26-30",       lection: 5, order: 5,  videoFront: "sample_2", videoSide: "", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "31-35",       lection: 5, order: 6,  videoFront: "sample_2", videoSide: "", inDictionary: false, sentence: [32]))
        dictionary.append(Word(name: "46-50",       lection: 5, order: 7,  videoFront: "sample_2", videoSide: "", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "51-55",       lection: 5, order: 8,  videoFront: "sample_2", videoSide: "", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "66-80",       lection: 5, order: 9,  videoFront: "sample_2", videoSide: "", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "81-85",       lection: 5, order: 10, videoFront: "sample_2", videoSide: "", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "96-99",       lection: 5, order: 11, videoFront: "sample_2", videoSide: "", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "Číslo",       lection: 5, order: 12, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "+/-/*/:/=",   lection: 5, order: 13, videoFront: "sample_2", videoSide: "", inDictionary: false, sentence: [37, 40]))
        dictionary.append(Word(name: "Rokov",       lection: 5, order: 14, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [36, 38, 39]))

        //Lesson 7 - Čísla II.
        dictionary.append(Word(name: "100 - 500",       lection: 6, order: 0, videoFront: "sample_2", videoSide: "", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "600 - 900",       lection: 6, order: 1, videoFront: "sample_2", videoSide: "", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "1000 - 5000",     lection: 6, order: 2, videoFront: "sample_2", videoSide: "", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "6000 - 10000",    lection: 6, order: 3, videoFront: "sample_2", videoSide: "", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "200000 - 50000",  lection: 6, order: 4, videoFront: "sample_2", videoSide: "", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "100 000",         lection: 6, order: 5, videoFront: "sample_2", videoSide: "", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "250 000",         lection: 6, order: 6, videoFront: "sample_2", videoSide: "", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "700 000",         lection: 6, order: 7, videoFront: "sample_2", videoSide: "", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "1 000 000",       lection: 6, order: 8, videoFront: "sample_2", videoSide: "", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "10 000 000",      lection: 6, order: 9, videoFront: "sample_2", videoSide: "", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "Starý",           lection: 6, order: 10, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [39, 54]))
        dictionary.append(Word(name: "Mladý",           lection: 6, order: 11, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [41]))
        dictionary.append(Word(name: "Koľko",           lection: 6, order: 12, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [36]))
        dictionary.append(Word(name: "Správne",         lection: 6, order: 13, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [40]))
        dictionary.append(Word(name: "Nesprávne",       lection: 6, order: 14, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
   
        //Lesson 8 - Materiály a farby I.
        dictionary.append(Word(name: "Farba",       lection: 7, order: 0, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [42, 43, 69]))
        dictionary.append(Word(name: "Biela",       lection: 7, order: 1, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [83]))
        dictionary.append(Word(name: "Žltá",        lection: 7, order: 2, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [44, 69]))
        dictionary.append(Word(name: "Ružová",      lection: 7, order: 3, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Oranžová",    lection: 7, order: 4, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [42]))
        dictionary.append(Word(name: "Červená",     lection: 7, order: 5, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [42, 45]))
        dictionary.append(Word(name: "Fialová",     lection: 7, order: 6, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [42, 92]))
        dictionary.append(Word(name: "Svetlá",      lection: 7, order: 7, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [45]))
        dictionary.append(Word(name: "Tmavá",       lection: 7, order: 8, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [43, 49, 52]))
        dictionary.append(Word(name: "Farebná",     lection: 7, order: 9, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [162]))
        dictionary.append(Word(name: "Milovať",     lection: 7, order: 10, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [44, 45]))
        dictionary.append(Word(name: "Neznášať",    lection: 7, order: 11, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [44, 80]))
        dictionary.append(Word(name: "Pekná",       lection: 7, order: 12, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [42]))
        dictionary.append(Word(name: "Škaredá",     lection: 7, order: 13, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [47]))
        dictionary.append(Word(name: "Moderná",     lection: 7, order: 14, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [52, 53]))
        
        //Lesson 9 - Materiály a farby II.
        dictionary.append(Word(name: "Modrá",       lection: 8, order: 0, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [48, 69]))
        dictionary.append(Word(name: "Hnedá",       lection: 8, order: 1, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [46]))
        dictionary.append(Word(name: "Zelená",      lection: 8, order: 2, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [50]))
        dictionary.append(Word(name: "Sivá",        lection: 8, order: 3, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [52]))
        dictionary.append(Word(name: "Čierna",      lection: 8, order: 4, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [44, 46]))
        dictionary.append(Word(name: "Materiál",    lection: 8, order: 5, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Papier",      lection: 8, order: 6, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Drevo",       lection: 8, order: 7, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [49]))
        dictionary.append(Word(name: "Železo/Kov",  lection: 8, order: 8, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [52]))
        dictionary.append(Word(name: "Sklo",        lection: 8, order: 9, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [53]))
        dictionary.append(Word(name: "Keramika",    lection: 8, order: 10, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [48]))
        dictionary.append(Word(name: "Látka",       lection: 8, order: 11, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Koža",        lection: 8, order: 12, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [51]))
        dictionary.append(Word(name: "Tvrdá",       lection: 8, order: 13, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [51]))
        dictionary.append(Word(name: "Mäkká",       lection: 8, order: 14, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        
        //Lesson 10 - Bývanie I.
        dictionary.append(Word(name: "Byt",         lection: 9, order: 0, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [55, 61]))
        dictionary.append(Word(name: "Dom",         lection: 9, order: 1, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [54, 83]))
        dictionary.append(Word(name: "Panelák",     lection: 9, order: 2, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Doma",        lection: 9, order: 3, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [137]))
        dictionary.append(Word(name: "Domov",       lection: 9, order: 4, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [56]))
        dictionary.append(Word(name: "Sused/ka",    lection: 9, order: 5, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [57, 63]))
        dictionary.append(Word(name: "Izba",        lection: 9, order: 6, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Poschodie",   lection: 9, order: 7, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [64]))
        dictionary.append(Word(name: "Podnájom",    lection: 9, order: 8, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Prenájom",    lection: 9, order: 9, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [59]))
        dictionary.append(Word(name: "Nový",        lection: 9, order: 10, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [65]))
        dictionary.append(Word(name: "Vlastný",     lection: 9, order: 11, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [55]))
        dictionary.append(Word(name: "Kde",         lection: 9, order: 12, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [58]))
        dictionary.append(Word(name: "Kam",         lection: 9, order: 13, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [62]))
        
        //Lesson 11 - Bývanie II.
        dictionary.append(Word(name: "Ubytovanie",  lection: 10, order: 0, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Internát",    lection: 10, order: 1, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [60]))
        dictionary.append(Word(name: "Chata",       lection: 10, order: 2, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [65, 138]))
        dictionary.append(Word(name: "Môže",        lection: 10, order: 3, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Nemôže",      lection: 10, order: 4, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Bývať",       lection: 10, order: 5, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [58, 59, 60]))
        dictionary.append(Word(name: "Prísť",       lection: 10, order: 6, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [113]))
        dictionary.append(Word(name: "Odísť",       lection: 10, order: 7, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [63]))
        dictionary.append(Word(name: "Sťahovať",    lection: 10, order: 8, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Nevštíviť",   lection: 10, order: 9, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Malý",        lection: 10, order: 10, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Veľký",       lection: 10, order: 11, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [61, 70]))
        dictionary.append(Word(name: "Preč",        lection: 10, order: 12, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [63]))
        dictionary.append(Word(name: "Chodiť",      lection: 10, order: 13, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [68, 95, 109]))
        dictionary.append(Word(name: "Isť do",      lection: 10, order: 14, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [62]))
        
        //Lesson 12 - Inštitúcie I.
        dictionary.append(Word(name: "Nemocnica",   lection: 11, order: 0, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [93]))
        dictionary.append(Word(name: "Škola",       lection: 11, order: 1, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [70]))
        dictionary.append(Word(name: "Pošta",       lection: 11, order: 2, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [69]))
        dictionary.append(Word(name: "Polícia",     lection: 11, order: 3, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Televízia",   lection: 11, order: 4, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Kostol",      lection: 11, order: 5, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [83]))
        dictionary.append(Word(name: "Úrad",        lection: 11, order: 6, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [68, 110]))
        dictionary.append(Word(name: "Reštaurácia", lection: 11, order: 7, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [73]))
        dictionary.append(Word(name: "Banka",       lection: 11, order: 8, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Obchod",      lection: 11, order: 9, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [71]))
        dictionary.append(Word(name: "Vedľa",       lection: 11, order: 10, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [75]))
        dictionary.append(Word(name: "Blízko",      lection: 11, order: 11, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [66, 84]))
        dictionary.append(Word(name: "Ďaleko",      lection: 11, order: 12, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [67]))
        dictionary.append(Word(name: "Otvorené",    lection: 11, order: 13, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [73]))
        dictionary.append(Word(name: "Zatvorené",   lection: 11, order: 14, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [70]))
        
        //Lesson 13 - Inštitúcie II.
        dictionary.append(Word(name: "Kino",        lection: 12, order: 0, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [72]))
        dictionary.append(Word(name: "Múzeum",      lection: 12, order: 1, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [73, 75]))
        dictionary.append(Word(name: "Hrad",        lection: 12, order: 2, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Zámok",       lection: 12, order: 3, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [75, 84]))
        dictionary.append(Word(name: "Divadlo",     lection: 12, order: 4, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [74, 109]))
        dictionary.append(Word(name: "Centrum",     lection: 12, order: 5, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [66, 96]))
        dictionary.append(Word(name: "Námestie",    lection: 12, order: 6, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [73]))
        dictionary.append(Word(name: "Ulica",       lection: 12, order: 7, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [7]))
        dictionary.append(Word(name: "Park",        lection: 12, order: 8, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [76]))
        dictionary.append(Word(name: "Hotel",       lection: 12, order: 9, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [76]))
        dictionary.append(Word(name: "Služba",      lection: 12, order: 10, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Firma",       lection: 12, order: 11, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Oproti",      lection: 12, order: 12, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [73]))
        dictionary.append(Word(name: "Všetko",      lection: 12, order: 13, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [127]))
        dictionary.append(Word(name: "Prechádzať",  lection: 12, order: 14, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [76]))
        
        //Lesson 14 - Mestá I.
        dictionary.append(Word(name: "Bratislava", lection: 13, order: 0, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [79]))
        dictionary.append(Word(name: "Košice", lection: 13, order: 1, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [88]))
        dictionary.append(Word(name: "Nitra", lection: 13, order: 2, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [89]))
        dictionary.append(Word(name: "Žilina", lection: 13, order: 3, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [78]))
        dictionary.append(Word(name: "Banská Bystrica", lection: 13, order: 4, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Lučenec", lection: 13, order: 5, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Poprad", lection: 13, order: 06, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [82]))
        dictionary.append(Word(name: "Liptovský Mikuláš", lection: 13, order: 7, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Prešov", lection: 13, order: 8, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [81]))
        dictionary.append(Word(name: "Trnava", lection: 13, order: 9, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Mesto", lection: 13, order: 10, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [81, 96, 99]))
        dictionary.append(Word(name: "Dedina", lection: 13, order: 11, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [80, 83]))
        dictionary.append(Word(name: "Okres", lection: 13, order: 12, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Pekné", lection: 13, order: 13, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [81]))
        dictionary.append(Word(name: "Škaredé", lection: 13, order: 14, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        
        //Lesson 15 - Mestá II.
        dictionary.append(Word(name: "Zvolen", lection: 14, order: 0, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [86]))
        dictionary.append(Word(name: "Trenčín", lection: 14, order: 1, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Prievidza", lection: 14, order: 2, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [84]))
        dictionary.append(Word(name: "Martin", lection: 14, order: 3, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Púchov", lection: 14, order: 4, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Vysoké Tatry", lection: 14, order: 5, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Ružomberok", lection: 14, order: 6, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [87]))
        dictionary.append(Word(name: "Žiar nad Hronom", lection: 14, order: 7, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Dunajská Streda", lection: 14, order: 8, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Piešťany", lection: 14, order: 9, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Chcieť", lection: 14, order: 10, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Nechcieť", lection: 14, order: 11, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [87, 111]))
        dictionary.append(Word(name: "Pochádzať", lection: 14, order: 12, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [88]))
        dictionary.append(Word(name: "Cestovať", lection: 14, order: 13, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Odkiaľ", lection: 14, order: 14, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [85]))
        
   
        //Lesson 16 - Doprava I.
        dictionary.append(Word(name: "Auto", lection: 15, order: 0, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [90, 92, 95]))
        dictionary.append(Word(name: "Motorka", lection: 15, order: 1, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [94]))
        dictionary.append(Word(name: "Autobus", lection: 15, order: 2, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [101]))
        dictionary.append(Word(name: "Vlak", lection: 15, order: 3, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [113]))
        dictionary.append(Word(name: "Trolejbus", lection: 15, order: 4, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Električka", lection: 15, order: 5, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [79]))
        dictionary.append(Word(name: "Lietadlo", lection: 15, order: 6, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Bicykel", lection: 15, order: 7, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [94]))
        dictionary.append(Word(name: "Loď", lection: 15, order: 8, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [91]))
        dictionary.append(Word(name: "Doprava", lection: 15, order: 9, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Jazdiť", lection: 15, order: 10, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [164]))
        dictionary.append(Word(name: "Pomaly", lection: 15, order: 11, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [90, 96]))
        dictionary.append(Word(name: "Rýchlo", lection: 15, order: 12, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [93]))
        dictionary.append(Word(name: "Dráha", lection: 15, order: 13, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Lacná", lection: 15, order: 14, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        
        //Lesson 16 - Doprava II.
        dictionary.append(Word(name: "Metro", lection: 16, order: 0, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [98]))
        dictionary.append(Word(name: "Most", lection: 16, order: 1, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [100]))
        dictionary.append(Word(name: "Diaľnica", lection: 16, order: 2, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Cesta", lection: 16, order: 3, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [153]))
        dictionary.append(Word(name: "Parkovisko", lection: 16, order: 4, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [100]))
        dictionary.append(Word(name: "Taxi", lection: 16, order: 5, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [96]))
        dictionary.append(Word(name: "Semafor", lection: 16, order: 6, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Nehoda", lection: 16, order: 7, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Turbulencia", lection: 16, order: 8, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Rieka", lection: 16, order: 9, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [101]))
        dictionary.append(Word(name: "Šofér", lection: 16, order: 10, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [97]))
        dictionary.append(Word(name: "Pri", lection: 16, order: 11, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Problém", lection: 16, order: 12, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [99]))
        dictionary.append(Word(name: "Pokuta", lection: 16, order: 13, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        
        //Lesson 17 - Čas I.
        dictionary.append(Word(name: "Čas", lection: 17, order: 0, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [102, 105, 112]))
        dictionary.append(Word(name: "Sekudna", lection: 17, order: 1, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Minúta", lection: 17, order: 2, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Hodina", lection: 17, order: 3, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [106, 110]))
        dictionary.append(Word(name: "Hodiny", lection: 17, order: 4, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "1h - 5h", lection: 17, order: 5, videoFront: "sample_2", videoSide: "", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "6h - 10h", lection: 17, order: 6, videoFront: "sample_2", videoSide: "", inDictionary: false, sentence: [102]))
        dictionary.append(Word(name: "11h - 12h", lection: 17, order: 7, videoFront: "sample_2", videoSide: "", inDictionary: false, sentence: [104]))
        dictionary.append(Word(name: "o 1h - o 6h", lection: 17, order: 8, videoFront: "sample_2", videoSide: "", inDictionary: false, sentence: [103]))
        dictionary.append(Word(name: "o 7h - o 12h", lection: 17, order: 9, videoFront: "sample_2", videoSide: "", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "O koľkej", lection: 17, order: 10, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [106]))
        dictionary.append(Word(name: "Kedy", lection: 17, order: 11, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [107]))
        dictionary.append(Word(name: "Meškať", lection: 17, order: 12, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Čakať", lection: 17, order: 13, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [110]))
        dictionary.append(Word(name: "Vstávať", lection: 17, order: 14, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        
        
        //Lesson 19 - Čas II.
        dictionary.append(Word(name: "Práca", lection: 18, order: 0, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [108, 120]))
        dictionary.append(Word(name: "Dovolenka", lection: 18, order: 1, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Voľno", lection: 18, order: 2, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [117]))
        dictionary.append(Word(name: "Teraz", lection: 18, order: 3, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Každý", lection: 18, order: 4, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [108]))
        dictionary.append(Word(name: "Pravidelne", lection: 18, order: 5, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [109]))
        dictionary.append(Word(name: "Nepravidelne", lection: 18, order: 6, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Bude", lection: 18, order: 7, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Bolo", lection: 18, order: 8, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [114]))
        dictionary.append(Word(name: "Jesť", lection: 18, order: 9, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [152]))
        dictionary.append(Word(name: "Odpočívať", lection: 18, order: 10, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Pred", lection: 18, order: 11, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Po", lection: 18, order: 12, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Asi", lection: 18, order: 13, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Až", lection: 18, order: 14, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        
        //Lesson 20 - Kalendár I.
        dictionary.append(Word(name: "Pondelok", lection: 19, order: 0, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Utorok", lection: 19, order: 1, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Streda", lection: 19, order: 2, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Štvrtok", lection: 19, order: 3, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [116]))
        dictionary.append(Word(name: "Piatok", lection: 19, order: 4, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [119]))
        dictionary.append(Word(name: "Sobota", lection: 19, order: 5, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [115]))
        dictionary.append(Word(name: "Nedeľa", lection: 19, order: 6, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [114]))
        dictionary.append(Word(name: "Týždeň", lection: 19, order: 7, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Sviatok", lection: 19, order: 8, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [120]))
        dictionary.append(Word(name: "Dnes", lection: 19, order: 9, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [101, 116]))
        dictionary.append(Word(name: "Včera", lection: 19, order: 10, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [114]))
        dictionary.append(Word(name: "Zajtra", lection: 19, order: 11, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [117]))
        dictionary.append(Word(name: "Kalendár", lection: 19, order: 12, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Prázdniny", lection: 19, order: 13, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Víkend", lection: 19, order: 14, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [118]))
        
        //Lesson 21 - Kalendár II.
        dictionary.append(Word(name: "Január", lection: 20, order: 0, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Február", lection: 20, order: 1, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [121]))
        dictionary.append(Word(name: "Marec", lection: 20, order: 2, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Apríl", lection: 20, order: 3, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [123]))
        dictionary.append(Word(name: "Máj", lection: 20, order: 4, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [120, 124]))
        dictionary.append(Word(name: "Jún", lection: 20, order: 5, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [146]))
        dictionary.append(Word(name: "Júl", lection: 20, order: 6, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [165]))
        dictionary.append(Word(name: "August", lection: 20, order: 7, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [122]))
        dictionary.append(Word(name: "September", lection: 20, order: 8, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Október", lection: 20, order: 9, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "November", lection: 20, order: 10, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "December", lection: 20, order: 11, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Mesiac", lection: 20, order: 12, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [125]))
        dictionary.append(Word(name: "Rok", lection: 20, order: 13, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [125]))
        dictionary.append(Word(name: "Dátum", lection: 20, order: 14, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [120, 121]))
        
        //Lesson 22 - Zvieratá I.
        dictionary.append(Word(name: "Pes", lection: 21, order: 0, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [128]))
        dictionary.append(Word(name: "Mačka", lection: 21, order: 1, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Sliepka", lection: 21, order: 2, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [131]))
        dictionary.append(Word(name: "Krava", lection: 21, order: 3, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [126]))
        dictionary.append(Word(name: "Koza", lection: 21, order: 4, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [131, 133]))
        dictionary.append(Word(name: "Prasa", lection: 21, order: 5, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [127]))
        dictionary.append(Word(name: "Kôn", lection: 21, order: 6, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [126, 133]))
        dictionary.append(Word(name: "Zajac", lection: 21, order: 7, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [131]))
        dictionary.append(Word(name: "Ovca", lection: 21, order: 8, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [126, 133]))
        dictionary.append(Word(name: "Hus", lection: 21, order: 9, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Farma", lection: 21, order: 10, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [129]))
        dictionary.append(Word(name: "Dvor", lection: 21, order: 11, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [130, 132]))
        dictionary.append(Word(name: "Kŕmiť", lection: 21, order: 12, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Strážiť", lection: 21, order: 13, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [128]))
        dictionary.append(Word(name: "Chovať", lection: 21, order: 14, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [126]))
        
        //Lesson 23 - Zvieratá II.
        dictionary.append(Word(name: "Medveď", lection: 22, order: 0, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [136, 139]))
        dictionary.append(Word(name: "Vlk", lection: 22, order: 1, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Jeleň", lection: 22, order: 2, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Srna", lection: 22, order: 3, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [139]))
        dictionary.append(Word(name: "Myš", lection: 22, order: 4, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [135]))
        dictionary.append(Word(name: "Motýľ", lection: 22, order: 5, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [137]))
        dictionary.append(Word(name: "Líška", lection: 22, order: 6, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [139]))
        dictionary.append(Word(name: "Žaba", lection: 22, order: 7, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [138]))
        dictionary.append(Word(name: "Veverička", lection: 22, order: 8, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [134]))
        dictionary.append(Word(name: "Včela", lection: 22, order: 9, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Les", lection: 22, order: 10, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [138]))
        dictionary.append(Word(name: "Zviera", lection: 22, order: 11, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [142]))
        dictionary.append(Word(name: "Strom", lection: 22, order: 12, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [134]))
        dictionary.append(Word(name: "Báť sa", lection: 22, order: 13, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [135, 142]))
        dictionary.append(Word(name: "Dôvod", lection: 22, order: 14, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        
        
        //Lesson 24 - Zvieratá III.
        dictionary.append(Word(name: "Opica", lection: 23, order: 0, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [140]))
        dictionary.append(Word(name: "Gorila", lection: 23, order: 1, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Lev", lection: 23, order: 2, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [141, 145]))
        dictionary.append(Word(name: "Tiger", lection: 23, order: 3, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [141, 145]))
        dictionary.append(Word(name: "Slon", lection: 23, order: 4, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Had", lection: 23, order: 5, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [143]))
        dictionary.append(Word(name: "Krokodil", lection: 23, order: 6, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [145]))
        dictionary.append(Word(name: "Žirafa", lection: 23, order: 7, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Korytnačka", lection: 23, order: 8, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Ťava", lection: 23, order: 9, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "ZOO", lection: 23, order: 10, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [144]))
        dictionary.append(Word(name: "Nebezpečný", lection: 23, order: 11, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [142, 145]))
        dictionary.append(Word(name: "Jedovatý", lection: 23, order: 12, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Hrať", lection: 23, order: 13, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [140]))
        dictionary.append(Word(name: "Niektoré", lection: 23, order: 14, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        
        //Lesson 25 - Ovocie
        dictionary.append(Word(name: "Jablko", lection: 24, order: 0, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [150, 169]))
        dictionary.append(Word(name: "Pomaranč", lection: 24, order: 1, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [149]))
        dictionary.append(Word(name: "Slivka", lection: 24, order: 2, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Mandarinka", lection: 24, order: 3, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Banán", lection: 24, order: 4, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [150]))
        dictionary.append(Word(name: "Čerešne", lection: 24, order: 5, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [147]))
        dictionary.append(Word(name: "Hrozno", lection: 24, order: 6, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [148, 160]))
        dictionary.append(Word(name: "Jahoda", lection: 24, order: 7, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [146]))
        dictionary.append(Word(name: "Hruška", lection: 24, order: 8, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Broskyňa", lection: 24, order: 9, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Sladké", lection: 24, order: 10, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [148]))
        dictionary.append(Word(name: "Kyslé", lection: 24, order: 11, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [148, 156]))
        dictionary.append(Word(name: "Chutné", lection: 24, order: 12, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [149]))
        dictionary.append(Word(name: "Čerstvé", lection: 24, order: 13, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [155]))
        dictionary.append(Word(name: "Ovocie", lection: 24, order: 14, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [151, 152]))
        
        //Lesson 26 - Zelenina
        dictionary.append(Word(name: "Paradjaka", lection: 25, order: 0, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Cibuľa", lection: 25, order: 1, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Paprika", lection: 25, order: 2, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Mrkva", lection: 25, order: 3, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [163]))
        dictionary.append(Word(name: "Kapusta", lection: 25, order: 4, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [156, 163]))
        dictionary.append(Word(name: "Kukurica", lection: 25, order: 5, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Uhorka", lection: 25, order: 6, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Zemiaky", lection: 25, order: 7, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [154]))
        dictionary.append(Word(name: "Cesnak", lection: 25, order: 8, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Hrach", lection: 25, order: 9, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Ošúpať", lection: 25, order: 10, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [154]))
        dictionary.append(Word(name: "Zelenina", lection: 25, order: 11, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [151, 152]))
        dictionary.append(Word(name: "Zdravá", lection: 25, order: 12, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [157]))
        dictionary.append(Word(name: "Tržnica", lection: 25, order: 13, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [155, 156]))
        dictionary.append(Word(name: "Kúpiť", lection: 25, order: 14, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [150]))
        
        //Lesson 27 - Ročné obdobie I.
        dictionary.append(Word(name: "Jar", lection: 26, order: 0, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [158]))
        dictionary.append(Word(name: "Leto", lection: 26, order: 1, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Jeseň", lection: 26, order: 2, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [160, 169]))
        dictionary.append(Word(name: "Zima", lection: 26, order: 3, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [136, 168]))
        dictionary.append(Word(name: "Teplo", lection: 26, order: 4, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Príroda", lection: 26, order: 5, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Záhrada", lection: 26, order: 6, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [163]))
        dictionary.append(Word(name: "Kvet", lection: 26, order: 7, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [158, 159]))
        dictionary.append(Word(name: "Tráva", lection: 26, order: 8, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [161]))
        dictionary.append(Word(name: "Počasie", lection: 26, order: 9, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Krásne", lection: 26, order: 10, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [132, 159]))
        dictionary.append(Word(name: "Sadiť", lection: 26, order: 11, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [158]))
        dictionary.append(Word(name: "Rásť", lection: 26, order: 12, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [161, 169]))
        dictionary.append(Word(name: "Kopať", lection: 26, order: 13, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Oberať", lection: 26, order: 14, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [160]))
        
        //Lesson 28 - Ročné obdobie II.
        dictionary.append(Word(name: "More", lection: 27, order: 0, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Hora", lection: 27, order: 1, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [166]))
        dictionary.append(Word(name: "Horúco", lection: 27, order: 2, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [165]))
        dictionary.append(Word(name: "Jazero", lection: 27, order: 3, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "List", lection: 27, order: 4, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Dážď", lection: 27, order: 5, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Vianoce", lection: 27, order: 6, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [167]))
        dictionary.append(Word(name: "Oblečenie", lection: 27, order: 7, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [168]))
        dictionary.append(Word(name: "Sneh", lection: 27, order: 8, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [164]))
        dictionary.append(Word(name: "Vietor", lection: 27, order: 9, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [166]))
        dictionary.append(Word(name: "Silný", lection: 27, order: 10, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [166]))
        dictionary.append(Word(name: "Slabý", lection: 27, order: 11, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Padať", lection: 27, order: 12, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Tenké", lection: 27, order: 13, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Hrubé", lection: 27, order: 14, videoFront: "sample_2", videoSide: "", inDictionary: true, sentence: [168]))
        
        
        return dictionary;
    }
    
    
}
