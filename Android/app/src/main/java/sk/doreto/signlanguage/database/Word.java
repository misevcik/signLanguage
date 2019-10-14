package sk.doreto.signlanguage.database;

import androidx.room.ColumnInfo;
import androidx.room.Entity;
import androidx.room.Index;
import androidx.room.PrimaryKey;


@Entity(tableName = "WordTable", indices = {@Index(value = "word", unique = true)})
public class Word {

    @PrimaryKey
    @ColumnInfo(name = "id")
    private int id;

    @ColumnInfo(name = "word")
    private String word;

    @ColumnInfo(name = "lection")
    private int lection;

    @ColumnInfo(name = "favorite")
    private boolean favorite;

    @ColumnInfo(name = "videoFront")
    private String videoFront;

    @ColumnInfo(name = "videoSide")
    private String videoSide;

    public Word(int id, String word, int lection, boolean favorite, String videoFront, String videoSide) {
        this.id = id;
        this.word = word;
        this.lection = lection;
        this.favorite = favorite;
        this.videoFront = videoFront;
        this.videoSide = videoSide;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getWord() {
        return word;
    }

    public void setWord(String word) {
        this.word = word;
    }

    public int getLection() {
        return lection;
    }

    public void setLection(int lection) {
        this.lection = lection;
    }

    public boolean getFavorite() {
        return favorite;
    }

    public void setFavorite(boolean favorite) {
        this.favorite = favorite;
    }

    public String getVideoFront() {
        return videoFront;
    }

    public void setVideoFront(String videoFront) {
        this.videoFront = videoFront;
    }

    public String getVideoSide() {
        return videoSide;
    }

    public void setVideoSide(String videoSide) {
        this.videoSide = videoSide;
    }


}
