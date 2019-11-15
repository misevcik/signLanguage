package sk.doreto.signlanguage.ui.education;

import android.app.Application;

import androidx.annotation.NonNull;
import androidx.lifecycle.AndroidViewModel;
import androidx.lifecycle.LiveData;
import androidx.lifecycle.ViewModel;
import androidx.lifecycle.ViewModelProvider;

import java.util.List;

import sk.doreto.signlanguage.database.AppDatabase;
import sk.doreto.signlanguage.database.Lection;
import sk.doreto.signlanguage.database.Word;
import sk.doreto.signlanguage.database.WordDao;

public class LectionDictionaryViewModel extends AndroidViewModel {

    private WordDao wordDao;
    private LiveData<List<Word>> wordLiveData;

    public LectionDictionaryViewModel(@NonNull Application application, int lectionId) {
        super(application);

        wordDao = AppDatabase.getAppDatabase(application).wordDao();
        wordLiveData = wordDao.getWordsForLection(lectionId);
    }

    public void update(Word word) {
        wordDao.updateVisited(true, word.getId());
    }

    public LiveData<List<Word>> getWordList() {
        return wordLiveData;
    }

}
