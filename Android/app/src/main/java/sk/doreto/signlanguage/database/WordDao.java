package sk.doreto.signlanguage.database;

import androidx.room.Dao;
import androidx.room.Delete;
import androidx.room.Insert;
import androidx.room.Query;

import java.util.List;

@Dao
public interface WordDao {

    @Insert
    void insertAll(Word... words);

    @Query("SELECT * FROM WordTable")
    List<Word> getAll();

    @Query("SELECT COUNT(*) from WordTable")
    int countWord();

    @Delete
    void delete(Word word);

}
