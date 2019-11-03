package sk.doreto.signlanguage.ui.dictionary;

import android.content.Context;

import sk.doreto.signlanguage.R;
import sk.doreto.signlanguage.database.AppDatabase;
import sk.doreto.signlanguage.ui.common.GeneralDictionaryFragment;

public class DictionaryFragment extends GeneralDictionaryFragment {

    public DictionaryFragment() {

    }

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);

        super.wordList = AppDatabase.getAppDatabase(getContext()).wordDao().getAll();
        super.detailFragment = new DictionaryDetailFragment(this);

        super.toolbarTitleId = R.string.title_dictionary;

    }
}
