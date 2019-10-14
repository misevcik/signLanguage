package sk.doreto.signlanguage.database;

import androidx.room.ColumnInfo;
import androidx.room.Entity;
import androidx.room.Index;
import androidx.room.PrimaryKey;


@Entity(tableName = "SentenceTable", indices = {@Index(value = "id", unique = true)})
public class Sentence {

    @PrimaryKey
    @ColumnInfo(name = "id")
    private int id;

    @ColumnInfo(name = "sentence")
    private String sentence;

    @ColumnInfo(name = "video")
    private String video;

    public Sentence(int id, String sentence, String video) {
        this.id = id;
        this.sentence = sentence;
        this.video = video;;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getSentence() {
        return sentence;
    }

    public void setSentence(String sentence) {
        this.sentence = sentence;
    }

    public String getVideo() {
        return video;
    }

    public void setVideo(String videoFront) {
        this.video = video;
    }
}