package sk.doreto.signlanguage.ui.dictionary;

import android.content.Context;
import android.os.Bundle;

import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.lifecycle.Observer;
import androidx.lifecycle.ViewModelProviders;

import java.util.List;

import sk.doreto.signlanguage.R;
import sk.doreto.signlanguage.database.Word;
import sk.doreto.signlanguage.ui.common.DictionaryAdapter;
import sk.doreto.signlanguage.ui.common.GeneralDictionaryFragment;

public class DictionaryFragment extends GeneralDictionaryFragment {

    private DictionaryViewModel modelView;

    public DictionaryFragment() {
    }

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);

        toolbarTitleId = R.string.title_dictionary;

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
        modelView = ViewModelProviders.of(this).get(DictionaryViewModel.class);
        modelView.getWordList().observe(this, new Observer<List<Word>>() {
            @Override
            public void onChanged(@Nullable List<Word> words) {
                adapter.setWordList(words);
            }
        });

        super.modelView = modelView;
    }
}
