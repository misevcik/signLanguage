package sk.doreto.signlanguage.ui.education;


import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentTransaction;

import java.util.List;

import sk.doreto.signlanguage.R;
import sk.doreto.signlanguage.database.AppDatabase;
import sk.doreto.signlanguage.database.Lection;
import sk.doreto.signlanguage.database.Word;
import sk.doreto.signlanguage.ui.dictionary.DictionaryDetailFragment;
import sk.doreto.signlanguage.ui.dictionary.IDictionaryFragment;


public class LectionDetailFragment extends Fragment implements IDictionaryFragment {

    private ListView listView;
    private LectionDictionaryAdapter adapter;
    private List<Word> wordList;
    private DictionaryDetailFragment detailFragment;

    private int selectedPosition = -1;

    public LectionDetailFragment() {
    }


    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {

        View rootView = inflater.inflate(R.layout.fragment_lection_detail, container, false);

        adapter = new LectionDictionaryAdapter(wordList, getContext());
        detailFragment = new DictionaryDetailFragment(this, DictionaryDetailFragment.FragmentType.LECTION);

        listView = rootView.findViewById(R.id.lection_dictionary_list);
        listView.setAdapter(adapter);
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {

                detailFragment.setDetailData(wordList.get(position));
                selectedPosition = position;

                FragmentTransaction ft = getActivity().getSupportFragmentManager().beginTransaction();
                ft.add(R.id.viewLayout, detailFragment);
                ft.addToBackStack("DictionaryDetailFragment").commit();
            }
        });


        return rootView;

    }

    public void setDetailData(Lection lection) {

        wordList = AppDatabase.getAppDatabase(getContext()).wordDao().getWordsForLection(lection.getId());

    }

    public void videoForward() {

        selectedPosition++;

        if(selectedPosition >= wordList.size())
            selectedPosition = 0;

        detailFragment.setDetailData(wordList.get(selectedPosition));
        getActivity().getSupportFragmentManager().beginTransaction().detach(detailFragment).attach(detailFragment).commit();
    }

    public void videoBackward() {

        selectedPosition--;

        if(selectedPosition <= 0)
            selectedPosition = wordList.size() - 1;

        detailFragment.setDetailData(wordList.get(selectedPosition));
        getActivity().getSupportFragmentManager().beginTransaction().detach(detailFragment).attach(detailFragment).commit();
    }

    public void updateContent() {
        this.adapter.notifyDataSetChanged();
    }

}