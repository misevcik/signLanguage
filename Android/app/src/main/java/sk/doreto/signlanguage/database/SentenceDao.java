package sk.doreto.signlanguage.database;

import androidx.room.Dao;
import androidx.room.Delete;
import androidx.room.Insert;
import androidx.room.Query;

import java.util.List;

@Dao
public interface SentenceDao {

    @Query("SELECT * FROM SentenceTable")
    List<Sentence> getAll();

    @Query("SELECT COUNT(*) from SentenceTable")
    int countSentences();

    @Insert
    void insertAll(Sentence... sentences);

    @Delete
    void delete(Sentence sentences);

}