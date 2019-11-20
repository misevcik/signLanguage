package sk.doreto.signlanguage.database;


import androidx.room.ColumnInfo;
import androidx.room.Entity;
import androidx.room.Index;
import androidx.room.PrimaryKey;

import java.util.Date;

@Entity(tableName = "LectionTable", indices = {@Index(value = "id", unique = true)})
public class Lection {

    @PrimaryKey
    @ColumnInfo(name = "id")
    private int id;

    @ColumnInfo(name = "title")
    private String title;

    @ColumnInfo(name = "image")
    private String image;

    @ColumnInfo(name = "locked")
    private boolean locked;

    @ColumnInfo(name = "testScore")
    private int testScore;

    @ColumnInfo(name = "testDuration")
    private int testDuration;


    public Lection(int id, String title,  String image, int testScore) {

        this.id = id;
        this.title = title;
        this.image = image;
        this.locked = false;
        this.testScore = testScore;
        this.testDuration = 0;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public int getId() { return id; }

    public void setId(int id) {
        this.id = id;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) { this.image = image; }

    public boolean getLocked() {
        return locked;
    }

    public void setLocked(boolean locked) { this.locked = locked; }

    public int getTestScore() {
        return testScore;
    }

    public void setTestScore(int score) { this.testScore = score; }

    public int getTestDuration() { return testDuration; }

    public void setTestDuration(int duration) { this.testDuration = duration; }

}
