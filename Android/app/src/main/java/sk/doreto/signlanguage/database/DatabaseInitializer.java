package sk.doreto.signlanguage.database;


import android.os.AsyncTask;
import androidx.annotation.NonNull;

import sk.doreto.signlanguage.R;


public class DatabaseInitializer {

    private static final String TAG = DatabaseInitializer.class.getName();

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
                new Word(0, "Ahoj", 0, "lection1_ahoj", "lection1_ahoj1"),
                new Word(1, "Ano", 0,"lection1_ano", "lection1_ano1"),
                new Word(2, "Chlapec", 0,"lection1_chlapec", "lection1_chlapec1"),
                new Word(3, "Dorotka", 0, "test.mp3", "testSide.mp3"),
                new Word(4, "Adamko", 0, "ahoj.mp3", "ahojSide.mp3"),
                new Word(5, "Dom", 0, "test.mp3", "testSide.mp3"),
                new Word(6, "Strom", 0, "ahoj.mp3", "ahojSide.mp3"),
                new Word(7, "Cesta", 0, "test.mp3", "testSide.mp3"),
                new Word(8, "Kotva", 0,  "ahoj.mp3", "ahojSide.mp3"),
                new Word(9, "Jablko", 0,  "test.mp3", "testSide.mp3"),
                new Word(10, "XXX", 0, "test.mp3", "testSide.mp3"),
                new Word(11, "YYY", 0,  "test.mp3", "testSide.mp3")
        };


        for (Word word : wordArray)
            db.wordDao().insertAll(word);
        
    }

    private static void populateWithLectionData(AppDatabase db) {

        Lection lectionArray[] = {
                new Lection(0,"Prvy kontakt I.",  "first_contact_1", false),
                new Lection(1,"Prvy kontakt II.", "first_contact_2", false),
                new Lection(2,"Prvy kontakt III.", "first_contact_3", false),
                new Lection(3,"Rodina I.", "family_1", false),
                new Lection(4,"Rodina II.", "family_2", false),
                new Lection(5,"Cisla I.", "numbers_1", false),
                new Lection(6,"Cisla II.", "numbers_2", false),
                new Lection(7,"Farby I.", "colors_1", false)
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