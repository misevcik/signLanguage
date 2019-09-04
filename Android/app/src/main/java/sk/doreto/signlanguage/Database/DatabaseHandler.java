package sk.doreto.signlanguage.Database;
import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

import java.util.ArrayList;

public class DatabaseHandler extends SQLiteOpenHelper {

    private static final int DATABASE_VERSION = 1;
    private static final String DATABASE_NAME = "signLanguage.db";


    public DatabaseHandler(Context context){
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
    }


    @Override
    public void onCreate(SQLiteDatabase db) {

        String CREATE_WORD_TABLE = "CREATE TABLE "
                + DbWord.TABLE_NAME + "("
                + DbWord.ID + " INTEGER PRIMARY KEY AUTOINCREMENT,"
                + DbWord.WORD + " TEXT,"
                + DbWord.LECTION + " INTGER,"
                + DbWord.FAVORITE + " BOOLEAN,"
                + DbWord.FRONT_VIDEO + " TEXT,"
                + DbWord.SIDE_VIDEO + " TEXT"
                + ")";

        db.execSQL(CREATE_WORD_TABLE);

    }

    public void populateDatabase() {
        populateWordTable();
    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int i, int i1) {
    }

    public ArrayList<DbWord> getWrods() {

        ArrayList<DbWord> wordArray = new ArrayList<DbWord>();

        SQLiteDatabase db = this.getReadableDatabase();
        Cursor cursor = db.rawQuery("SELECT * FROM " + DbWord.TABLE_NAME, null);

        if(cursor.moveToFirst()) {
            do {
                DbWord word = new DbWord();
                word.word = cursor.getString(cursor.getColumnIndex(DbWord.WORD));

                wordArray.add(word);
            } while(cursor.moveToNext());
        }

        cursor.close();
        db.close();


        return wordArray;
    }

    private void populateWordTable() {

        DbWord wordArray [] = {
            new DbWord("Ahoj", 0, false, "ahoj.mp3", "ahojSide.mp3"),
            new DbWord("Test", 0, false, "test.mp3", "testSide.mp3")
        };

        SQLiteDatabase db = this.getWritableDatabase();

        for (DbWord word : wordArray)
            addWordToDatabase(db, word);

        db.close();


    }

    private void addWordToDatabase(SQLiteDatabase db, DbWord word) {

        ContentValues values = new ContentValues();

        values.put(DbWord.WORD, word.word);
        values.put(DbWord.LECTION, word.lection);
        values.put(DbWord.FAVORITE, word.favorite);
        values.put(DbWord.FRONT_VIDEO, word.word);
        values.put(DbWord.SIDE_VIDEO, word.word);

        db.insert(DbWord.TABLE_NAME, null, values);
    }



}
