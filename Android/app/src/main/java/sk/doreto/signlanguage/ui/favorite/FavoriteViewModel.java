package sk.doreto.signlanguage.ui.favorite;

import android.app.Application;

import androidx.annotation.NonNull;
import androidx.lifecycle.AndroidViewModel;
import androidx.lifecycle.LiveData;

import java.util.List;

import sk.doreto.signlanguage.database.AppDatabase;
import sk.doreto.signlanguage.database.Word;
import sk.doreto.signlanguage.database.WordDao;

public class FavoriteViewModel extends AndroidViewModel {

    private WordDao wordDao;
    private LiveData<List<Word>> wordLiveData;

    public FavoriteViewModel(@NonNull Application application) {
        super(application);
        wordDao = AppDatabase.getAppDatabase(application).wordDao();
        wordLiveData = wordDao.getFavoriteLive(true);
    }

    public void updateFavorite(Word word) {
        wordDao.updateFavorite(word.getFavorite(), word.getId());
    }

    public LiveData<List<Word>> getWordList() {
        return wordLiveData;
    }


}