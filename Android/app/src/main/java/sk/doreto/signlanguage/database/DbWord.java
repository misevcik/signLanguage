package sk.doreto.signlanguage.database;

public class DbWord {

    public static final String TABLE_NAME = "Word";
    public static final String ID = "id";
    public static final String WORD = "word";
    public static final String LECTION = "lection";
    public static final String FAVORITE = "favorite";
    public static final String FRONT_VIDEO = "videoFront";
    public static final String SIDE_VIDEO = "videoSide";

    DbWord(String word, Integer lection, Boolean favorite, String videoFront, String videoSide) {
        this.word = word;
        this.lection = lection;
        this.favorite = favorite;
        this.videoFront = videoFront;
        this.videoSide = videoSide;
    }

    DbWord() {
    }


    public String word;
    public Integer lection;
    public Boolean favorite;
    public String videoFront;
    public String videoSide;

}
