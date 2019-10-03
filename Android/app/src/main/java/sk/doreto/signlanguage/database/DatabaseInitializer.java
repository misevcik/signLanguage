package sk.doreto.signlanguage.database;


import android.os.AsyncTask;
import androidx.annotation.NonNull;


public class DatabaseInitializer {

    private static final String TAG = DatabaseInitializer.class.getName();

    public static void populateAsync(@NonNull final AppDatabase db) {
        PopulateDbAsync task = new PopulateDbAsync(db);
        task.execute();
    }

    public static void populateSync(@NonNull final AppDatabase db) {
        populateWithLectionData(db);
        populateWithWordData(db);
    }

    private static Word addWord(final AppDatabase db, Word word) {
        db.wordDao().insertAll(word);
        return word;
    }

    private static Lection addLection(final AppDatabase db, Lection lection) {
        db.lectionDao().insertAll(lection);
        return lection;
    }

    private static void populateWithLectionData(AppDatabase db) {

        Lection lectionArray[] = {
                new Lection(0,"Prvy kontakt I.",  "test.png", false),
                new Lection(1,"Prvy kontakt II.", "test.png", false),
                new Lection(2,"Prvy kontakt III.", "test.png", false),
                new Lection(3,"Rodina I.", "test.png", false),
                new Lection(4,"Rodina II.", "test.png", false),
                new Lection(5,"Cisla I.", "test.png", false),
                new Lection(6,"Cisla II.", "test.png", false),
                new Lection(7,"Farby I.", "test.png", false)
        };

        for (Lection lection : lectionArray)
            addLection(db, lection);
    }

    private static void populateWithWordData(AppDatabase db) {

        Word wordArray [] = {
                new Word("Ahoj", 0, false, "ahoj.mp3", "ahojSide.mp3"),
                new Word("Test", 0, true, "test.mp3", "testSide.mp3"),
                new Word("Cau", 0, false, "ahoj.mp3", "ahojSide.mp3"),
                new Word("Dorotka", 0, false, "test.mp3", "testSide.mp3"),
                new Word("Adamko", 0, true, "ahoj.mp3", "ahojSide.mp3"),
                new Word("Dom", 0, false, "test.mp3", "testSide.mp3"),
                new Word("Strom", 0, false, "ahoj.mp3", "ahojSide.mp3"),
                new Word("Cesta", 0, false, "test.mp3", "testSide.mp3"),
                new Word("Kotva", 0, false, "ahoj.mp3", "ahojSide.mp3"),
                new Word("Jablko", 0, false, "test.mp3", "testSide.mp3"),
                new Word("XXX", 0, false, "test.mp3", "testSide.mp3"),
                new Word("YYY", 0, false, "test.mp3", "testSide.mp3")
        };


        for (Word word : wordArray)
            addWord(db, word);
        
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
            return null;
        }

    }
}