package sk.doreto.signlanguage.database;


import androidx.room.ColumnInfo;
import androidx.room.Entity;
import androidx.room.Index;
import androidx.room.PrimaryKey;

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


    public Lection(int id, String title,  String image, boolean locked) {

        this.id = id;
        this.title = title;
        this.image = image;
        this.locked = locked;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getImage() {
        return image;
    }

    public void getImage(String image) { this.image = image; }

    public boolean getLocked() {
        return locked;
    }

    public void getLocked(boolean locked) { this.locked = locked; }




}
