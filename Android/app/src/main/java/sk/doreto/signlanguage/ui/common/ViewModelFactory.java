package sk.doreto.signlanguage.ui.common;

import android.app.Application;

import androidx.lifecycle.ViewModel;
import androidx.lifecycle.ViewModelProvider;

import sk.doreto.signlanguage.ui.education.LectionDictionaryViewModel;

public class ViewModelFactory implements ViewModelProvider.Factory {
    private Application application;
    private int param;


    public ViewModelFactory(Application application, int param) {
        this.application = application;
        this.param = param;
    }


    @Override
    public <T extends ViewModel> T create(Class<T> modelClass) {
        return (T) new LectionDictionaryViewModel(application, param);
    }
}