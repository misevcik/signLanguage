package sk.doreto.signlanguage.database;

import androidx.room.Dao;
import androidx.room.Delete;
import androidx.room.Insert;
import androidx.room.Query;

import java.util.List;

@Dao
public interface WordDao {

    @Query("SELECT * FROM WordTable")
    List<Word> getAll();

    @Query("SELECT COUNT(*) from WordTable")
    int countUsers();

    @Insert
    void insertAll(Word... words);

    @Delete
    void delete(Word word);

}
