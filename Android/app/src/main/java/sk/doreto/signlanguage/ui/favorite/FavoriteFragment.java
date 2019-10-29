package sk.doreto.signlanguage.ui.favorite;


import android.content.Context;

import sk.doreto.signlanguage.R;
import sk.doreto.signlanguage.database.AppDatabase;
import sk.doreto.signlanguage.ui.common.DictionaryCommonFragment;

public class FavoriteFragment extends DictionaryCommonFragment {

    public FavoriteFragment() {

    }

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);

        wordList = AppDatabase.getAppDatabase(getContext()).wordDao().getFavorite();
        toolbarTitleId = R.string.title_favorites;
    }
}