package sk.doreto.signlanguage.ui.favorite;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageButton;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import sk.doreto.signlanguage.R;
import sk.doreto.signlanguage.database.AppDatabase;
import sk.doreto.signlanguage.ui.common.GeneralDictionaryDetailFragment;
import sk.doreto.signlanguage.ui.common.IDictionaryFragment;

import static android.widget.ListPopupWindow.MATCH_PARENT;

public class FavoriteDetailFragment extends GeneralDictionaryDetailFragment {

    public FavoriteDetailFragment(IDictionaryFragment dictionaryFragment) {
        super(dictionaryFragment);

    }

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {

        View rootView = super.onCreateView(inflater, container, savedInstanceState);
        View customToolbar = inflater.inflate(R.layout.toolbar_dictionary_detail, null, false);

        LinearLayout toolbar = rootView.findViewById(R.id.dictionary_detail_toolbar);
        toolbar.addView(customToolbar, MATCH_PARENT, MATCH_PARENT);

        TextView dictionaryTitle = toolbar.findViewById(R.id.dictionary_detail_word_title);
        dictionaryTitle.setText(word.getWord());

        ImageButton favorite = toolbar.findViewById(R.id.dictionary_detail_favorite);
        favorite.setImageResource(word.getFavorite() ? R.mipmap.icon_heart_red : R.mipmap.icon_heart_black);

        favorite.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v)  {
                word.setFavorite(!word.getFavorite());
                favorite.setImageResource(word.getFavorite() ? R.mipmap.icon_heart_red : R.mipmap.icon_heart_black);
                AppDatabase.getAppDatabase(getContext()).wordDao().updateFavorite(word.getFavorite(), word.getId());
                parentFragment.updateContent(word);

            }
        });

        return rootView;
    }

}
