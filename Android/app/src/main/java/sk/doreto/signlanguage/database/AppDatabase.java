package sk.doreto.signlanguage.database;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.room.Database;
import androidx.room.Room;
import androidx.room.RoomDatabase;
import androidx.sqlite.db.SupportSQLiteDatabase;

import java.util.concurrent.Executors;

@Database(entities = {Word.class, Lection.class, Sentence.class, WordSentenceJoin.class}, version = 1, exportSchema =  false)
public abstract class AppDatabase extends RoomDatabase {


    private static AppDatabase INSTANCE;

    public abstract LectionDao lectionDao();
    public abstract WordDao wordDao();
    public abstract SentenceDao sentenceDao();
    public abstract WordSentenceJoinDao wordSentenceJoinDao();


    public static AppDatabase getAppDatabase(Context context) {
        if (INSTANCE == null) {
            INSTANCE = buildDatabase(context.getApplicationContext());
        }
        return INSTANCE;
    }


    private static AppDatabase buildDatabase(final Context context) {


        return Room.databaseBuilder(context, AppDatabase.class, "signLanguage-database")
                .addCallback(new Callback() {
                     @Override
                    public void onCreate(@NonNull SupportSQLiteDatabase db) {
                         super.onCreate(db);

                         Executors.newSingleThreadScheduledExecutor().execute(new Runnable() {
                             @Override
                             public void run() {
                                 AppDatabase database = getAppDatabase(context);
                                 DatabaseInitializer.populateSync(database);
                             }
                         });
                     }
                })
                .allowMainThreadQueries()
                .build();
    }



    public static void destroyInstance() {
        INSTANCE = null;
    }
}