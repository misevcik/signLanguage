package sk.doreto.signlanguage.ui.dictionary;


import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageButton;
import android.widget.LinearLayout;
import android.widget.ListPopupWindow;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import sk.doreto.signlanguage.R;
import sk.doreto.signlanguage.ui.common.IDictionaryFragment;
import sk.doreto.signlanguage.ui.common.GeneralDictionaryDetailFragment;


public class DictionaryDetailFragment extends GeneralDictionaryDetailFragment {

    public DictionaryViewModel modelView;

    public DictionaryDetailFragment(IDictionaryFragment dictionaryFragment) {
        super(dictionaryFragment);
    }
    
    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {

        View rootView = super.onCreateView(inflater, container, savedInstanceState);
        View customToolbar = inflater.inflate(R.layout.toolbar_dictionary_detail, null, false);

        LinearLayout toolbar = rootView.findViewById(R.id.dictionary_detail_toolbar);
        toolbar.addView(customToolbar, ListPopupWindow.MATCH_PARENT, ListPopupWindow.MATCH_PARENT);

        TextView dictionaryTitle = toolbar.findViewById(R.id.dictionary_detail_word_title);
        dictionaryTitle.setText(word.getWord());

        ImageButton favorite = toolbar.findViewById(R.id.dictionary_detail_favorite);
        favorite.setImageResource(word.getFavorite() ? R.mipmap.icon_heart_red : R.mipmap.icon_heart_black);

        favorite.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v)  {
                word.setFavorite(!word.getFavorite());
                favorite.setImageResource(word.getFavorite() ? R.mipmap.icon_heart_red : R.mipmap.icon_heart_black);
                modelView.updateFavorite(word);
            }
        });

        return rootView;
    }
}
