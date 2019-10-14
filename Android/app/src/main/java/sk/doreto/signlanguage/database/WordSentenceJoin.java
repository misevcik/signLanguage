package sk.doreto.signlanguage.database;

import androidx.room.Entity;
import androidx.room.ForeignKey;


@Entity(tableName = "WordSentenceJoinTable",
        primaryKeys = { "wordId", "sentenceId" },
        foreignKeys = {
                @ForeignKey(entity = Word.class,
                        parentColumns = "id",
                        childColumns = "wordId"),
                @ForeignKey(entity = Sentence.class,
                        parentColumns = "id",
                        childColumns = "sentenceId")
        })

public class WordSentenceJoin {

    public final int wordId;
    public final int sentenceId;

    public WordSentenceJoin(final int wordId, final int sentenceId) {
        this.wordId = wordId;
        this.sentenceId = sentenceId;
    }
}

