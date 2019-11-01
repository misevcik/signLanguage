package sk.doreto.signlanguage.ui.favorite;


import android.content.Context;

import sk.doreto.signlanguage.R;
import sk.doreto.signlanguage.database.AppDatabase;
import sk.doreto.signlanguage.database.Word;
import sk.doreto.signlanguage.ui.common.GeneralDictionaryFragment;

public class FavoriteFragment extends GeneralDictionaryFragment {

    public FavoriteFragment() {

    }

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);

        super.wordList = AppDatabase.getAppDatabase(getContext()).wordDao().getFavorite(true);
        super.detailFragment = new FavoriteDetailFragment(this);

        super.toolbarTitleId = R.string.title_favorites;
    }

    public void updateContent(Word word) {

        if(!word.getFavorite()) {
            super.wordList.remove(word);
        }
        super.updateContent(word);

    }
}