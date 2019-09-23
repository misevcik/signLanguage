package sk.doreto.signlanguage.database;

import androidx.room.ColumnInfo;
import androidx.room.Entity;
import androidx.room.Index;
import androidx.room.PrimaryKey;


@Entity(tableName = "WordTable", indices = {@Index(value = "word", unique = true)})
public class Word {

    @PrimaryKey(autoGenerate = true)
    @ColumnInfo(name = "wid")
    private int uid;

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

    public Word(String word, int lection, boolean favorite, String videoFront, String videoSide) {
        this.word = word;
        this.lection = lection;
        this.favorite = favorite;
        this.videoFront = videoFront;
        this.videoSide = videoSide;
    }

    public int getUid() {
        return uid;
    }

    public void setUid(int uid) {
        this.uid = uid;
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
