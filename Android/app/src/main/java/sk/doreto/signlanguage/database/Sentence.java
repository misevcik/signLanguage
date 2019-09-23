package sk.doreto.signlanguage.database;

import androidx.room.ColumnInfo;
import androidx.room.Entity;
import androidx.room.ForeignKey;
import androidx.room.Index;
import androidx.room.PrimaryKey;


@Entity(tableName = "SentenceTable",
        foreignKeys = @ForeignKey(entity = Word.class,
                                    parentColumns = "wid",
                                    childColumns = "wordId",
                                    onDelete = ForeignKey.CASCADE))
public class Sentence {

    @PrimaryKey(autoGenerate = true)
    private int uid;

    @ColumnInfo(name = "sentence")
    private String sentence;

    @ColumnInfo(name = "video")
    private String video;

    @ColumnInfo(name = "wordId")
    private int wordid;

    public Sentence(String sentence, String video) {
        this.sentence = sentence;
        this.video = video;
    }

    public int getUid() {
        return uid;
    }

    public void setUid(int uid) {
        this.uid = uid;
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