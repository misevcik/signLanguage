package sk.doreto.signlanguage.ui.dictionary;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListView;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;

import java.util.List;

import sk.doreto.signlanguage.database.AppDatabase;
import sk.doreto.signlanguage.R;
import sk.doreto.signlanguage.database.Word;

public class DictionaryFragment extends Fragment{

    private ListView mListView;
    private DictionaryAdapter mAdapter;

    public View onCreateView(@NonNull LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {

        View rootView = inflater.inflate(R.layout.fragment_dictionary, container, false);

        //TODO - use ModelView https://www.thomaskioko.com/android-livedata-viewmodel/
        List<Word> wordList = AppDatabase.getAppDatabase(getContext()).wordDao().getAll();
        mAdapter = new DictionaryAdapter(wordList, getContext());

        mListView = (ListView) rootView.findViewById(R.id.dictionary_list);
        mListView.setAdapter(mAdapter);


        return rootView;
    }



}