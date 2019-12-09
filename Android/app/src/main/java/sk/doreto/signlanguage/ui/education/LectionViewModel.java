package sk.doreto.signlanguage.ui.education;

import android.app.Application;

import androidx.annotation.NonNull;
import androidx.lifecycle.AndroidViewModel;
import androidx.lifecycle.LiveData;

import java.util.List;

import sk.doreto.signlanguage.database.AppDatabase;
import sk.doreto.signlanguage.database.Lection;
import sk.doreto.signlanguage.database.LectionDao;
import sk.doreto.signlanguage.utils.Converters;

public class LectionViewModel extends AndroidViewModel {

    private LectionDao lectionDao;
    private LiveData<List<Lection>> lectionLiveData;

    public LectionViewModel(@NonNull Application application) {
        super(application);
        lectionDao = AppDatabase.getAppDatabase(application).lectionDao();
        lectionLiveData = lectionDao.getAllLive();
    }

    public LiveData<List<Lection>> getWordList() {
        return lectionLiveData;
    }

    public void updateTestData(Lection lection) {
        lectionDao.updateTestScore(lection.getTestScore(), Converters.dateToTimestamp(lection.getTestDate()), lection.getId());
    }


}
