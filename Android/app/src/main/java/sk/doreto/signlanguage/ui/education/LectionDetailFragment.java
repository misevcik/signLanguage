package sk.doreto.signlanguage.ui.education;


import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;

import java.util.List;

import sk.doreto.signlanguage.NavigationBarController;
import sk.doreto.signlanguage.R;
import sk.doreto.signlanguage.database.AppDatabase;
import sk.doreto.signlanguage.database.Lection;
import sk.doreto.signlanguage.database.Word;



public class LectionDetailFragment extends Fragment  {

    private ListView listView;
    private LectionDictionaryAdapter adapter;
    private NavigationBarController navigationBarController;
    private List<Word> wordList;

    public LectionDetailFragment() {
    }


    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {

        View rootView = inflater.inflate(R.layout.fragment_lection_detail, container, false);

        adapter = new LectionDictionaryAdapter(wordList, getContext());

        listView = rootView.findViewById(R.id.lection_dictionary_list);
        listView.setAdapter(adapter);


        return rootView;

    }

    public void setDetailData(Lection lection) {

        wordList = AppDatabase.getAppDatabase(getContext()).wordDao().getWordsForLection(lection.getId());

    }

}