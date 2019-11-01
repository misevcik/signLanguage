package sk.doreto.signlanguage.ui.education;


import android.content.res.Resources;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentTransaction;

import java.util.List;

import sk.doreto.signlanguage.R;
import sk.doreto.signlanguage.database.AppDatabase;
import sk.doreto.signlanguage.database.Lection;
import sk.doreto.signlanguage.database.Word;
import sk.doreto.signlanguage.ui.common.IDictionaryFragment;


public class LectionWordListFragment extends Fragment implements IDictionaryFragment {

    private ListView listView;
    private LectionDictionaryAdapter adapter;
    private List<Word> wordList;
    private LectionDetailFragment detailFragment;

    private Lection lection;
    private int selectedPosition = -1;

    public LectionWordListFragment() {
    }


    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {

        View rootView = inflater.inflate(R.layout.fragment_lection_word_list, container, false);

        TextView toolbarTitleView = rootView.findViewById(R.id.toolbar_title);
        toolbarTitleView.setText(lection.getTitle());


        adapter = new LectionDictionaryAdapter(wordList, getContext());
        detailFragment = new LectionDetailFragment(this);

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

        this.lection = lection;
        this.wordList = AppDatabase.getAppDatabase(getContext()).wordDao().getWordsForLection(lection.getId());

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

    public void updateContent(Word word) {
        this.adapter.notifyDataSetChanged();
    }

}