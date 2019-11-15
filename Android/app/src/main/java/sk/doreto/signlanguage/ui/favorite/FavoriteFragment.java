package sk.doreto.signlanguage.ui.favorite;


import android.content.Context;
import android.os.Bundle;

import androidx.annotation.Nullable;
import androidx.lifecycle.Observer;
import androidx.lifecycle.ViewModelProviders;

import java.util.List;

import sk.doreto.signlanguage.R;
import sk.doreto.signlanguage.database.Word;
import sk.doreto.signlanguage.ui.common.DictionaryAdapter;
import sk.doreto.signlanguage.ui.common.GeneralDictionaryFragment;

public class FavoriteFragment extends GeneralDictionaryFragment {

    private FavoriteViewModel viewModel;

    public FavoriteFragment() {

    }

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);

        super.toolbarTitleId = R.string.title_favorites;

        if (detailFragment == null) {
            detailFragment = new FavoriteDetailFragment(this);
        }

        if(adapter == null) {
            adapter = new DictionaryAdapter(getContext());
        }
    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        initData();
    }


    private void initData() {
        viewModel = ViewModelProviders.of(this).get(FavoriteViewModel.class);
        viewModel.getWordList().observe(this, new Observer<List<Word>>() {
            @Override
            public void onChanged(@Nullable List<Word> words) {
                adapter.setWordList(words);
                setListVisibility();
            }
        });

        ((FavoriteDetailFragment)detailFragment).setModelView(viewModel);
    }

}