package sk.doreto.signlanguage.ui.education;

import android.app.Application;

import androidx.annotation.NonNull;
import androidx.lifecycle.AndroidViewModel;
import androidx.lifecycle.LiveData;

import java.util.List;

import sk.doreto.signlanguage.database.AppDatabase;
import sk.doreto.signlanguage.database.Lection;
import sk.doreto.signlanguage.database.LectionDao;

public class LectinViewModel extends AndroidViewModel {

    private LectionDao lectionDao;
    private LiveData<List<Lection>> lectionLiveData;

    public LectinViewModel(@NonNull Application application) {
        super(application);
        lectionDao = AppDatabase.getAppDatabase(application).lectionDao();
        lectionLiveData = lectionDao.getAllLive();
    }

    public LiveData<List<Lection>> getWordList() {
        return lectionLiveData;
    }

}
