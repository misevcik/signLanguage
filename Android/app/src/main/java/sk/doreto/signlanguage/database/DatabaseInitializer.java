package sk.doreto.signlanguage.database;


import android.os.AsyncTask;
import androidx.annotation.NonNull;

import sk.doreto.signlanguage.R;


public class DatabaseInitializer {

    public static void populateAsync(@NonNull final AppDatabase db) {
        PopulateDbAsync task = new PopulateDbAsync(db);
        task.execute();
    }

    public static void populateSync(@NonNull final AppDatabase db) {

        populateWithLectionData(db);
        populateWithWordData(db);
        populateWithSentenceData(db);
        joinWordWithSentence(db);
    }


    private static void populateWithWordData(AppDatabase db) {


        Word wordArray [] = {
                //Lesson 1 - Prvy kontakt I
                new Word(0, "Ahoj", 0, "lection1_ahoj", "lection1_ahoj1", true),
                new Word(1, "Ja", 0,"lection1_ano", "lection1_ano1", true),
                new Word(2, "Ty", 0,"lection1_chlapec", "lection1_chlapec1", true),
                new Word(3, "On/Ona", 0, "test.mp3", "testSide.mp3", true),
                new Word(4, "Áno", 0, "ahoj.mp3", "ahojSide.mp3", true),
                new Word(5, "Nie", 0, "ahoj.mp3", "ahojSide.mp3", true),
                new Word(6, "Nepočujúci", 0, "test.mp3", "testSide.mp3", true),
                new Word(7, "Počujúci", 0, "ahoj.mp3", "ahojSide.mp3", true),
                new Word(8, "Rozumieť", 0, "test.mp3", "testSide.mp3", true),
                new Word(9, "Nerozumieť", 0,  "ahoj.mp3", "ahojSide.mp3", true),
                new Word(10, "Nedoslýchaví", 0,  "test.mp3", "testSide.mp3", true),
                new Word(11, "Muž", 0, "test.mp3", "testSide.mp3", true),
                new Word(12, "Žena", 0,  "test.mp3", "testSide.mp3", true),
                new Word(13, "Chlapec", 0,  "test.mp3", "testSide.mp3", true),
                new Word(14, "Dievča", 0,  "test.mp3", "testSide.mp3", true),

                //Lesson 2 - Prvy kontakt II
                new Word(15, "Meno", 1, "lection1_ahoj", "lection1_ahoj1", true),
                new Word(16, "Moje", 1,"lection1_ano", "lection1_ano1", true),
                new Word(17, "Tvoje", 1,"lection1_chlapec", "lection1_chlapec1", true),
                new Word(18, "Jeho/Jej", 1, "test.mp3", "testSide.mp3", true),
                new Word(19, "Kto", 1, "ahoj.mp3", "ahojSide.mp3", true),
                new Word(20, "My", 1, "test.mp3", "testSide.mp3", true),
                new Word(21, "Vy", 1, "ahoj.mp3", "ahojSide.mp3", true),
                new Word(22, "Rovnako", 1, "test.mp3", "testSide.mp3", true),
                new Word(23, "Čo", 1,  "ahoj.mp3", "ahojSide.mp3", true),
                new Word(24, "Ako", 1,  "test.mp3", "testSide.mp3", true),
                new Word(25, "Alebo", 1, "test.mp3", "testSide.mp3", true),
                new Word(26, "Dobre", 1,  "test.mp3", "testSide.mp3", true),
                new Word(27, "Zle", 1,  "test.mp3", "testSide.mp3", true),
                new Word(28, "Prosiť", 1,  "test.mp3", "testSide.mp3", true),
                new Word(29, "Prepáč", 1,  "test.mp3", "testSide.mp3", true),

                //Lesson 3 - Prvy kontakt III
                new Word(30, "Ráno", 2, "lection1_ahoj", "lection1_ahoj1", true),
                new Word(31, "Obed", 2,"lection1_ano", "lection1_ano1", true),
                new Word(32, "Poobede", 2,"lection1_chlapec", "lection1_chlapec1", true),
                new Word(33, "Večer", 2, "test.mp3", "testSide.mp3", true),
                new Word(34, "Noc", 2, "ahoj.mp3", "ahojSide.mp3", true),
                new Word(35, "Deň", 2, "test.mp3", "testSide.mp3", true),
                new Word(36, "Osoba", 2, "ahoj.mp3", "ahojSide.mp3", true),
                new Word(37, "Kamarát/ka", 2, "test.mp3", "testSide.mp3", true),
                new Word(38, "Kolega/Kolegyňa", 2,  "ahoj.mp3", "ahojSide.mp3", true),
                new Word(39, "Ďakujem", 2,  "test.mp3", "testSide.mp3", true),
                new Word(40, "Pozdraviť", 2, "test.mp3", "testSide.mp3", true),
                new Word(41, "Poznať", 2,  "test.mp3", "testSide.mp3", true),
                new Word(42, "Tešiť sa", 2,  "test.mp3", "testSide.mp3", true),
                new Word(43, "Stretnúť", 2,  "test.mp3", "testSide.mp3", true),
                new Word(44, "Opakovať", 2,  "test.mp3", "testSide.mp3", true),

                //Lesson 4 - Rodina I
                new Word(45, "Mama", 3, "lection1_ahoj", "lection1_ahoj1", true),
                new Word(46, "Otec", 3,"lection1_ano", "lection1_ano1", true),
                new Word(47, "Dcéra", 3,"lection1_chlapec", "lection1_chlapec1", true),
                new Word(48, "Syn", 3, "test.mp3", "testSide.mp3", true),
                new Word(49, "Rodina", 3, "ahoj.mp3", "ahojSide.mp3", true),
                new Word(50, "Brat", 3, "test.mp3", "testSide.mp3", true),
                new Word(51, "Sestra", 3, "ahoj.mp3", "ahojSide.mp3", true),
                new Word(52, "Deti", 3, "test.mp3", "testSide.mp3", true),
                new Word(53, "Mám", 3,  "ahoj.mp3", "ahojSide.mp3", true),
                new Word(54, "Nemám", 3,  "test.mp3", "testSide.mp3", true),
                new Word(55, "Babka", 3, "test.mp3", "testSide.mp3", true),
                new Word(56, "Dedko", 3,  "test.mp3", "testSide.mp3", true),
                new Word(57, "Dieťa", 3,  "test.mp3", "testSide.mp3", true),
                new Word(58, "Ženatý/Vydatá", 3,  "test.mp3", "testSide.mp3", true),
                new Word(59, "Slobodný/á", 3,  "test.mp3", "testSide.mp3", true),

                //Lesson 5 - Rodina II
                new Word(60, "Vnuk", 4, "lection1_ahoj", "lection1_ahoj1", true),
                new Word(61, "Vnučka", 4,"lection1_ano", "lection1_ano1", true),
                new Word(62, "Manžel/ka", 4,"lection1_chlapec", "lection1_chlapec1", true),
                new Word(63, "Rozvedený/á", 4, "test.mp3", "testSide.mp3", true),
                new Word(64, "Manželia", 4, "ahoj.mp3", "ahojSide.mp3", true),
                new Word(65, "Frajer/ka", 4, "test.mp3", "testSide.mp3", true),
                new Word(66, "Priateľ/ka", 4, "ahoj.mp3", "ahojSide.mp3", true),
                new Word(67, "Druh/Družka\"", 4, "test.mp3", "testSide.mp3", true),
                new Word(68, "Teta", 4,  "ahoj.mp3", "ahojSide.mp3", true),
                new Word(69, "Ujo", 4,  "test.mp3", "testSide.mp3", true),
                new Word(70, "Žiť", 4, "test.mp3", "testSide.mp3", true),
                new Word(71, "Spolu", 4,  "test.mp3", "testSide.mp3", true),
                new Word(72, "Rozvod/Rozchod", 4,  "test.mp3", "testSide.mp3", true),
                new Word(73, "Rande", 4,  "test.mp3", "testSide.mp3", true),
                new Word(74, "Láska", 4,  "test.mp3", "testSide.mp3", true),

                //Lesson 6 - Čísla I.
                new Word(75, "0 - 5", 5, "lection1_ahoj", "lection1_ahoj1", false),
                new Word(76, "6 - 10", 5,"lection1_ano", "lection1_ano1", false),
                new Word(77, "11 - 15", 5,"lection1_chlapec", "lection1_chlapec1", false),
                new Word(78, "16 - 20", 5, "test.mp3", "testSide.mp3", false),
                new Word(79, "21 - 25", 5, "ahoj.mp3", "ahojSide.mp3", false),
                new Word(80, "26 - 30", 5, "test.mp3", "testSide.mp3", false),
                new Word(81, "31 - 35", 5, "ahoj.mp3", "ahojSide.mp3", false),
                new Word(82, "46 - 50", 5, "test.mp3", "testSide.mp3", false),
                new Word(83, "51 - 55", 5,  "ahoj.mp3", "ahojSide.mp3", false),
                new Word(84, "66 - 70", 5,  "test.mp3", "testSide.mp3", false),
                new Word(85, "81 - 85", 5, "test.mp3", "testSide.mp3", false),
                new Word(86, "96 - 99", 5,  "test.mp3", "testSide.mp3", false),
                new Word(87, "Číslo", 5,  "test.mp3", "testSide.mp3", true),
                new Word(88, "+/-/*/:/=", 5,  "test.mp3", "testSide.mp3", false),
                new Word(89, "Rokov", 5,  "test.mp3", "testSide.mp3", true),

                //Lesson 7 - Čísla II.
                new Word(90, "100 - 500", 6, "lection1_ahoj", "lection1_ahoj1", false),
                new Word(91, "600 - 900", 6,"lection1_ano", "lection1_ano1", false),
                new Word(92, "1000 - 5000", 6,"lection1_chlapec", "lection1_chlapec1", false),
                new Word(93, "6000 - 10000", 6, "test.mp3", "testSide.mp3", false),
                new Word(94, "200000 - 50000", 6, "ahoj.mp3", "ahojSide.mp3", false),
                new Word(95, "100 000", 6, "test.mp3", "testSide.mp3", false),
                new Word(96, "250 000", 6, "ahoj.mp3", "ahojSide.mp3", false),
                new Word(97, "700 000", 6, "test.mp3", "testSide.mp3", false),
                new Word(98, "1 000 000", 6,  "ahoj.mp3", "ahojSide.mp3", false),
                new Word(99, "10 000 000", 6,  "test.mp3", "testSide.mp3", false),
                new Word(100, "Starý", 6, "test.mp3", "testSide.mp3", true),
                new Word(101, "Mladý", 6,  "test.mp3", "testSide.mp3", true),
                new Word(102, "Koľko", 6,  "test.mp3", "testSide.mp3", true),
                new Word(103, "Správne", 6,  "test.mp3", "testSide.mp3", true),
                new Word(104, "Nesprávne", 6,  "test.mp3", "testSide.mp3", true),

                //Lesson 8 - Materiály a farby I.
                new Word(105, "Farba", 7, "lection1_ahoj", "lection1_ahoj1", true),
                new Word(106, "Biela", 7,"lection1_ano", "lection1_ano1", true),
                new Word(107, "Žltá", 7,"lection1_chlapec", "lection1_chlapec1", true),
                new Word(108, "Ružová", 7, "test.mp3", "testSide.mp3", true),
                new Word(109, "Oranžová", 7, "ahoj.mp3", "ahojSide.mp3", true),
                new Word(110, "Červená", 7, "test.mp3", "testSide.mp3", true),
                new Word(111, "Fialová", 7, "ahoj.mp3", "ahojSide.mp3", true),
                new Word(112, "Svetlá", 7, "test.mp3", "testSide.mp3", true),
                new Word(113, "Tmavá", 7,  "ahoj.mp3", "ahojSide.mp3", true),
                new Word(114, "Farebná", 7,  "test.mp3", "testSide.mp3", true),
                new Word(115, "Milovať", 7, "test.mp3", "testSide.mp3", true),
                new Word(116, "Neznášať", 7,  "test.mp3", "testSide.mp3", true),
                new Word(117, "Pekná", 7,  "test.mp3", "testSide.mp3", true),
                new Word(118, "Škaredá", 7,  "test.mp3", "testSide.mp3", true),
                new Word(119, "Moderná", 7,  "test.mp3", "testSide.mp3", true),

        };

        for (Word word : wordArray)
            db.wordDao().insertAll(word);
        
    }

    private static void populateWithLectionData(AppDatabase db) {

        Lection lectionArray[] = {
                new Lection(0,"Prvý kontakt I.",  "first_contact_1"),
                new Lection(1,"Prvý kontakt II.", "first_contact_2"),
                new Lection(2,"Prvý kontakt III.", "first_contact_3"),
                new Lection(3,"Rodina I.", "family_1"),
                new Lection(4,"Rodina II.", "family_2"),
                new Lection(5,"Čísla I.", "numbers_1"),
                new Lection(6,"Čísla II.", "numbers_2"),
                new Lection(7,"Farby I.", "colors_1")
        };

        for (Lection lection : lectionArray)
            db.lectionDao().insertAll(lection);
    }

    private static void populateWithSentenceData(AppDatabase db) {

        Sentence sentencesArray [] = {
                new Sentence(0, "Ahoj, kamo", "lection1_ahoj"),
                new Sentence(1, "Ano to je on", "lection1_ahoj")
        };


        for (Sentence sentence : sentencesArray)
            db.sentenceDao().insertAll(sentence);

    }

    private static void joinWordWithSentence(AppDatabase db) {

        WordSentenceJoin wordSentenceJoinArray [] = {
                new WordSentenceJoin(0, 0), //Ahoj
                new WordSentenceJoin(1, 1) //Ano
        };

        for (WordSentenceJoin wordSentenceJoin : wordSentenceJoinArray)
            db.wordSentenceJoinDao().insertAll(wordSentenceJoin);
    }

    private static class PopulateDbAsync extends AsyncTask<Void, Void, Void> {

        private final AppDatabase mDb;

        PopulateDbAsync(AppDatabase db) {
            mDb = db;
        }

        @Override
        protected Void doInBackground(final Void... params) {

            populateWithLectionData(mDb);
            populateWithWordData(mDb);
            populateWithSentenceData(mDb);
            joinWordWithSentence(mDb);

            return null;
        }

    }
}