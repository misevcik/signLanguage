package sk.doreto.signlanguage.database;

import androidx.lifecycle.LiveData;
import androidx.room.Dao;
import androidx.room.Insert;
import androidx.room.Query;

import java.util.List;

@Dao
public interface WordDao {

    @Insert
    void insertAll(Word... words);

    @Query("SELECT * FROM WordTable ORDER BY WordTable.word ASC")
    List<Word> getAll();

    @Query("SELECT * FROM WordTable ORDER BY WordTable.word ASC")
    LiveData<List<Word>> getAllLive();

    @Query("SELECT * FROM WordTable WHERE WordTable.favorite=:favorite ORDER BY WordTable.word ASC")
    List<Word> getFavorite(boolean favorite);

    @Query("SELECT * FROM WordTable WHERE WordTable.favorite=:favorite ORDER BY WordTable.word ASC")
    LiveData<List<Word>>  getFavoriteLive(boolean favorite);

    @Query("SELECT * FROM WordTable WHERE WordTable.lection=:lectionId ORDER BY WordTable.word ASC")
    List<Word> getWordsForLection(final int lectionId);

    @Query("SELECT COUNT(*) FROM WordTable WHERE WordTable.lection=:lectionId")
    int getWordsCountForLection(final int lectionId);

    @Query("SELECT COUNT(*) FROM WordTable WHERE WordTable.lection=:lectionId AND WordTable.visited = 1")
    int getVisitedWordsCountForLection(final int lectionId);


    @Query("UPDATE WordTable SET visited=:visited WHERE id = :id")
    void updateVisited(boolean visited, int id);

    @Query("UPDATE WordTable SET favorite=:favorite WHERE id = :id")
    void updateFavorite(boolean favorite, int id);

}
