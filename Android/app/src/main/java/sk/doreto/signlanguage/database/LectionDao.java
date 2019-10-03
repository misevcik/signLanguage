package sk.doreto.signlanguage.database;

import androidx.room.Dao;
import androidx.room.Delete;
import androidx.room.Insert;
import androidx.room.Query;

import java.util.List;

@Dao
public interface LectionDao {

    @Query("SELECT * FROM LectionTable")
    List<Lection> getAll();

    @Query("SELECT COUNT(*) from LectionTable")
    int countLection();

    @Insert
    void insertAll(Lection... lections);

    @Delete
    void delete(Lection lection);

}