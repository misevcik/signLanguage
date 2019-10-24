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

    @Query("SELECT * FROM WordTable WHERE WordTable.lection=:lectionId")
    List<Word> getWordsForLection(final int lectionId);

    @Query("SELECT COUNT(*) FROM WordTable WHERE WordTable.lection=:lectionId")
    int getWordsCountForLection(final int lectionId);

    @Query("SELECT COUNT(*) from WordTable")
    int countWord();

    @Delete
    void delete(Word word);


    @Query("UPDATE WordTable SET visited=:visited WHERE id = :id")
    void updateVisited(boolean visited, int id);

}
