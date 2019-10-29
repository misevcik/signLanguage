package sk.doreto.signlanguage.ui.dictionary;

import android.content.Context;
import android.content.res.Resources;

import sk.doreto.signlanguage.R;
import sk.doreto.signlanguage.database.AppDatabase;
import sk.doreto.signlanguage.ui.common.DictionaryCommonFragment;

public class DictionaryFragment extends DictionaryCommonFragment {

    public DictionaryFragment() {

    }

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);

        wordList = AppDatabase.getAppDatabase(getContext()).wordDao().getAll();
        toolbarTitleId = R.string.title_dictionary;

    }

}
