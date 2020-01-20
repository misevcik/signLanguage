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
}

struct Lection {
    var id : Int
    var title : String
    var image : String
}


class PreloadCoreData {
    
    private static let DB_VERSION_MAJOR : Int32 = 1
    private static let DB_VERSION_MINOR : Int32 = 0
    
    private var backgroudnContext : NSManagedObjectContext? = nil
    
    init(coreDataStack : CoreDataStack) {
        
        coreDataStack.storeContainer.performBackgroundTask { context in
            
            self.preloadVersion(context: context)
            self.preloadSentences(context: context)
            self.preloadDictionary(context: context)
            self.preloadLections(context: context)
        }
    }
    
    private func preloadVersion(context : NSManagedObjectContext) {
        
        let dbVersion = DBVersion(context: context)
        dbVersion.major = PreloadCoreData.DB_VERSION_MAJOR
        dbVersion.minor = PreloadCoreData.DB_VERSION_MINOR
        
        context.insert(dbVersion)
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
            dbWord.order = Int32(word.order)
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
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true, selector: nil)]
            
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
        lection.append(Lection(id: 28, title: "Abeceda", image: "alphabet" ))
        
        return lection
    }
    
    private func getSentences() -> Array<Sentence> {

        var sentence = Array<Sentence>()
        
        //Lesson 1 - Prvy kontakt I
        sentence.append(Sentence(id: 0, sentence: "On je nepočujúci.", video: "1/0"))
        sentence.append(Sentence(id: 1, sentence: "Som chlapec.", video: "1/1"))
        sentence.append(Sentence(id: 2, sentence: "Dievča je počujúca.", video: "1/2"))
        sentence.append(Sentence(id: 3, sentence: "Rozumieš?", video: "1/3"))
        sentence.append(Sentence(id: 4, sentence: "Ona je nedoslýchavá.", video: "1/4"))
        sentence.append(Sentence(id: 5, sentence: "Ja ti nerozumiem.", video: "1/5"))
        
        //Lesson 2 - - Prvy kontakt II
        sentence.append(Sentence(id: 6, sentence: "Moje meno je Michal.", video: "2/6"))
        sentence.append(Sentence(id: 7, sentence: "Kto som?", video: "2/7"))
        sentence.append(Sentence(id: 8, sentence: "Ako sa máš?", video: "2/8"))
        sentence.append(Sentence(id: 9, sentence: "My sme počujúci.", video: "2/9"))
        sentence.append(Sentence(id: 10, sentence: "Žena je zlá.", video: "2/10"))
        sentence.append(Sentence(id: 11, sentence: "Prepáč, ja ti nerozumiem.", video: "2/11"))
        
        //Lesson 3 - Prvy kontakt III
        sentence.append(Sentence(id: 12, sentence: "Dobre ráno.", video: "3/12"))
        sentence.append(Sentence(id: 13, sentence: "Dobrý deň.", video: "3/13"))
        sentence.append(Sentence(id: 14, sentence: "Dobrý večer!", video: "3/14"))
        sentence.append(Sentence(id: 15, sentence: "Tvoja kamarátka je nepočujúca?", video: "3/15"))
        sentence.append(Sentence(id: 16, sentence: "Ona pozná nepočujúceho muža.", video: "3/16"))
        sentence.append(Sentence(id: 17, sentence: "Moja kolegyňa je nedoslýchavá.", video: "3/17"))
        
        //Lesson 4 - Rodina I
        sentence.append(Sentence(id: 18, sentence: "Mám počujúcu sestru.", video: "4/18"))
        sentence.append(Sentence(id: 19, sentence: "Poznám jeho rodičov.", video: "4/19"))
        sentence.append(Sentence(id: 20, sentence: "Môj brat je ženatý.", video: "4/20"))
        sentence.append(Sentence(id: 21, sentence: "On má nepočujúcu dcéru.", video: "4/21"))
        sentence.append(Sentence(id: 22, sentence: "Nemám súrodencov.", video: "4/22"))
        sentence.append(Sentence(id: 23, sentence: "Moje dieťa v noci spí.", video: "4/23"))
        
        //Lesson 5 - Rodina I
        sentence.append(Sentence(id: 24, sentence: "Mám priateľku.", video: "5/24"))
        sentence.append(Sentence(id: 25, sentence: "Má babka vnučku?", video: "5/25"))
        sentence.append(Sentence(id: 26, sentence: "Moja mama je rozvedená.", video: "5/26"))
        sentence.append(Sentence(id: 27, sentence: "Druh a družka majú deti.", video: "5/27"))
        sentence.append(Sentence(id: 28, sentence: "Ako sa volá tvoj druh?", video: "5/28"))
        sentence.append(Sentence(id: 29, sentence: "Manželia nemajú deti.", video: "5/29"))
        
        //Lesson 6 - Cisla I
        sentence.append(Sentence(id: 30, sentence: "Mám tri kamarátky.", video: "6/30"))
        sentence.append(Sentence(id: 31, sentence: "Mám štyroch bratov.", video: "6/31"))
        sentence.append(Sentence(id: 32, sentence: "Môj otec má 37 rokov.", video: "6/32"))
        sentence.append(Sentence(id: 33, sentence: "Moja kolegyňa je vydatá a má 4 deti.", video: "6/33"))
        sentence.append(Sentence(id: 34, sentence: "Manželia sú spolu už 19 rokov.", video: "6/34"))
        sentence.append(Sentence(id: 35, sentence: "Chlapec má 12 rokov.", video: "6/35"))
        
        //Lesson 7 - Cisla II
        sentence.append(Sentence(id: 36, sentence: "Koľko máš rokov?", video: "7/36"))
        sentence.append(Sentence(id: 37, sentence: "67 – 12 = ?", video: "7/37"))
        sentence.append(Sentence(id: 38, sentence: "Moja sestra má 17 rokov.", video: "7/38"))
        sentence.append(Sentence(id: 39, sentence: "Starý muž má 70 rokov.", video: "7/39"))
        sentence.append(Sentence(id: 40, sentence: "30 + 50 = 80. Je to správne?", video: "7/40"))
        sentence.append(Sentence(id: 41, sentence: "Mladá žena má 27 rokov.", video: "7/41"))
        
        //Lesson 8 - Meterialy a farby I
        sentence.append(Sentence(id: 42, sentence: "Oranžové, fialové a červené farby sú pekné.", video: "8/42"))
        sentence.append(Sentence(id: 43, sentence: "Otec má rád tmavé farby.", video: "8/43"))
        sentence.append(Sentence(id: 44, sentence: "Milujem žltú farbu a neznášam čiernu farbu.", video: "8/44"))
        sentence.append(Sentence(id: 45, sentence: "Milujem svetlú červenú farbu.", video: "8/45"))
        sentence.append(Sentence(id: 46, sentence: "Nemám rád hnedú a čiernu farbu.", video: "8/46"))
        sentence.append(Sentence(id: 47, sentence: "Tá žena je škaredá.", video: "8/47"))
        
        //Lesson 9 - Meterialy a farby II
        sentence.append(Sentence(id: 48, sentence: "Modrá keramika je pekná.", video: "9/48"))
        sentence.append(Sentence(id: 49, sentence: "Mám rád tmavé drevo.", video: "9/49"))
        sentence.append(Sentence(id: 50, sentence: "Jeho žena má rada zelenú farbu.", video: "9/50"))
        sentence.append(Sentence(id: 51, sentence: "Neznášam tvrdú kožu.", video: "9/51"))
        sentence.append(Sentence(id: 52, sentence: "Tmavo sivý kov je pekný a moderný.", video: "9/52"))
        sentence.append(Sentence(id: 53, sentence: "Milujem moderné sklá.", video: "9/53"))
        
        //Lection 10 - Byvanie I.
        sentence.append(Sentence(id: 54, sentence: "Mám starý dom.", video: "10/54"))
        sentence.append(Sentence(id: 55, sentence: "Babka má vlastný byt.", video: "10/55"))
        sentence.append(Sentence(id: 56, sentence: "On sa teší domov.", video: "10/56"))
        sentence.append(Sentence(id: 57, sentence: "Poznáš jej susedku?", video: "10/57"))
        sentence.append(Sentence(id: 58, sentence: "Kde bývaš?", video: "10/58"))
        sentence.append(Sentence(id: 59, sentence: "Môj kolega býva v prenájme.", video: "10/59"))
        
        //Lection 11 - Byvani II
        sentence.append(Sentence(id: 60, sentence: "Bývam na internáte.", video: "11/60"))
        sentence.append(Sentence(id: 61, sentence: "Ja mám veľký byt.", video: "11/61"))
        sentence.append(Sentence(id: 62, sentence: "Kam ideš?", video: "11/62"))
        sentence.append(Sentence(id: 63, sentence: "Susedia v noci odišli preč.", video: "11/63"))
        sentence.append(Sentence(id: 64, sentence: "Na ktorom poschodí bývaš?", video: "11/64"))
        sentence.append(Sentence(id: 65, sentence: "Tvoja chata je stará alebo nová?", video: "11/65"))
        
        //Lection 12 - Institucie I.
        sentence.append(Sentence(id: 66, sentence: "Ideme do centra, je to blízko.", video: "12/66"))
        sentence.append(Sentence(id: 67, sentence: "Môj dedko býva ďaleko.", video: "12/67"))
        sentence.append(Sentence(id: 68, sentence: "Nerád chodím na úrad.", video: "12/68"))
        sentence.append(Sentence(id: 69, sentence: "Pošta má modro-žltú farbu.", video: "12/69"))
        sentence.append(Sentence(id: 70, sentence: "Idem do školy.", video: "12/70"))
        sentence.append(Sentence(id: 71, sentence: "Veľké obchody sú zatvorené.", video: "12/71"))
        
        //Lection 13 - Institucie II.
        sentence.append(Sentence(id: 72, sentence: "Môj otec rád chodí do kina.", video: "13/72"))
        sentence.append(Sentence(id: 73, sentence: "Na námestí sú reštaurácie otvorené.", video: "13/73"))
        sentence.append(Sentence(id: 74, sentence: "Oproti divadlu je múzeum.", video: "13/74"))
        sentence.append(Sentence(id: 75, sentence: "Vedľa múzea je hnedý zámok.", video: "13/75"))
        sentence.append(Sentence(id: 76, sentence: "Rád sa prechádzam v parku.", video: "13/76"))
        sentence.append(Sentence(id: 77, sentence: "Na ulici je tam starý hotel.", video: "13/77"))
        
        //Lection 14 - Mestá I.
        sentence.append(Sentence(id: 78, sentence: "Môj brat býva v Žiline.", video: "14/78"))
        sentence.append(Sentence(id: 79, sentence: "V Bratislave sú staré červeno-žlté električky.", video: "14/79"))
        sentence.append(Sentence(id: 80, sentence: "Neznášam dedinu.", video: "14/80"))
        sentence.append(Sentence(id: 81, sentence: "Prešov je pekné mesto.", video: "14/81"))
        sentence.append(Sentence(id: 82, sentence: "Tešíš sa ísť do Popradu?", video: "14/82"))
        sentence.append(Sentence(id: 83, sentence: "Na dedine sú farebné domy a biely kostol.", video: "14/83"))
        
        //Lection 15 - Mestá II.
        sentence.append(Sentence(id: 84, sentence: "Blízko Prievidze je zámok.", video: "15/84"))
        sentence.append(Sentence(id: 85, sentence: "Odkiaľ si?", video: "15/85"))
        sentence.append(Sentence(id: 86, sentence: "Žijem vo Zvolene.", video: "15/86"))
        sentence.append(Sentence(id: 87, sentence: "Nechcem bývať v Ružomberku.", video: "15/87"))
        sentence.append(Sentence(id: 88, sentence: "Moja rodina pochádza z Košíc.", video: "15/88"))
        sentence.append(Sentence(id: 89, sentence: "Druhovia spolu žijú už 13 rokov v Nitre.", video: "15/89"))
        
        //Lection 16 - Doprava I.
        sentence.append(Sentence(id: 90, sentence: "Auto ide pomaly.", video: "16/90"))
        sentence.append(Sentence(id: 91, sentence: "Plávať loďou.", video: "16/91"))
        sentence.append(Sentence(id: 92, sentence: "Kto má fialové auto?", video: "16/92"))
        sentence.append(Sentence(id: 93, sentence: "Žena išla rýchlo motorkou do nemocnice.", video: "16/93"))
        sentence.append(Sentence(id: 94, sentence: "Môj brat má starý bicykel.", video: "16/94"))
        sentence.append(Sentence(id: 95, sentence: "Rád chodím na starom aute.", video: "16/95"))
        
        //Lection 17 - Doprava II.
        sentence.append(Sentence(id: 96, sentence: "V centre mesta taxík jazdí pomaly.", video: "17/96"))
        sentence.append(Sentence(id: 97, sentence: "Nie som dobrý šofér, ale moja sestra áno.", video: "17/97"))
        sentence.append(Sentence(id: 98, sentence: "V Bratislave nie je metro.", video: "17/98"))
        sentence.append(Sentence(id: 99, sentence: "V centre mesta je problém s parkovaním.", video: "17/99"))
        sentence.append(Sentence(id: 100, sentence: "Stretneme sa na parkovisku pri moste?", video: "17/100"))
        sentence.append(Sentence(id: 101, sentence: "Včera v noci auto a autobus havarovali pri tuneli.", video: "17/101"))
        
        //Lection 18 - Cas I.
        sentence.append(Sentence(id: 102, sentence: "9:03", video: "18/102"))
        sentence.append(Sentence(id: 103, sentence: "6:25", video: "18/103"))
        sentence.append(Sentence(id: 104, sentence: "14:40", video: "18/104"))
        sentence.append(Sentence(id: 105, sentence: "20:30", video: "18/105"))
        sentence.append(Sentence(id: 106, sentence: "Koľko je hodín?", video: "18/106"))
        sentence.append(Sentence(id: 107, sentence: "Ja idem spať o 23 hod.", video: "18/107"))
        
        //Lection 19 - Cas II.
        sentence.append(Sentence(id: 108, sentence: "Každý deň chodím do práce.", video: "19/108"))
        sentence.append(Sentence(id: 109, sentence: "Chodíš pravidelne do divadla?", video: "19/109"))
        sentence.append(Sentence(id: 110, sentence: "Na úrade som čakal 2 hodiny.", video: "19/110"))
        sentence.append(Sentence(id: 111, sentence: "Nechce sa mi.", video: "19/111"))
        sentence.append(Sentence(id: 112, sentence: "Nemám čas.", video: "19/112"))
        sentence.append(Sentence(id: 113, sentence: "Za hodinu príde vlak.", video: "19/113"))
        
        //Lection 20 - Kalendar I.
        sentence.append(Sentence(id: 114, sentence: "Včera bola nedeľa.", video: "20/114"))
        sentence.append(Sentence(id: 115, sentence: "Prídem v sobotu večer.", video: "20/115"))
        sentence.append(Sentence(id: 116, sentence: "Dnes je štvrtok.", video: "20/116"))
        sentence.append(Sentence(id: 117, sentence: "Zajtra budem mať voľno.", video: "20/117"))
        sentence.append(Sentence(id: 118, sentence: "Cez víkend budem u babky.", video: "20/118"))
        sentence.append(Sentence(id: 119, sentence: "V piatok sme mali stretnutie.", video: "20/119"))
        
        //Lection 21 - Kalendar II.
        sentence.append(Sentence(id: 120, sentence: "12.5.2018", video: "21/120"))
        sentence.append(Sentence(id: 121, sentence: "6.2.1980", video: "21/121"))
        sentence.append(Sentence(id: 122, sentence: "20.8.2001", video: "21/122"))
        sentence.append(Sentence(id: 123, sentence: "4.4.1944", video: "21/123"))
        sentence.append(Sentence(id: 124, sentence: "Dňa 1.5. je sviatok práce.", video: "21/124"))
        sentence.append(Sentence(id: 125, sentence: "Rok má 12 mesiacov.", video: "21/125"))
        
        //Lection 22 - Zvierata I.
        sentence.append(Sentence(id: 126, sentence: "Môj dedo choval ovce, kravy aj kone.", video: "22/126"))
        sentence.append(Sentence(id: 127, sentence: "Prasa zje všetko.", video: "22/127"))
        sentence.append(Sentence(id: 128, sentence: "Pes vie dobre strážiť.", video: "22/128"))
        sentence.append(Sentence(id: 129, sentence: "Na dedine je tam veľká farma.", video: "22/129"))
        sentence.append(Sentence(id: 130, sentence: "Babka mojej kamarátky má veľký dvor.", video: "22/130"))
        sentence.append(Sentence(id: 131, sentence: "Chová tam sliepky, husi, zajace a kozy.", video: "22/130"))
        sentence.append(Sentence(id: 132, sentence: "Dedina pri Zolene má krásny dvor. ", video: "22/132"))
        sentence.append(Sentence(id: 133, sentence: "Vo dvore chovajú ovce, kozy a kone.", video: "22/132"))
        
        //Lection 23 - Zvierata II.
        sentence.append(Sentence(id: 134, sentence: "Veverička žije na strome.", video: "23/134"))
        sentence.append(Sentence(id: 135, sentence: "Moja mama sa bojí myší.", video: "23/135"))
        sentence.append(Sentence(id: 136, sentence: "Medveď biely má rád zimu.", video: "23/136"))
        sentence.append(Sentence(id: 137, sentence: "Moja teta doma chová motýle.", video: "23/137"))
        sentence.append(Sentence(id: 138, sentence: "Na chate pri lese sme videli veľa žáb.", video: "23/138"))
        sentence.append(Sentence(id: 139, sentence: "V lese žijú medvede, srnky aj líšky.", video: "23/139"))

        //Lection 24 - Zvierata III.
        sentence.append(Sentence(id: 140, sentence: "Opice sa radi hrajú.", video: "24/140"))
        sentence.append(Sentence(id: 141, sentence: "Lev a tiger nie sú dobrí kamaráti.", video: "24/141"))
        sentence.append(Sentence(id: 142, sentence: "Bojím sa chodiť sama do lesa, lebo sú tam nebezpečné zvieratá.", video: "24/142"))
        sentence.append(Sentence(id: 143, sentence: "Moja vnučka chce mať doma hada.", video: "24/143"))
        sentence.append(Sentence(id: 144, sentence: "Pri Prievidzi je tam ZOO.", video: "24/144"))
        sentence.append(Sentence(id: 145, sentence: "Krokodíl, lev, tiger a niektoré hady sú nebezpečné zvieratá.", video: "24/145"))
        
        //Lection 25 - Ovocie I.
        sentence.append(Sentence(id: 146, sentence: "V Júni bývajú jahody.", video: "25/146"))
        sentence.append(Sentence(id: 147, sentence: "Mamička v nedeľu upiekla čerešňový koláč.", video: "25/147"))
        sentence.append(Sentence(id: 148, sentence: "Hrozno býva kyslé aj sladké.", video: "25/148"))
        sentence.append(Sentence(id: 149, sentence: "Pomaranče mi viac chutia v zime.", video: "25/149"))
        sentence.append(Sentence(id: 150, sentence: "Banány môžeme kúpiť za 1 € a jablká za 80 centov.", video: "25/150"))
        sentence.append(Sentence(id: 151, sentence: "Moje dieťa má radšej ovocie ako zeleninu.", video: "25/151"))
        
        //Lection 26 - Zelenina I.
        sentence.append(Sentence(id: 152, sentence: "Deti musia jesť veľa ovocia a zeleniny.", video: "26/152"))
        sentence.append(Sentence(id: 153, sentence: "Pri ceste predávajú domácu zeleninu.", video: "26/153"))
        sentence.append(Sentence(id: 154, sentence: "Nerád šúpem zemiaky.", video: "26/154"))
        sentence.append(Sentence(id: 155, sentence: "Na trhovisku predávajú čerstvé ovocie.", video: "26/155"))
        sentence.append(Sentence(id: 156, sentence: "Na trhovisku môžem ochutnať kyslú kapustu.", video: "26/156"))
        sentence.append(Sentence(id: 157, sentence: "Rád jem veľa zeleniny, preto som zdravý.", video: "26/157"))
        
        //Lection 27 - Seasson I.
        sentence.append(Sentence(id: 158, sentence: "Na jar sadíme kvety.", video: "27/158"))
        sentence.append(Sentence(id: 159, sentence: "Dievčaťa majú radi krásne kvety.", video: "27/159"))
        sentence.append(Sentence(id: 160, sentence: "Na jeseň sa oberá hrozno.", video: "27/160"))
        sentence.append(Sentence(id: 161, sentence: "Vo dvore rastie tráva.", video: "27/161"))
        sentence.append(Sentence(id: 162, sentence: "Môj priateľ miluje jeseň, lebo je krásne farebná.", video: "27/162"))
        sentence.append(Sentence(id: 163, sentence: "Moji starí rodičia pestujú v záhrade kapustu a mrkvu.", video: "27/163"))
        
        //Lection 28 - Seasson II.
        sentence.append(Sentence(id: 164, sentence: "Nerád jazdím autom, keď je vonku sneh.", video: "28/164"))
        sentence.append(Sentence(id: 165, sentence: "V júli je horúco.", video: "28/165"))
        sentence.append(Sentence(id: 166, sentence: "Na horách bývajú silné vetry.", video: "28/166"))
        sentence.append(Sentence(id: 167, sentence: "Vianoce je krásne obdobie.", video: "28/167"))
        sentence.append(Sentence(id: 168, sentence: "V zime si oblečiem hrubé oblečenie.", video: "28/168"))
        sentence.append(Sentence(id: 169, sentence: "Jablká rastú na jeseň.", video: "28/169"))
        
        return sentence
    }
    
    private func getDictionary() -> Array<Word>{
        
        var dictionary = Array<Word>()
        
        //Lesson 1 - Prvy kontakt I
        dictionary.append(Word(name: "Ahoj",         lection: 0, order: 0,  videoFront: "1/Ahoj", videoSide: "1/Ahoj1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Ja",           lection: 0, order: 1,  videoFront: "1/Ja", videoSide: "1/Ja1", inDictionary: true, sentence: [4, 5, 11]))
        dictionary.append(Word(name: "Ty",           lection: 0, order: 2,  videoFront: "1/Ty", videoSide: "1/Ty1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "On/Ona",       lection: 0, order: 3,  videoFront: "1/OnOna", videoSide: "1/OnOna1", inDictionary: true, sentence: [0, 16]))
        dictionary.append(Word(name: "Áno",          lection: 0, order: 4,  videoFront: "1/Ano", videoSide: "1/Ano1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Nie",          lection: 0, order: 5,  videoFront: "1/Nie", videoSide: "1/Nie1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Nepočujúci",   lection: 0, order: 6,  videoFront: "1/Nepocujuci", videoSide: "1/Nepocujuci1", inDictionary: true, sentence: [0, 15, 16]))
        dictionary.append(Word(name: "Počujúci",     lection: 0, order: 7,  videoFront: "1/Pocujuci", videoSide: "1/Pocujuci1", inDictionary: true, sentence: [2, 9]))
        dictionary.append(Word(name: "Rozumieť",     lection: 0, order: 8,  videoFront: "1/Rozumiet", videoSide: "1/Rozumiet1", inDictionary: true, sentence: [3]))
        dictionary.append(Word(name: "Nerozumieť",   lection: 0, order: 9,  videoFront: "1/Nerozumiet", videoSide: "1/Nerozumiet1", inDictionary: true, sentence: [5, 11]))
        dictionary.append(Word(name: "Nedoslýchaví", lection: 0, order: 10, videoFront: "1/Nedoslychavy", videoSide: "1/Nedoslychavy1", inDictionary: true, sentence: [4, 17]))
        dictionary.append(Word(name: "Muž",          lection: 0, order: 11, videoFront: "1/Muz", videoSide: "1/Muz1", inDictionary: true, sentence: [16]))
        dictionary.append(Word(name: "Žena",         lection: 0, order: 12, videoFront: "1/Zena", videoSide: "1/Zena1", inDictionary: true, sentence: [10]))
        dictionary.append(Word(name: "Chlapec",      lection: 0, order: 13, videoFront: "1/Chlapec", videoSide: "1/Chlapec1", inDictionary: true, sentence: [1]))
        dictionary.append(Word(name: "Dievča",       lection: 0, order: 14, videoFront: "1/Dievca", videoSide: "1/Dievca1", inDictionary: true, sentence: [2]))
        
        //Lesson 2 - - Prvy kontakt II
        dictionary.append(Word(name: "Meno",     lection: 1, order: 0,  videoFront: "2/Meno", videoSide: "2/Meno1", inDictionary: true, sentence: [6]))
        dictionary.append(Word(name: "Moje",     lection: 1, order: 1,  videoFront: "2/Moje", videoSide: "2/Moje1", inDictionary: true, sentence: [6, 17]))
        dictionary.append(Word(name: "Tvoje",    lection: 1, order: 2,  videoFront: "2/Tvoje", videoSide: "2/Tvoje1", inDictionary: true, sentence: [15, 28]))
        dictionary.append(Word(name: "Jeho/Jej", lection: 1, order: 3,  videoFront: "2/JehoJej", videoSide: "2/JehoJej1", inDictionary: true, sentence: [19]))
        dictionary.append(Word(name: "Kto",      lection: 1, order: 4,  videoFront: "2/Kto", videoSide: "2/Kto1", inDictionary: true, sentence: [7]))
        dictionary.append(Word(name: "My",       lection: 1, order: 5,  videoFront: "2/My", videoSide: "2/My1", inDictionary: true, sentence: [9]))
        dictionary.append(Word(name: "Vy",       lection: 1, order: 6,  videoFront: "2/Vy", videoSide: "2/Vy1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Rovnako",  lection: 1, order: 7,  videoFront: "2/Rovnako", videoSide: "2/Rovnako1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Čo",       lection: 1, order: 8,  videoFront: "2/Co", videoSide: "2/Co1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Ako",      lection: 1, order: 9,  videoFront: "2/Ako", videoSide: "2/Ako1", inDictionary: true, sentence: [8]))
        dictionary.append(Word(name: "Alebo",    lection: 1, order: 10, videoFront: "2/Alebo", videoSide: "2/Alebo1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Dobre",    lection: 1, order: 11, videoFront: "2/Dobre", videoSide: "2/Dobre1", inDictionary: true, sentence: [ 12, 13, 14 ]))
        dictionary.append(Word(name: "Zle",      lection: 1, order: 12, videoFront: "2/Zle", videoSide: "2/Zle1", inDictionary: true, sentence: [10]))
        dictionary.append(Word(name: "Prosiť",   lection: 1, order: 13, videoFront: "2/Prosit", videoSide: "2/Prosit1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Prepáč",   lection: 1, order: 14, videoFront: "2/Prepac", videoSide: "2/Prepac1", inDictionary: true, sentence: [11]))
   

        //Lesson 3 - Prvy kontakt III
        dictionary.append(Word(name: "Ráno",            lection: 2, order: 0,  videoFront: "3/Rano", videoSide: "3/Rano1", inDictionary: true, sentence: [12]))
        dictionary.append(Word(name: "Obed",            lection: 2, order: 1,  videoFront: "3/Obed", videoSide: "3/Obed1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Poobede",         lection: 2, order: 2,  videoFront: "3/Poobede", videoSide: "3/Poobede1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Večer",           lection: 2, order: 3,  videoFront: "3/Vecer", videoSide: "3/Vecer1", inDictionary: true, sentence: [14, 115]))
        dictionary.append(Word(name: "Noc",             lection: 2, order: 4,  videoFront: "3/Noc", videoSide: "3/Noc1", inDictionary: true, sentence: [63]))
        dictionary.append(Word(name: "Deň",             lection: 2, order: 5,  videoFront: "3/Den", videoSide: "3/Den1", inDictionary: true, sentence: [13, 108]))
        dictionary.append(Word(name: "Osoba",           lection: 2, order: 6,  videoFront: "3/Osoba", videoSide: "3/Osoba1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Kamarát/ka",      lection: 2, order: 7,  videoFront: "3/Kamarat", videoSide: "3/Kamarat1", inDictionary: true, sentence: [15]))
        dictionary.append(Word(name: "Kolega/Kolegyňa", lection: 2, order: 8,  videoFront: "3/Kolega", videoSide: "3/Kolega1", inDictionary: true, sentence: [17, 59]))
        dictionary.append(Word(name: "Ďakujem",         lection: 2, order: 9,  videoFront: "3/Dakujem", videoSide: "3/Dakujem1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Pozdraviť",       lection: 2, order: 10, videoFront: "3/Pozdravit", videoSide: "3/Pozdravit1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Poznať",          lection: 2, order: 11, videoFront: "3/Poznat", videoSide: "3/Poznat1", inDictionary: true, sentence: [16, 19]))
        dictionary.append(Word(name: "Tešiť sa",        lection: 2, order: 12, videoFront: "3/TesitSa", videoSide: "3/TesitSa1", inDictionary: true, sentence: [82]))
        dictionary.append(Word(name: "Stretnúť",        lection: 2, order: 13, videoFront: "3/Stretnut", videoSide: "3/Stretnut1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Opakovať",        lection: 2, order: 14, videoFront: "3/Opakovat", videoSide: "3/Opakovat1", inDictionary: true, sentence: []))

        //Lesson 4 - Rodina I
        dictionary.append(Word(name: "Mama",          lection: 3, order: 0, videoFront: "4/Mama", videoSide: "4/Mama1", inDictionary: true, sentence: [26]))
        dictionary.append(Word(name: "Otec",          lection: 3, order: 1, videoFront: "4/Otec", videoSide: "4/Otec1", inDictionary: true, sentence: [32, 72]))
        dictionary.append(Word(name: "Dcéra",         lection: 3, order: 2, videoFront: "4/Dcera", videoSide: "4/Dcera1", inDictionary: true, sentence: [21]))
        dictionary.append(Word(name: "Syn",           lection: 3, order: 3,  videoFront: "4/Syn", videoSide: "4/Syn1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Rodina",        lection: 3, order: 4, videoFront: "4/Rodina", videoSide: "4/Rodina1", inDictionary: true, sentence: [88]))
        dictionary.append(Word(name: "Brat",          lection: 3, order: 5, videoFront: "4/Brat", videoSide: "4/Brat1", inDictionary: true, sentence: [20, 31]))
        dictionary.append(Word(name: "Sestra",        lection: 3, order: 6, videoFront: "4/Sestra", videoSide: "4/Sestra1", inDictionary: true, sentence: [18]))
        dictionary.append(Word(name: "Deti",          lection: 3, order: 7, videoFront: "4/Deti", videoSide: "4/Deti1", inDictionary: true, sentence: [23, 27, 29]))
        dictionary.append(Word(name: "Mám",           lection: 3, order: 8, videoFront: "4/Mam", videoSide: "4/Mam1", inDictionary: true, sentence: [18, 54]))
        dictionary.append(Word(name: "Nemám",         lection: 3, order: 9, videoFront: "4/Nemam", videoSide: "4/Nemam1", inDictionary: true, sentence: [22, 112]))
        dictionary.append(Word(name: "Babka",         lection: 3, order: 10, videoFront: "4/Babka", videoSide: "4/Babka1", inDictionary: true, sentence: [25]))
        dictionary.append(Word(name: "Dedko",         lection: 3, order: 11, videoFront: "4/Dedko", videoSide: "4/Dedko1", inDictionary: true, sentence: [67]))
        dictionary.append(Word(name: "Dieťa",         lection: 3, order: 12, videoFront: "4/Dieta", videoSide: "4/Dieta1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Ženatý/Vydatá", lection: 3, order: 13, videoFront: "4/Zenaty", videoSide: "4/Zenaty1", inDictionary: true, sentence: [20, 33]))
        dictionary.append(Word(name: "Slobodný/á",    lection: 3, order: 14, videoFront: "4/Slobodny", videoSide: "4/Slobodny1", inDictionary: true, sentence: []))
        
        //Lesson 5 - Rodina II
        dictionary.append(Word(name: "Vnuk",            lection: 4, order: 0,  videoFront: "5/Vnuk", videoSide: "5/Vnuk1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Vnučka",          lection: 4, order: 1,  videoFront: "5/Vnucka", videoSide: "5/Vnucka1", inDictionary: true, sentence: [25]))
        dictionary.append(Word(name: "Manžel/ka",       lection: 4, order: 2,  videoFront: "5/Manzel", videoSide: "5/Manzel1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Rozvedený/á",     lection: 4, order: 3,  videoFront: "5/Rozvedeny", videoSide: "5/Rozvedeny1", inDictionary: true, sentence: [26]))
        dictionary.append(Word(name: "Manželia",        lection: 4, order: 4,  videoFront: "5/Manzelia", videoSide: "5/Manzelia1", inDictionary: true, sentence: [29, 34]))
        dictionary.append(Word(name: "Frajer/ka",       lection: 4, order: 5,  videoFront: "5/Frajer", videoSide: "5/Frajer1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Priateľ/ka",      lection: 4, order: 6,  videoFront: "5/Priatel", videoSide: "5/Priatel1", inDictionary: true, sentence: [24, 30]))
        dictionary.append(Word(name: "Druh/Družka",     lection: 4, order: 7,  videoFront: "5/Druh", videoSide: "5/Druh1", inDictionary: true, sentence: [27, 28]))
        dictionary.append(Word(name: "Teta",            lection: 4, order: 8,  videoFront: "5/Teta", videoSide: "5/Teta1", inDictionary: true, sentence: [137]))
        dictionary.append(Word(name: "Ujo",             lection: 4, order: 9,  videoFront: "5/Ujo", videoSide: "5/Ujo1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Žiť",             lection: 4, order: 10, videoFront: "5/Zit", videoSide: "5/Zit1", inDictionary: true, sentence: [86]))
        dictionary.append(Word(name: "Spolu",           lection: 4, order: 11, videoFront: "5/Spolu", videoSide: "5/Spolu1", inDictionary: true, sentence: [34]))
        dictionary.append(Word(name: "Rozvod/Rozchod",  lection: 4, order: 12, videoFront: "5/Rozvod", videoSide: "5/Rozvod1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Rande",           lection: 4, order: 13, videoFront: "5/Rande", videoSide: "5/Rande1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Láska",           lection: 4, order: 14, videoFront: "5/Laska", videoSide: "5/Laska1", inDictionary: true, sentence: []))

        //Lesson 6 - Čísla I.
        dictionary.append(Word(name: "0 - 5",       lection: 5, order: 0,  videoFront: "6/0-5", videoSide: "6/0-5a", inDictionary: false, sentence: [30, 31, 33]))
        dictionary.append(Word(name: "6 - 10",      lection: 5, order: 1,  videoFront: "6/6-10", videoSide: "6/6-10a", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "11 - 15",     lection: 5, order: 2,  videoFront: "6/11-15", videoSide: "6/11-15a", inDictionary: false, sentence: [35]))
        dictionary.append(Word(name: "16 - 20",     lection: 5, order: 3,  videoFront: "6/16-20", videoSide: "6/16-20a", inDictionary: false, sentence: [34]))
        dictionary.append(Word(name: "21 - 25",     lection: 5, order: 4,  videoFront: "6/21-25", videoSide: "6/21-25a", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "26 - 30",     lection: 5, order: 5,  videoFront: "6/26-30", videoSide: "6/26-30a", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "31 - 35",     lection: 5, order: 6,  videoFront: "6/31-35", videoSide: "6/31-35a", inDictionary: false, sentence: [32]))
        dictionary.append(Word(name: "46 - 50",     lection: 5, order: 7,  videoFront: "6/46-50", videoSide: "6/46-50a", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "51 - 55",     lection: 5, order: 8,  videoFront: "6/51-55", videoSide: "6/51-55a", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "66 - 70",     lection: 5, order: 9,  videoFront: "6/66-70", videoSide: "6/66-70a", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "81 - 85",     lection: 5, order: 10, videoFront: "6/81-85", videoSide: "6/81-85a", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "96 - 99",     lection: 5, order: 11, videoFront: "6/96-99", videoSide: "6/96-99a", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "Číslo",       lection: 5, order: 12, videoFront: "6/Cislo", videoSide: "6/Cislo1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "+/-/*/:/=",   lection: 5, order: 13, videoFront: "6/Znamienka", videoSide: "6/Znamienka1", inDictionary: false, sentence: [37, 40]))
        dictionary.append(Word(name: "Rokov",       lection: 5, order: 14, videoFront: "6/Rokov", videoSide: "6/Rokov1", inDictionary: true, sentence: [36, 38, 39]))

        //Lesson 7 - Čísla II.
        dictionary.append(Word(name: "100 - 500",       lection: 6, order: 0, videoFront: "7/100-500", videoSide: "7/100-500a", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "600 - 900",       lection: 6, order: 1, videoFront: "7/600-900", videoSide: "7/600-900a", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "1000 - 5000",     lection: 6, order: 2, videoFront: "7/1000-5000", videoSide: "7/1000-5000a", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "6000 - 10000",    lection: 6, order: 3, videoFront: "7/6000-10000", videoSide: "7/6000-10000a", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "200000 - 50000",  lection: 6, order: 4, videoFront: "7/20000-50000", videoSide: "7/20000-50000a", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "100 000",         lection: 6, order: 5, videoFront: "7/100000", videoSide: "7/100000a", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "250 000",         lection: 6, order: 6, videoFront: "7/250000", videoSide: "7/250000a", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "700 000",         lection: 6, order: 7, videoFront: "7/700000", videoSide: "7/700000a", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "1 000 000",       lection: 6, order: 8, videoFront: "7/1000000", videoSide: "7/1000000a", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "10 000 000",      lection: 6, order: 9, videoFront: "7/10000000", videoSide: "7/1000000a", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "Starý",           lection: 6, order: 10, videoFront: "7/Stary", videoSide: "7/Stary1", inDictionary: true, sentence: [39, 54]))
        dictionary.append(Word(name: "Mladý",           lection: 6, order: 11, videoFront: "7/Mlady", videoSide: "7/Mlady1", inDictionary: true, sentence: [41]))
        dictionary.append(Word(name: "Koľko",           lection: 6, order: 12, videoFront: "7/Kolko", videoSide: "7/Kolko1", inDictionary: true, sentence: [36]))
        dictionary.append(Word(name: "Správne",         lection: 6, order: 13, videoFront: "7/Spravne", videoSide: "7/Spravne1", inDictionary: true, sentence: [40]))
        dictionary.append(Word(name: "Nesprávne",       lection: 6, order: 14, videoFront: "7/Nespravne", videoSide: "7/Nespravne1", inDictionary: true, sentence: []))
   
        //Lesson 8 - Materiály a farby I.
        dictionary.append(Word(name: "Farba",       lection: 7, order: 0, videoFront: "8/Farba", videoSide: "8/Farba1", inDictionary: true, sentence: [42, 43, 69]))
        dictionary.append(Word(name: "Biela",       lection: 7, order: 1, videoFront: "8/Biela", videoSide: "8/Biela1", inDictionary: true, sentence: [83]))
        dictionary.append(Word(name: "Žltá",        lection: 7, order: 2, videoFront: "8/Zlta", videoSide: "8/Zlta1", inDictionary: true, sentence: [44, 69]))
        dictionary.append(Word(name: "Ružová",      lection: 7, order: 3, videoFront: "8/Ruzova", videoSide: "8/Ruzova1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Oranžová",    lection: 7, order: 4, videoFront: "8/Oranzova", videoSide: "8/Oranzova1", inDictionary: true, sentence: [42]))
        dictionary.append(Word(name: "Červená",     lection: 7, order: 5, videoFront: "8/Cervena", videoSide: "8/Cervena1", inDictionary: true, sentence: [42, 45]))
        dictionary.append(Word(name: "Fialová",     lection: 7, order: 6, videoFront: "8/Fialova", videoSide: "8/Fialova1", inDictionary: true, sentence: [42, 92]))
        dictionary.append(Word(name: "Svetlá",      lection: 7, order: 7, videoFront: "8/Svetla", videoSide: "8/Svetla1", inDictionary: true, sentence: [45]))
        dictionary.append(Word(name: "Tmavá",       lection: 7, order: 8, videoFront: "8/Tmava", videoSide: "8/Tmava1", inDictionary: true, sentence: [43, 49, 52]))
        dictionary.append(Word(name: "Farebná",     lection: 7, order: 9, videoFront: "8/Farebna", videoSide: "8/Farebna1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Milovať",     lection: 7, order: 10, videoFront: "8/Milovat", videoSide: "8/Milovat1", inDictionary: true, sentence: [44, 45]))
        dictionary.append(Word(name: "Neznášať",    lection: 7, order: 11, videoFront: "8/Neznasat", videoSide: "8/Neznasat1", inDictionary: true, sentence: [44, 80]))
        dictionary.append(Word(name: "Pekná",       lection: 7, order: 12, videoFront: "8/Pekna", videoSide: "8/Pekna1", inDictionary: true, sentence: [42]))
        dictionary.append(Word(name: "Škaredá",     lection: 7, order: 13, videoFront: "8/Skareda", videoSide: "8/Skareda1", inDictionary: true, sentence: [47]))
        dictionary.append(Word(name: "Moderná",     lection: 7, order: 14, videoFront: "8/Moderna", videoSide: "8/Moderna1", inDictionary: true, sentence: [52, 53]))
        
        //Lesson 9 - Materiály a farby II.
        dictionary.append(Word(name: "Modrá",       lection: 8, order: 0, videoFront: "9/Modra", videoSide: "9/Modra1", inDictionary: true, sentence: [48, 69]))
        dictionary.append(Word(name: "Hnedá",       lection: 8, order: 1, videoFront: "9/Hneda", videoSide: "9/Hneda1", inDictionary: true, sentence: [46]))
        dictionary.append(Word(name: "Zelená",      lection: 8, order: 2, videoFront: "9/Zelena", videoSide: "9/Zelena1", inDictionary: true, sentence: [50]))
        dictionary.append(Word(name: "Sivá",        lection: 8, order: 3, videoFront: "9/Siva", videoSide: "9/Siva1", inDictionary: true, sentence: [52]))
        dictionary.append(Word(name: "Čierna",      lection: 8, order: 4, videoFront: "9/Cierna", videoSide: "9/Cierna1", inDictionary: true, sentence: [44, 46]))
        dictionary.append(Word(name: "Materiál",    lection: 8, order: 5, videoFront: "9/Material", videoSide: "9/Material1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Papier",      lection: 8, order: 6, videoFront: "9/Papier", videoSide: "9/Papier1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Drevo",       lection: 8, order: 7, videoFront: "9/Drevo", videoSide: "9/Drevo1", inDictionary: true, sentence: [49]))
        dictionary.append(Word(name: "Železo/Kov",  lection: 8, order: 8, videoFront: "9/Zelezo-Kov", videoSide: "9/Zelezo-Kov1", inDictionary: true, sentence: [52]))
        dictionary.append(Word(name: "Sklo",        lection: 8, order: 9, videoFront: "9/Sklo", videoSide: "9/Sklo1", inDictionary: true, sentence: [53]))
        dictionary.append(Word(name: "Keramika",    lection: 8, order: 10, videoFront: "9/Keramika", videoSide: "9/Keramika1", inDictionary: true, sentence: [48]))
        dictionary.append(Word(name: "Látka",       lection: 8, order: 11, videoFront: "9/Latka", videoSide: "9/Latka1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Koža",        lection: 8, order: 12, videoFront: "9/Koza", videoSide: "9/Koza1", inDictionary: true, sentence: [51]))
        dictionary.append(Word(name: "Tvrdá",       lection: 8, order: 13, videoFront: "9/Tvrda", videoSide: "9/Tvrda1", inDictionary: true, sentence: [51]))
        dictionary.append(Word(name: "Mäkká",       lection: 8, order: 14, videoFront: "9/Makka", videoSide: "9/Makka1", inDictionary: true, sentence: []))
        
        //Lesson 10 - Bývanie I.
        dictionary.append(Word(name: "Byt",         lection: 9, order: 0, videoFront: "10/Byt", videoSide: "10/Byt1", inDictionary: true, sentence: [55, 61]))
        dictionary.append(Word(name: "Dom",         lection: 9, order: 1, videoFront: "10/Dom", videoSide: "10/Dom1", inDictionary: true, sentence: [54, 83]))
        dictionary.append(Word(name: "Panelák",     lection: 9, order: 2, videoFront: "10/Panelak", videoSide: "10/Panelak1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Doma",        lection: 9, order: 3, videoFront: "10/Doma", videoSide: "10/Doma1", inDictionary: true, sentence: [137]))
        dictionary.append(Word(name: "Domov",       lection: 9, order: 4, videoFront: "10/Domov", videoSide: "10/Domov1", inDictionary: true, sentence: [56]))
        dictionary.append(Word(name: "Sused/ka",    lection: 9, order: 5, videoFront: "10/Sused", videoSide: "10/Sused1", inDictionary: true, sentence: [57, 63]))
        dictionary.append(Word(name: "Izba",        lection: 9, order: 6, videoFront: "10/Izba", videoSide: "10/Izba1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Poschodie",   lection: 9, order: 7, videoFront: "10/Poschodie", videoSide: "10/Poschodie1", inDictionary: true, sentence: [64]))
        dictionary.append(Word(name: "Podnájom",    lection: 9, order: 8, videoFront: "10/Podnajom", videoSide: "10/Podnajom1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Prenájom",    lection: 9, order: 9, videoFront: "10/Prenajom", videoSide: "10/Prenajom1", inDictionary: true, sentence: [59]))
        dictionary.append(Word(name: "Nový",        lection: 9, order: 10, videoFront: "10/Novy", videoSide: "10/Novy1", inDictionary: true, sentence: [65]))
        dictionary.append(Word(name: "Vlastný",     lection: 9, order: 11, videoFront: "10/Vlastny", videoSide: "10/Vlastny1", inDictionary: true, sentence: [55]))
        dictionary.append(Word(name: "Bývať",       lection: 9, order: 12, videoFront: "10/Byvat", videoSide: "10/Byvat1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Kde",         lection: 9, order: 13, videoFront: "10/Kde", videoSide: "10/Kde1", inDictionary: true, sentence: [58]))
        dictionary.append(Word(name: "Kam",         lection: 9, order: 14, videoFront: "10/Kam", videoSide: "10/Kam1", inDictionary: true, sentence: [62]))
        
        //Lesson 11 - Bývanie II.
        dictionary.append(Word(name: "Ubytovanie",  lection: 10, order: 0, videoFront: "11/Ubytovanie", videoSide: "11/Ubytovanie1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Internát",    lection: 10, order: 1, videoFront: "11/Internat", videoSide: "11/Internat1", inDictionary: true, sentence: [60]))
        dictionary.append(Word(name: "Chata",       lection: 10, order: 2, videoFront: "11/Chata", videoSide: "11/Chata1", inDictionary: true, sentence: [65]))
        dictionary.append(Word(name: "Môže",        lection: 10, order: 3, videoFront: "11/Moze", videoSide: "11/Moze1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Nemôže",      lection: 10, order: 4, videoFront: "11/Nemoze", videoSide: "11/Nemoze1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Pozemok",     lection: 10, order: 5, videoFront: "11/Pozemok", videoSide: "11/Pozemok1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Prísť",       lection: 10, order: 6, videoFront: "11/Prist", videoSide: "11/Prist1", inDictionary: true, sentence: [113]))
        dictionary.append(Word(name: "Odísť",       lection: 10, order: 7, videoFront: "11/Odist", videoSide: "11/Odist1", inDictionary: true, sentence: [63]))
        dictionary.append(Word(name: "Sťahovať",    lection: 10, order: 8, videoFront: "11/Stahovat", videoSide: "11/Stahovat1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Navštíviť",   lection: 10, order: 9, videoFront: "11/Navstivit", videoSide: "11/Navstivit1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Malý",        lection: 10, order: 10, videoFront: "11/Maly", videoSide: "11/Maly1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Veľký",       lection: 10, order: 11, videoFront: "11/Velky", videoSide: "11/Velky1", inDictionary: true, sentence: [61]))
        dictionary.append(Word(name: "Preč",        lection: 10, order: 12, videoFront: "11/Prec", videoSide: "11/Prec1", inDictionary: true, sentence: [63]))
        dictionary.append(Word(name: "Chodiť",      lection: 10, order: 13, videoFront: "11/Chodit", videoSide: "11/Chodit1", inDictionary: true, sentence: [68, 95, 109]))
        dictionary.append(Word(name: "Isť do",      lection: 10, order: 14, videoFront: "11/IstDo", videoSide: "11/IstDo1", inDictionary: true, sentence: [62, 70]))
        
        //Lesson 12 - Inštitúcie I.
        dictionary.append(Word(name: "Nemocnica",   lection: 11, order: 0, videoFront: "12/Nemocnica", videoSide: "12/Nemocnica1", inDictionary: true, sentence: [93]))
        dictionary.append(Word(name: "Škola",       lection: 11, order: 1, videoFront: "12/Skola", videoSide: "12/Skola1", inDictionary: true, sentence: [70]))
        dictionary.append(Word(name: "Pošta",       lection: 11, order: 2, videoFront: "12/Posta", videoSide: "12/Posta1", inDictionary: true, sentence: [69]))
        dictionary.append(Word(name: "Polícia",     lection: 11, order: 3, videoFront: "12/Policia", videoSide: "12/Policia1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Televízia",   lection: 11, order: 4, videoFront: "12/TV", videoSide: "12/TV1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Kostol",      lection: 11, order: 5, videoFront: "12/Kostol", videoSide: "12/Kostol1", inDictionary: true, sentence: [83]))
        dictionary.append(Word(name: "Úrad",        lection: 11, order: 6, videoFront: "12/Urad", videoSide: "12/Urad1", inDictionary: true, sentence: [68, 110]))
        dictionary.append(Word(name: "Reštaurácia", lection: 11, order: 7, videoFront: "12/Restauracia", videoSide: "12/Restauracia1", inDictionary: true, sentence: [73]))
        dictionary.append(Word(name: "Banka",       lection: 11, order: 8, videoFront: "12/Banka", videoSide: "12/Banka1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Obchod",      lection: 11, order: 9, videoFront: "12/Obchod", videoSide: "12/Obchod1", inDictionary: true, sentence: [71]))
        dictionary.append(Word(name: "Vedľa",       lection: 11, order: 10, videoFront: "12/Vedla", videoSide: "12/Vedla1", inDictionary: true, sentence: [75]))
        dictionary.append(Word(name: "Blízko",      lection: 11, order: 11, videoFront: "12/Blizko", videoSide: "12/Blizko1", inDictionary: true, sentence: [66, 84]))
        dictionary.append(Word(name: "Ďaleko",      lection: 11, order: 12, videoFront: "12/Daleko", videoSide: "12/Daleko1", inDictionary: true, sentence: [67]))
        dictionary.append(Word(name: "Otvorené",    lection: 11, order: 13, videoFront: "12/Otvorene", videoSide: "12/Otvorene1", inDictionary: true, sentence: [73]))
        dictionary.append(Word(name: "Zatvorené",   lection: 11, order: 14, videoFront: "12/Zatvorene", videoSide: "12/Zatvorene1", inDictionary: true, sentence: [71]))
        
        //Lesson 13 - Inštitúcie II.
        dictionary.append(Word(name: "Kino",        lection: 12, order: 0, videoFront: "13/Kino", videoSide: "13/Kino1", inDictionary: true, sentence: [72]))
        dictionary.append(Word(name: "Múzeum",      lection: 12, order: 1, videoFront: "13/Muzeum", videoSide: "13/Muzeum1", inDictionary: true, sentence: [75]))
        dictionary.append(Word(name: "Hrad",        lection: 12, order: 2, videoFront: "13/Hrad", videoSide: "13/Hrad1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Zámok",       lection: 12, order: 3, videoFront: "13/Zamok", videoSide: "13/Zamok1", inDictionary: true, sentence: [75, 84]))
        dictionary.append(Word(name: "Divadlo",     lection: 12, order: 4, videoFront: "13/Divadlo", videoSide: "13/Divadlo1", inDictionary: true, sentence: [74, 109]))
        dictionary.append(Word(name: "Centrum",     lection: 12, order: 5, videoFront: "13/Centrum", videoSide: "13/Centrum1", inDictionary: true, sentence: [66, 96]))
        dictionary.append(Word(name: "Námestie",    lection: 12, order: 6, videoFront: "13/Namestie", videoSide: "13/Namestie1", inDictionary: true, sentence: [73]))
        dictionary.append(Word(name: "Ulica",       lection: 12, order: 7, videoFront: "13/Ulica", videoSide: "13/Ulica1", inDictionary: true, sentence: [77]))
        dictionary.append(Word(name: "Park",        lection: 12, order: 8, videoFront: "13/Park", videoSide: "13/Park1", inDictionary: true, sentence: [76]))
        dictionary.append(Word(name: "Hotel",       lection: 12, order: 9, videoFront: "13/Hotel", videoSide: "13/Hotel1", inDictionary: true, sentence: [77]))
        dictionary.append(Word(name: "Služba",      lection: 12, order: 10, videoFront: "13/Sluzba", videoSide: "13/Sluzba1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Firma",       lection: 12, order: 11, videoFront: "13/Firma", videoSide: "13/Firma1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Oproti",      lection: 12, order: 12, videoFront: "13/Oproti", videoSide: "13/Oproti1", inDictionary: true, sentence: [74]))
        dictionary.append(Word(name: "Všetko",      lection: 12, order: 13, videoFront: "13/Vsetko", videoSide: "13/Vsetko1", inDictionary: true, sentence: [127]))
        dictionary.append(Word(name: "Prechádzať",  lection: 12, order: 14, videoFront: "13/Prechadzat", videoSide: "13/Prechadzat1", inDictionary: true, sentence: [76]))
        
        //Lesson 14 - Mestá I.
        dictionary.append(Word(name: "Bratislava",          lection: 13, order: 0, videoFront: "14/Bratislava", videoSide: "14/Bratislava1", inDictionary: true, sentence: [79]))
        dictionary.append(Word(name: "Blava",               lection: 13, order: 1, videoFront: "14/Blava", videoSide: "14/Blava1", inDictionary: true, sentence: [79]))
        dictionary.append(Word(name: "Košice",              lection: 13, order: 2, videoFront: "14/Kosice", videoSide: "14/Kosice1", inDictionary: true, sentence: [88]))
        dictionary.append(Word(name: "Nitra",               lection: 13, order: 3, videoFront: "14/Nitra", videoSide: "14/Nitra1", inDictionary: true, sentence: [89]))
        dictionary.append(Word(name: "Žilina",              lection: 13, order: 4, videoFront: "14/Zilina", videoSide: "14/Zilina1", inDictionary: true, sentence: [78]))
        dictionary.append(Word(name: "Banská Bystrica",     lection: 13, order: 5, videoFront: "14/BB", videoSide: "14/BB1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Lučenec",             lection: 13, order: 6, videoFront: "14/Lucenec", videoSide: "14/Lucenec1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Poprad",              lection: 13, order: 7, videoFront: "14/Poprad", videoSide: "14/Poprad1", inDictionary: true, sentence: [82]))
        dictionary.append(Word(name: "Liptovský Mikuláš",   lection: 13, order: 8, videoFront: "14/LM", videoSide: "14/LM1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Prešov",              lection: 13, order: 9, videoFront: "14/Presov", videoSide: "14/Presov1", inDictionary: true, sentence: [81]))
        dictionary.append(Word(name: "Trnava",              lection: 13, order: 10, videoFront: "14/Trnava", videoSide: "14/Trnava1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Mesto",               lection: 13, order: 11, videoFront: "14/Mesto", videoSide: "14/Mesto1", inDictionary: true, sentence: [96, 99]))
        dictionary.append(Word(name: "Dedina",              lection: 13, order: 12, videoFront: "14/Dedina", videoSide: "14/Dedina1", inDictionary: true, sentence: [80, 83]))
        dictionary.append(Word(name: "Okres",               lection: 13, order: 13, videoFront: "14/Okres", videoSide: "14/Okres1", inDictionary: true, sentence: []))
//        dictionary.append(Word(name: "Pekné",               lection: 13, order: 13, videoFront: "14/Pekne", videoSide: "14/Pekne1", inDictionary: true, sentence: [81]))
//        dictionary.append(Word(name: "Škaredé",             lection: 13, order: 14, videoFront: "14/Skarede", videoSide: "14/Skarede1", inDictionary: true, sentence: []))
        
        //Lesson 15 - Mestá II.
        dictionary.append(Word(name: "Zvolen",          lection: 14, order: 0, videoFront: "15/Zvolen", videoSide: "15/Zvolen1", inDictionary: true, sentence: [86]))
        dictionary.append(Word(name: "Trenčín",         lection: 14, order: 1, videoFront: "15/Trencin", videoSide: "15/Trencin1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Prievidza",       lection: 14, order: 2, videoFront: "15/Prievidza", videoSide: "15/Prievidza1", inDictionary: true, sentence: [84]))
        dictionary.append(Word(name: "Martin",          lection: 14, order: 3, videoFront: "15/Martin", videoSide: "15/Martin1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Púchov",          lection: 14, order: 4, videoFront: "15/Puchov", videoSide: "15/Puchov1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Vysoké Tatry",    lection: 14, order: 5, videoFront: "15/VT", videoSide: "15/VT1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Ružomberok",      lection: 14, order: 6, videoFront: "15/Ruzomberok", videoSide: "15/Ruzomberok1", inDictionary: true, sentence: [87]))
        dictionary.append(Word(name: "Žiar nad Hronom", lection: 14, order: 7, videoFront: "15/ZH", videoSide: "15/ZH1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Dunajská Streda", lection: 14, order: 8, videoFront: "15/DS", videoSide: "15/DS1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Piešťany",        lection: 14, order: 9, videoFront: "15/Piestany", videoSide: "15/Piestany1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Chcieť",          lection: 14, order: 10, videoFront: "15/Chciet", videoSide: "15/Chciet1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Nechcieť",        lection: 14, order: 11, videoFront: "15/Nechciet", videoSide: "15/Nechciet1", inDictionary: true, sentence: [87]))
        dictionary.append(Word(name: "Pochádzať",       lection: 14, order: 12, videoFront: "15/Pochadzat", videoSide: "15/Pochadzat1", inDictionary: true, sentence: [88]))
        dictionary.append(Word(name: "Cestovať",        lection: 14, order: 13, videoFront: "15/Cestovat", videoSide: "15/Cestovat1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Odkiaľ",          lection: 14, order: 14, videoFront: "15/Odkial", videoSide: "15/Odkial1", inDictionary: true, sentence: [85]))
        
   
        //Lesson 16 - Doprava I.
        dictionary.append(Word(name: "Auto",        lection: 15, order: 0, videoFront: "16/Auto", videoSide: "16/Auto1", inDictionary: true, sentence: [90, 92, 95]))
        dictionary.append(Word(name: "Motorka",     lection: 15, order: 1, videoFront: "16/Motorka", videoSide: "16/Motorka1", inDictionary: true, sentence: [93]))
        dictionary.append(Word(name: "Autobus",     lection: 15, order: 2, videoFront: "16/Autobus", videoSide: "16/Autobus1", inDictionary: true, sentence: [101]))
        dictionary.append(Word(name: "Vlak",        lection: 15, order: 3, videoFront: "16/Vlak", videoSide: "16/Vlak1", inDictionary: true, sentence: [113]))
        dictionary.append(Word(name: "Trolejbus",   lection: 15, order: 4, videoFront: "16/Trolejbus", videoSide: "16/Trolejbus1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Električka",  lection: 15, order: 5, videoFront: "16/Elektricka", videoSide: "16/Elektricka1", inDictionary: true, sentence: [79]))
        dictionary.append(Word(name: "Lietadlo",    lection: 15, order: 6, videoFront: "16/Lietadlo", videoSide: "16/Lietadlo1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Bicykel",     lection: 15, order: 7, videoFront: "16/Bicykel", videoSide: "16/Bicykel1", inDictionary: true, sentence: [94]))
        dictionary.append(Word(name: "Loď",         lection: 15, order: 8, videoFront: "16/Lod", videoSide: "16/Lod1", inDictionary: true, sentence: [91]))
        dictionary.append(Word(name: "Doprava",     lection: 15, order: 9, videoFront: "16/Doprava", videoSide: "16/Doprava1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Jazdiť",      lection: 15, order: 10, videoFront: "16/Jazdit", videoSide: "16/Jazdit1", inDictionary: true, sentence: [164]))
        dictionary.append(Word(name: "Pomaly",      lection: 15, order: 11, videoFront: "16/Pomaly", videoSide: "16/Pomaly1", inDictionary: true, sentence: [90, 96]))
        dictionary.append(Word(name: "Rýchlo",      lection: 15, order: 12, videoFront: "16/Rychlo", videoSide: "16/Rychlo1", inDictionary: true, sentence: [93]))
        dictionary.append(Word(name: "Drahe",       lection: 15, order: 13, videoFront: "16/Drahe", videoSide: "16/Drahe1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Lacne",       lection: 15, order: 14, videoFront: "16/Lacne", videoSide: "16/Lacne1", inDictionary: true, sentence: []))
        
        //Lesson 17 - Doprava II.
        dictionary.append(Word(name: "Metro",       lection: 16, order: 0, videoFront: "17/Metro", videoSide: "17/Metro1", inDictionary: true, sentence: [98]))
        dictionary.append(Word(name: "Most",        lection: 16, order: 1, videoFront: "17/Most", videoSide: "17/Most1", inDictionary: true, sentence: [100]))
        dictionary.append(Word(name: "Diaľnica",    lection: 16, order: 2, videoFront: "17/Dialnica", videoSide: "17/Dialnica1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Cesta",       lection: 16, order: 3, videoFront: "17/Cesta", videoSide: "17/Cesta1", inDictionary: true, sentence: [153]))
        dictionary.append(Word(name: "Parkovisko",  lection: 16, order: 4, videoFront: "17/Parkovisko", videoSide: "17/Parkovisko1", inDictionary: true, sentence: [100]))
        dictionary.append(Word(name: "Taxi",        lection: 16, order: 5, videoFront: "17/Taxi", videoSide: "17/Taxi1", inDictionary: true, sentence: [96]))
        dictionary.append(Word(name: "Semafor",     lection: 16, order: 6, videoFront: "17/Semafor", videoSide: "17/Semafor1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Nehoda",      lection: 16, order: 7, videoFront: "17/Nehoda", videoSide: "17/Nehoda1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Turbulencia", lection: 16, order: 8, videoFront: "17/Turbulencia", videoSide: "17/Turbulencia1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Rieka",       lection: 16, order: 9, videoFront: "17/Rieka", videoSide: "17/Rieka1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Šofér",       lection: 16, order: 10, videoFront: "17/Sofer", videoSide: "17/Sofer1", inDictionary: true, sentence: [97]))
        dictionary.append(Word(name: "Pri",         lection: 16, order: 11, videoFront: "17/Pri", videoSide: "17/Pri1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Problém",     lection: 16, order: 12, videoFront: "17/Problem", videoSide: "17/Problem1", inDictionary: true, sentence: [99]))
        dictionary.append(Word(name: "Pokuta",      lection: 16, order: 13, videoFront: "17/Pokuta", videoSide: "17/Pokuta1", inDictionary: true, sentence: []))
        
        //Lesson 18 - Čas I.
        dictionary.append(Word(name: "Čas",             lection: 17, order: 0, videoFront: "18/Cas", videoSide: "18/Cas1", inDictionary: true, sentence: [105, 107, 112]))
        dictionary.append(Word(name: "Sekudna",         lection: 17, order: 1, videoFront: "18/Sekunda", videoSide: "18/Sekunda1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Minúta",          lection: 17, order: 2, videoFront: "18/Minuta", videoSide: "18/Minuta1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Hodina",          lection: 17, order: 3, videoFront: "18/Hodina", videoSide: "18/Hodina1", inDictionary: true, sentence: [106, 110]))
        dictionary.append(Word(name: "Hodiny",          lection: 17, order: 4, videoFront: "18/Hodiny", videoSide: "18/Hodiny1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "1h - 5h",         lection: 17, order: 5, videoFront: "18/1h-5h", videoSide: "18/1h-5h1", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "6h - 10h",        lection: 17, order: 6, videoFront: "18/6h-10h", videoSide: "18/6h-10h1", inDictionary: false, sentence: [102]))
        dictionary.append(Word(name: "11h - 12h",       lection: 17, order: 7, videoFront: "18/11h-12h", videoSide: "18/11h-12h1", inDictionary: false, sentence: [104]))
        dictionary.append(Word(name: "o 1h - o 6h",     lection: 17, order: 8, videoFront: "18/o1h-6h", videoSide: "18/o1h-6h1", inDictionary: false, sentence: [103]))
        dictionary.append(Word(name: "o 7h - o 12h",    lection: 17, order: 9, videoFront: "18/o7h-12h", videoSide: "18/o7h-12h1", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "O koľkej",        lection: 17, order: 10, videoFront: "18/OKolkej", videoSide: "18/OKolkej1", inDictionary: true, sentence: [106]))
        dictionary.append(Word(name: "Kedy",            lection: 17, order: 11, videoFront: "18/Kedy", videoSide: "18/Kedy1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Meškať",          lection: 17, order: 12, videoFront: "18/Meskat", videoSide: "18/Meskat1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Čakať",           lection: 17, order: 13, videoFront: "18/Cakat", videoSide: "18/Cakat1", inDictionary: true, sentence: [110]))
        dictionary.append(Word(name: "Vstávať",         lection: 17, order: 14, videoFront: "18/Vstavat", videoSide: "18/Vstavat1", inDictionary: true, sentence: []))
        
        
        //Lesson 19 - Čas II.
        dictionary.append(Word(name: "Práca",           lection: 18, order: 0, videoFront: "19/Praca", videoSide: "19/Praca1", inDictionary: true, sentence: [108]))
        dictionary.append(Word(name: "Dovolenka",       lection: 18, order: 1, videoFront: "19/Dovolenka", videoSide: "19/Dovolenka1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Voľno",           lection: 18, order: 2, videoFront: "19/Volno", videoSide: "19/Volno1", inDictionary: true, sentence: [117]))
        dictionary.append(Word(name: "Teraz",           lection: 18, order: 3, videoFront: "19/Teraz", videoSide: "19/Teraz1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Každý",           lection: 18, order: 4, videoFront: "19/Kazdy", videoSide: "19/Kazdy1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Pravidelne",      lection: 18, order: 5, videoFront: "19/Pravidelne", videoSide: "19/Pravidelne1", inDictionary: true, sentence: [109]))
//        dictionary.append(Word(name: "Nepravidelne",    lection: 18, order: 6, videoFront: "19/Nepravidelne", videoSide: "19/Nepravidelne1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Bude",            lection: 18, order: 6, videoFront: "19/Bude", videoSide: "19/Bude1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Bolo",            lection: 18, order: 7, videoFront: "19/Bolo", videoSide: "19/Bolo1", inDictionary: true, sentence: [114]))
        dictionary.append(Word(name: "Jesť",            lection: 18, order: 8, videoFront: "19/Jest", videoSide: "19/Jest1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Odpočívať",       lection: 18, order: 9, videoFront: "19/Odpocivat", videoSide: "19/Odpocivat1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Pred",            lection: 18, order: 10, videoFront: "19/Pred", videoSide: "19/Pred1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Po",              lection: 18, order: 11, videoFront: "19/Po", videoSide: "19/Po1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Asi",             lection: 18, order: 12, videoFront: "19/Asi", videoSide: "19/Asi1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Až",              lection: 18, order: 13, videoFront: "19/Az", videoSide: "19/Az1", inDictionary: true, sentence: []))
        
        //Lesson 20 - Kalendár I.
        dictionary.append(Word(name: "Pondelok",    lection: 19, order: 0, videoFront: "20/Pondelok", videoSide: "20/Pondelok1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Utorok",      lection: 19, order: 1, videoFront: "20/Utorok", videoSide: "20/Utorok1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Streda",      lection: 19, order: 2, videoFront: "20/Streda", videoSide: "20/Streda1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Štvrtok",     lection: 19, order: 3, videoFront: "20/Stvrtok", videoSide: "20/Stvrtok1", inDictionary: true, sentence: [116]))
        dictionary.append(Word(name: "Piatok",      lection: 19, order: 4, videoFront: "20/Piatok", videoSide: "20/Piatok1", inDictionary: true, sentence: [119]))
        dictionary.append(Word(name: "Sobota",      lection: 19, order: 5, videoFront: "20/Sobota", videoSide: "20/Sobota1", inDictionary: true, sentence: [115]))
        dictionary.append(Word(name: "Nedeľa",      lection: 19, order: 6, videoFront: "20/Nedela", videoSide: "20/Nedela1", inDictionary: true, sentence: [114]))
        dictionary.append(Word(name: "Týždeň",      lection: 19, order: 7, videoFront: "20/Tyzden", videoSide: "20/Tyzden1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Sviatok",     lection: 19, order: 8, videoFront: "20/Sviatok", videoSide: "20/Sviatok1", inDictionary: true, sentence: [124]))
        dictionary.append(Word(name: "Dnes",        lection: 19, order: 9, videoFront: "20/Dnes", videoSide: "20/Dnes1", inDictionary: true, sentence: [116]))
        dictionary.append(Word(name: "Včera",       lection: 19, order: 10, videoFront: "20/Vcera", videoSide: "20/Vcera1", inDictionary: true, sentence: [114]))
        dictionary.append(Word(name: "Zajtra",      lection: 19, order: 11, videoFront: "20/Zajtra", videoSide: "20/Zajtra1", inDictionary: true, sentence: [117]))
        dictionary.append(Word(name: "Kalendár",    lection: 19, order: 12, videoFront: "20/Kalendar", videoSide: "20/Kalendar1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Prázdniny",   lection: 19, order: 13, videoFront: "20/Prazdniny", videoSide: "20/Prazdniny1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Víkend",      lection: 19, order: 14, videoFront: "20/Vikend", videoSide: "20/Vikend1", inDictionary: true, sentence: [118]))
        
        //Lesson 21 - Kalendár II.
        dictionary.append(Word(name: "Január",      lection: 20, order: 0, videoFront: "21/Januar", videoSide: "21/Januar1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Február",     lection: 20, order: 1, videoFront: "21/Februar", videoSide: "21/Februar1", inDictionary: true, sentence: [121]))
        dictionary.append(Word(name: "Marec",       lection: 20, order: 2, videoFront: "21/Marec", videoSide: "21/Marec1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Apríl",       lection: 20, order: 3, videoFront: "21/April", videoSide: "21/April1", inDictionary: true, sentence: [123]))
        dictionary.append(Word(name: "Máj",         lection: 20, order: 4, videoFront: "21/Maj", videoSide: "21/Maj1", inDictionary: true, sentence: [120, 124]))
        dictionary.append(Word(name: "Jún",         lection: 20, order: 5, videoFront: "21/Jun", videoSide: "21/Jun1", inDictionary: true, sentence: [146]))
        dictionary.append(Word(name: "Júl",         lection: 20, order: 6, videoFront: "21/Jul", videoSide: "21/Jul1", inDictionary: true, sentence: [165]))
        dictionary.append(Word(name: "August",      lection: 20, order: 7, videoFront: "21/August", videoSide: "21/August1", inDictionary: true, sentence: [122]))
        dictionary.append(Word(name: "September",   lection: 20, order: 8, videoFront: "21/September", videoSide: "21/September1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Október",     lection: 20, order: 9, videoFront: "21/Oktober", videoSide: "21/Oktober1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "November",    lection: 20, order: 10, videoFront: "21/November", videoSide: "21/November1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "December",    lection: 20, order: 11, videoFront: "21/December", videoSide: "21/December1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Mesiac",      lection: 20, order: 12, videoFront: "21/Mesiac", videoSide: "21/Mesiac1", inDictionary: true, sentence: [125]))
        dictionary.append(Word(name: "Rok",         lection: 20, order: 13, videoFront: "21/Rok", videoSide: "21/Rok1", inDictionary: true, sentence: [125]))
        dictionary.append(Word(name: "Dátum",       lection: 20, order: 14, videoFront: "21/Datum", videoSide: "21/Datum1", inDictionary: true, sentence: [120, 121]))
        
        //Lesson 22 - Zvieratá I.
        dictionary.append(Word(name: "Pes",     lection: 21, order: 0, videoFront: "22/Pes", videoSide: "22/Pes1", inDictionary: true, sentence: [128]))
        dictionary.append(Word(name: "Mačka",   lection: 21, order: 1, videoFront: "22/Macka", videoSide: "22/Macka1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Sliepka", lection: 21, order: 2, videoFront: "22/Sliepka", videoSide: "22/Sliepka1", inDictionary: true, sentence: [131]))
        dictionary.append(Word(name: "Krava",   lection: 21, order: 3, videoFront: "22/Krava", videoSide: "22/Krava1", inDictionary: true, sentence: [126]))
        dictionary.append(Word(name: "Koza",    lection: 21, order: 4, videoFront: "22/Koza", videoSide: "22/Koza1", inDictionary: true, sentence: [131, 133]))
        dictionary.append(Word(name: "Prasa",   lection: 21, order: 5, videoFront: "22/Prasa", videoSide: "22/Prasa1", inDictionary: true, sentence: [127]))
        dictionary.append(Word(name: "Kôn",     lection: 21, order: 6, videoFront: "22/Kon", videoSide: "22/Kon1", inDictionary: true, sentence: [126, 133]))
        dictionary.append(Word(name: "Zajac",   lection: 21, order: 7, videoFront: "22/Zajac", videoSide: "22/Zajac1", inDictionary: true, sentence: [131]))
        dictionary.append(Word(name: "Ovca",    lection: 21, order: 8, videoFront: "22/Ovca", videoSide: "22/Ovca1", inDictionary: true, sentence: [126, 133]))
        dictionary.append(Word(name: "Hus",     lection: 21, order: 9, videoFront: "22/Hus", videoSide: "22/Hus1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Farma",   lection: 21, order: 10, videoFront: "22/Farma", videoSide: "22/Farma1", inDictionary: true, sentence: [129]))
        dictionary.append(Word(name: "Dvor",    lection: 21, order: 11, videoFront: "22/Dvor", videoSide: "22/Dvor1", inDictionary: true, sentence: [130, 132]))
        dictionary.append(Word(name: "Kŕmiť",   lection: 21, order: 12, videoFront: "22/Krmit", videoSide: "22/Krmit1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Strážiť", lection: 21, order: 13, videoFront: "22/Strazit", videoSide: "22/Strazit1", inDictionary: true, sentence: [128]))
        dictionary.append(Word(name: "Chovať",  lection: 21, order: 14, videoFront: "22/Chovat", videoSide: "22/Chovat1", inDictionary: true, sentence: [126]))
        
        //Lesson 23 - Zvieratá II.
        dictionary.append(Word(name: "Medveď",      lection: 22, order: 0, videoFront: "23/Medved", videoSide: "23/Medved1", inDictionary: true, sentence: [136, 139]))
        dictionary.append(Word(name: "Vlk",         lection: 22, order: 1, videoFront: "23/Vlk", videoSide: "23/Vlk1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Jeleň",       lection: 22, order: 2, videoFront: "23/Jelen", videoSide: "23/Jelen1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Srna",        lection: 22, order: 3, videoFront: "23/Srna", videoSide: "23/Srna1", inDictionary: true, sentence: [139]))
        dictionary.append(Word(name: "Myš",         lection: 22, order: 4, videoFront: "23/Mys", videoSide: "23/Mys1", inDictionary: true, sentence: [135]))
        dictionary.append(Word(name: "Motýľ",       lection: 22, order: 5, videoFront: "23/Motyl", videoSide: "23/Motyl1", inDictionary: true, sentence: [137]))
        dictionary.append(Word(name: "Líška",       lection: 22, order: 6, videoFront: "23/Liska", videoSide: "23/Liska1", inDictionary: true, sentence: [139]))
        dictionary.append(Word(name: "Žaba",        lection: 22, order: 7, videoFront: "23/Zaba", videoSide: "23/Zaba1", inDictionary: true, sentence: [138]))
        dictionary.append(Word(name: "Veverička",   lection: 22, order: 8, videoFront: "23/Vevericka", videoSide: "23/Vevericka1", inDictionary: true, sentence: [134]))
        dictionary.append(Word(name: "Včela",       lection: 22, order: 9, videoFront: "23/Vcela", videoSide: "23/Vcela1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Les",         lection: 22, order: 10, videoFront: "23/Les", videoSide: "23/Les1", inDictionary: true, sentence: [138]))
        dictionary.append(Word(name: "Zviera",      lection: 22, order: 11, videoFront: "23/Zviera", videoSide: "23/Zviera1", inDictionary: true, sentence: [142]))
        dictionary.append(Word(name: "Strom",       lection: 22, order: 12, videoFront: "23/Strom", videoSide: "23/Strom1", inDictionary: true, sentence: [134]))
        dictionary.append(Word(name: "Báť sa",      lection: 22, order: 13, videoFront: "23/BatSa", videoSide: "23/BatSa1", inDictionary: true, sentence: [135, 142]))
        dictionary.append(Word(name: "Dôvod",        lection: 22, order: 14, videoFront: "23/Dovod", videoSide: "23/Dovod1", inDictionary: true, sentence: []))
        
        
        //Lesson 24 - Zvieratá III.
        dictionary.append(Word(name: "Opica",       lection: 23, order: 0, videoFront: "24/Opica", videoSide: "24/Opica1", inDictionary: true, sentence: [140]))
        dictionary.append(Word(name: "Gorila",      lection: 23, order: 1, videoFront: "24/Gorila", videoSide: "24/Gorila1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Lev",         lection: 23, order: 2, videoFront: "24/Lev", videoSide: "24/Lev1", inDictionary: true, sentence: [141, 145]))
        dictionary.append(Word(name: "Tiger",       lection: 23, order: 3, videoFront: "24/Tiger", videoSide: "24/Tiger1", inDictionary: true, sentence: [141, 145]))
        dictionary.append(Word(name: "Slon",        lection: 23, order: 4, videoFront: "24/Slon", videoSide: "24/Slon1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Had",         lection: 23, order: 5, videoFront: "24/Had", videoSide: "24/Had1", inDictionary: true, sentence: [143]))
        dictionary.append(Word(name: "Krokodil",    lection: 23, order: 6, videoFront: "24/Krokodil", videoSide: "24/Krokodil1", inDictionary: true, sentence: [145]))
        dictionary.append(Word(name: "Žirafa",      lection: 23, order: 7, videoFront: "24/Zirafa", videoSide: "24/Zirafa1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Korytnačka",  lection: 23, order: 8, videoFront: "24/Korytnacka", videoSide: "24/Korytnacka1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Ťava",        lection: 23, order: 9, videoFront: "24/Tava", videoSide: "24/Tava1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "ZOO",         lection: 23, order: 10, videoFront: "24/ZOO", videoSide: "24/ZOO1", inDictionary: true, sentence: [144]))
        dictionary.append(Word(name: "Nebezpečný",  lection: 23, order: 11, videoFront: "24/Nebezpecny", videoSide: "24/Nebezpecny1", inDictionary: true, sentence: [142, 145]))
        dictionary.append(Word(name: "Jedovatý",    lection: 23, order: 12, videoFront: "24/Jedovaty", videoSide: "24/Jedovaty1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Hrať",        lection: 23, order: 13, videoFront: "24/Hrat", videoSide: "24/Hrat1", inDictionary: true, sentence: [140]))
        dictionary.append(Word(name: "Niektoré",    lection: 23, order: 14, videoFront: "24/Niektore", videoSide: "24/Niektore1", inDictionary: true, sentence: []))
        
        //Lesson 25 - Ovocie
        dictionary.append(Word(name: "Jablko",      lection: 24, order: 0, videoFront: "25/Jablko", videoSide: "25/Jablko1", inDictionary: true, sentence: [150, 169]))
        dictionary.append(Word(name: "Pomaranč",    lection: 24, order: 1, videoFront: "25/Pomaranc", videoSide: "25/Pomaranc1", inDictionary: true, sentence: [149]))
        dictionary.append(Word(name: "Slivka",      lection: 24, order: 2, videoFront: "25/Slivka", videoSide: "25/Slivka1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Citron",      lection: 24, order: 3, videoFront: "25/Citron", videoSide: "25/Citron1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Banán",       lection: 24, order: 4, videoFront: "25/Banan", videoSide: "25/Banan1", inDictionary: true, sentence: [150]))
        dictionary.append(Word(name: "Čerešne",     lection: 24, order: 5, videoFront: "25/Ceresne", videoSide: "25/Ceresne1", inDictionary: true, sentence: [147]))
        dictionary.append(Word(name: "Hrozno",      lection: 24, order: 6, videoFront: "25/Hrozno", videoSide: "25/Hrozno1", inDictionary: true, sentence: [148, 160]))
        dictionary.append(Word(name: "Jahoda",      lection: 24, order: 7, videoFront: "25/Jahoda", videoSide: "25/Jahoda1", inDictionary: true, sentence: [146]))
        dictionary.append(Word(name: "Hruška",      lection: 24, order: 8, videoFront: "25/Hruska", videoSide: "25/Hruska1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Broskyňa",    lection: 24, order: 9, videoFront: "25/Broskyna", videoSide: "25/Broskyna1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Sladké",      lection: 24, order: 10, videoFront: "25/Sladke", videoSide: "25/Sladke1", inDictionary: true, sentence: [148]))
        dictionary.append(Word(name: "Kyslé",       lection: 24, order: 11, videoFront: "25/Kysle", videoSide: "25/Kysle1", inDictionary: true, sentence: [148, 156]))
        dictionary.append(Word(name: "Chutné",      lection: 24, order: 12, videoFront: "25/Chutne", videoSide: "25/Chutne1", inDictionary: true, sentence: [149]))
        dictionary.append(Word(name: "Čerstvé",     lection: 24, order: 13, videoFront: "25/Cerstve", videoSide: "25/Cerstve1", inDictionary: true, sentence: [155]))
        dictionary.append(Word(name: "Ovocie",      lection: 24, order: 14, videoFront: "25/Ovocie", videoSide: "25/Ovocie1", inDictionary: true, sentence: [151, 152]))
        
        //Lesson 26 - Zelenina
        dictionary.append(Word(name: "Paradjaka",   lection: 25, order: 0, videoFront: "26/Paradajka", videoSide: "26/Paradajka1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Cibuľa",      lection: 25, order: 1, videoFront: "26/Cibula", videoSide: "26/Cibula1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Paprika",     lection: 25, order: 2, videoFront: "26/Paprika", videoSide: "26/Paprika1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Mrkva",       lection: 25, order: 3, videoFront: "26/Mrkva", videoSide: "26/Mrkva1", inDictionary: true, sentence: [163]))
        dictionary.append(Word(name: "Kapusta",     lection: 25, order: 4, videoFront: "26/Kapusta", videoSide: "26/Kapusta1", inDictionary: true, sentence: [156, 163]))
        dictionary.append(Word(name: "Kukurica",    lection: 25, order: 5, videoFront: "26/Kukurica", videoSide: "26/Kukurica1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Uhorka",      lection: 25, order: 6, videoFront: "26/Uhorka", videoSide: "26/Uhorka1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Zemiaky",     lection: 25, order: 7, videoFront: "26/Zemiaky", videoSide: "26/Zemiaky1", inDictionary: true, sentence: [154]))
        dictionary.append(Word(name: "Cesnak",      lection: 25, order: 8, videoFront: "26/Cesnak", videoSide: "26/Cesnak1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Hrach",       lection: 25, order: 9, videoFront: "26/Hrach", videoSide: "26/Hrach1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Ošúpať",      lection: 25, order: 10, videoFront: "26/Osupat", videoSide: "26/Osupat1", inDictionary: true, sentence: [154]))
        dictionary.append(Word(name: "Zelenina",    lection: 25, order: 11, videoFront: "26/Zelenina", videoSide: "26/Zelenina1", inDictionary: true, sentence: [151, 152]))
        dictionary.append(Word(name: "Zdravá",      lection: 25, order: 12, videoFront: "26/Zdrava", videoSide: "26/Zdrava1", inDictionary: true, sentence: [157]))
        dictionary.append(Word(name: "Tržnica",     lection: 25, order: 13, videoFront: "26/Trznica", videoSide: "26/Trznica1", inDictionary: true, sentence: [155, 156]))
        dictionary.append(Word(name: "Kúpiť",       lection: 25, order: 14, videoFront: "26/Kupit", videoSide: "26/Kupit1", inDictionary: true, sentence: [150]))
        
        //Lesson 27 - Ročné obdobie I.
        dictionary.append(Word(name: "Jar",     lection: 26, order: 0, videoFront: "27/Jar", videoSide: "27/Jar1", inDictionary: true, sentence: [158]))
        dictionary.append(Word(name: "Leto",    lection: 26, order: 1, videoFront: "27/Leto", videoSide: "27/Leto1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Jeseň",   lection: 26, order: 2, videoFront: "27/Jesen", videoSide: "27/Jesen1", inDictionary: true, sentence: [160, 169]))
        dictionary.append(Word(name: "Zima",    lection: 26, order: 3, videoFront: "27/Zima", videoSide: "27/Zima1", inDictionary: true, sentence: [136, 168]))
        dictionary.append(Word(name: "Teplo",   lection: 26, order: 4, videoFront: "27/Teplo", videoSide: "27/Teplo1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Príroda", lection: 26, order: 5, videoFront: "27/Priroda", videoSide: "27/Priroda1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Záhrada", lection: 26, order: 6, videoFront: "27/Zahrada", videoSide: "27/Zahrada1", inDictionary: true, sentence: [163]))
        dictionary.append(Word(name: "Kvet",    lection: 26, order: 7, videoFront: "27/Kvet", videoSide: "27/Kvet1", inDictionary: true, sentence: [158, 159]))
        dictionary.append(Word(name: "Tráva",   lection: 26, order: 8, videoFront: "27/Trava", videoSide: "27/Trava1", inDictionary: true, sentence: [161]))
        dictionary.append(Word(name: "Počasie", lection: 26, order: 9, videoFront: "27/Pocasie", videoSide: "27/Pocasie1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Krásne",  lection: 26, order: 10, videoFront: "27/Krasne", videoSide: "27/Krasne1", inDictionary: true, sentence: [132, 159]))
        dictionary.append(Word(name: "Sadiť",   lection: 26, order: 11, videoFront: "27/Sadit", videoSide: "27/Sadit1", inDictionary: true, sentence: [158]))
        dictionary.append(Word(name: "Rásť",    lection: 26, order: 12, videoFront: "27/Rast", videoSide: "27/Rast1", inDictionary: true, sentence: [161, 169]))
        dictionary.append(Word(name: "Kopať",   lection: 26, order: 13, videoFront: "27/Kopat", videoSide: "27/Kopat1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Oberať",  lection: 26, order: 14, videoFront: "27/Oberat", videoSide: "27/Oberat1", inDictionary: true, sentence: [160]))
        
        //Lesson 28 - Ročné obdobie II.
        dictionary.append(Word(name: "More",        lection: 27, order: 0, videoFront: "28/More", videoSide: "28/More1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Hora",        lection: 27, order: 1, videoFront: "28/Hora", videoSide: "28/Hora1", inDictionary: true, sentence: [166]))
        dictionary.append(Word(name: "Horúco",      lection: 27, order: 2, videoFront: "28/Horuco", videoSide: "28/Horuco1", inDictionary: true, sentence: [165]))
        dictionary.append(Word(name: "Jazero",      lection: 27, order: 3, videoFront: "28/Jazero", videoSide: "28/Jazero1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "List",        lection: 27, order: 4, videoFront: "28/List", videoSide: "28/List1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Dážď",        lection: 27, order: 5, videoFront: "28/Dazd", videoSide: "28/Dazd1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Vianoce",     lection: 27, order: 6, videoFront: "28/Vianoce", videoSide: "28/Vianoce1", inDictionary: true, sentence: [167]))
        dictionary.append(Word(name: "Oblečenie",   lection: 27, order: 7, videoFront: "28/Oblecenie", videoSide: "28/Oblecenie1", inDictionary: true, sentence: [168]))
        dictionary.append(Word(name: "Sneh",        lection: 27, order: 8, videoFront: "28/Sneh", videoSide: "28/Sneh1", inDictionary: true, sentence: [164]))
        dictionary.append(Word(name: "Vietor",      lection: 27, order: 9, videoFront: "28/Vietor", videoSide: "28/Vietor1", inDictionary: true, sentence: [166]))
        dictionary.append(Word(name: "Silný",       lection: 27, order: 10, videoFront: "28/Silny", videoSide: "28/Silny1", inDictionary: true, sentence: [166]))
        dictionary.append(Word(name: "Slabý",       lection: 27, order: 11, videoFront: "28/Slaby", videoSide: "28/Slaby1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Padať",       lection: 27, order: 12, videoFront: "28/Padat", videoSide: "28/Padat1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Tenké",       lection: 27, order: 13, videoFront: "28/Tenke", videoSide: "28/Tenke1", inDictionary: true, sentence: []))
        dictionary.append(Word(name: "Hrubé",       lection: 27, order: 14, videoFront: "28/Hrube", videoSide: "28/Hrube1", inDictionary: true, sentence: [168]))
        
        //Lesson 29 - ABECEDA
        dictionary.append(Word(name: "A, Á, Ä", lection: 28, order: 0, videoFront: "29/A", videoSide: "29/A1", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "B",       lection: 28, order: 1, videoFront: "29/B", videoSide: "29/B1", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "C, Č",    lection: 28, order: 2, videoFront: "29/C", videoSide: "29/C1", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "D, Ď",    lection: 28, order: 3, videoFront: "29/D", videoSide: "29/D1", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "E, É",    lection: 28, order: 4, videoFront: "29/E", videoSide: "29/E1", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "F",       lection: 28, order: 5, videoFront: "29/F", videoSide: "29/F1", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "G",       lection: 28, order: 6, videoFront: "29/G", videoSide: "29/G1", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "H, CH",   lection: 28, order: 7, videoFront: "29/H", videoSide: "29/H1", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "I, Í",    lection: 28, order: 8, videoFront: "29/I", videoSide: "29/I1", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "J",       lection: 28, order: 9, videoFront: "29/J", videoSide: "29/J1", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "K",       lection: 28, order: 10, videoFront: "29/K", videoSide: "29/K1", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "L, Ĺ, Ľ", lection: 28, order: 11, videoFront: "29/L", videoSide: "29/L1", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "M",       lection: 28, order: 12, videoFront: "29/M", videoSide: "29/M1", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "N, Ň",    lection: 28, order: 13, videoFront: "29/N", videoSide: "29/N1", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "O, Ó, Ô", lection: 28, order: 14, videoFront: "29/O", videoSide: "29/O1", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "P",       lection: 28, order: 15, videoFront: "29/P", videoSide: "29/P1", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "Q",       lection: 28, order: 16, videoFront: "29/Q", videoSide: "29/Q1", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "R, Ŕ",    lection: 28, order: 17, videoFront: "29/R", videoSide: "29/R1", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "S, Š",    lection: 28, order: 18, videoFront: "29/S", videoSide: "29/S1", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "T, Ť",    lection: 28, order: 19, videoFront: "29/T", videoSide: "29/T1", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "U, Ú",    lection: 28, order: 20, videoFront: "29/U", videoSide: "29/U1", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "V, W",    lection: 28, order: 21, videoFront: "29/V", videoSide: "29/V1", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "X",       lection: 28, order: 22, videoFront: "29/X", videoSide: "29/X1", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "Y, Ý",    lection: 28, order: 23, videoFront: "29/Y", videoSide: "29/Y1", inDictionary: false, sentence: []))
        dictionary.append(Word(name: "Z, Ž",    lection: 28, order: 24, videoFront: "29/Z", videoSide: "29/Z1", inDictionary: false, sentence: []))


        return dictionary;
    }
}
