package sk.doreto.signlanguage.database;

import androidx.room.Dao;
import androidx.room.Insert;
import androidx.room.Query;

import java.util.List;

@Dao
public interface WordSentenceJoinDao {

    @Insert
    void insertAll(WordSentenceJoin... wordSentenceJoin);


    @Query("SELECT * FROM SentenceTable INNER JOIN WordSentenceJoinTable ON SentenceTable.id=WordSentenceJoinTable.sentenceId WHERE WordSentenceJoinTable.wordId=:wordId")
    List<Sentence> getSentencesForWord(final int wordId);


}
