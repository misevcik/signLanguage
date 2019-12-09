package sk.doreto.signlanguage.database;

import androidx.lifecycle.LiveData;
import androidx.room.Dao;
import androidx.room.Delete;
import androidx.room.Insert;
import androidx.room.Query;

import java.util.Date;
import java.util.List;

@Dao
public interface LectionDao {

    @Insert
    void insertAll(Lection... lections);

    @Query("SELECT * FROM LectionTable")
    List<Lection> getAll();

    @Query("SELECT * FROM LectionTable")
    LiveData<List<Lection>> getAllLive();

    @Query("SELECT COUNT(*) from LectionTable")
    int countLection();

    @Query("UPDATE LectionTable SET testScore=:testScore, testDate=:testDate WHERE id = :id")
    void updateTestScore(int testScore, Long testDate, int id);

}