package com.nagarro.persistence.utils;


import android.os.AsyncTask;
import android.util.Log;

import androidx.annotation.NonNull;

import java.util.List;

import sk.doreto.signlanguage.database.AppDatabase;
import sk.doreto.signlanguage.database.Word;


public class DatabaseInitializer {

    private static final String TAG = DatabaseInitializer.class.getName();

    public static void populateAsync(@NonNull final AppDatabase db) {
        PopulateDbAsync task = new PopulateDbAsync(db);
        task.execute();
    }

    public static void populateSync(@NonNull final AppDatabase db) {
        populateWithWordData(db);
    }

    private static Word addUser(final AppDatabase db, Word word) {
        db.wordDao().insertAll(word);
        return word;
    }

    private static void populateWithWordData(AppDatabase db) {

        Word wordArray [] = {
                new Word("Ahoj", 0, false, "ahoj.mp3", "ahojSide.mp3"),
                new Word("Test", 0, false, "test.mp3", "testSide.mp3")
        };


        for (Word word : wordArray)
            addUser(db, word);
        
    }

    private static class PopulateDbAsync extends AsyncTask<Void, Void, Void> {

        private final AppDatabase mDb;

        PopulateDbAsync(AppDatabase db) {
            mDb = db;
        }

        @Override
        protected Void doInBackground(final Void... params) {
            populateWithWordData(mDb);
            return null;
        }

    }
}