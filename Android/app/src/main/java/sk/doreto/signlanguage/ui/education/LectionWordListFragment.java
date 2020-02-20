package sk.doreto.signlanguage.ui.education;


import android.content.Context;
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
import androidx.lifecycle.Observer;
import androidx.lifecycle.ViewModelProviders;

import java.util.List;

import sk.doreto.signlanguage.R;
import sk.doreto.signlanguage.database.Lection;
import sk.doreto.signlanguage.database.Word;
import sk.doreto.signlanguage.ui.common.IDictionaryFragment;
import sk.doreto.signlanguage.ui.common.ViewModelFactory;


public class LectionWordListFragment extends Fragment implements IDictionaryFragment {

    private LectionDictionaryViewModel modelView;
    private Lection lection;
    private ListView listView;
    private LectionDictionaryAdapter adapter;
    private LectionDetailFragment detailFragment;

    private int selectedPosition = -1;

    public LectionWordListFragment(Lection lection) {
        this.lection = lection;
    }

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);

        if(adapter == null) {
            adapter = new LectionDictionaryAdapter(getContext());
        }

    }


    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        initData();
    }

    private void initData() {
        modelView = ViewModelProviders.of(this, new ViewModelFactory(getActivity().getApplication(), lection.getId())).get(LectionDictionaryViewModel.class);
        modelView.getWordList().observe(this, new Observer<List<Word>>() {
            @Override
            public void onChanged(@Nullable List<Word> wordList) {
                adapter.setWordList(wordList);
            }
        });
    }



    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {

        View rootView = inflater.inflate(R.layout.fragment_lection_word_list, container, false);

        TextView toolbarTitleView = rootView.findViewById(R.id.toolbar_title);
        toolbarTitleView.setText(lection.getTitle());


        detailFragment = new LectionDetailFragment();
        detailFragment.setParentFragment(this);

        listView = rootView.findViewById(R.id.lection_dictionary_list);
        listView.setAdapter(adapter);
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {

                Word word = adapter.getWordList().get(position);
                detailFragment.modelView = modelView;
                detailFragment.setDetailData(word, getLabel(word));
                selectedPosition = position;

                if(!detailFragment.isAdded()) {
                    FragmentTransaction ft = getActivity().getSupportFragmentManager().beginTransaction();
                    ft.add(R.id.viewLayout, detailFragment);
                    ft.addToBackStack("DictionaryDetailFragment").commit();
                }
            }
        });


        return rootView;

    }

    public void videoForward() {

        selectedPosition++;

        if(selectedPosition >= adapter.getWordList().size())
            selectedPosition = 0;

        Word word = adapter.getWordList().get(selectedPosition);
        detailFragment.setDetailData(word, getLabel(word));
        getActivity().getSupportFragmentManager().beginTransaction().detach(detailFragment).attach(detailFragment).commit();
    }

    public void videoBackward() {

        selectedPosition--;

        if(selectedPosition <= -1)
            selectedPosition = adapter.getWordList().size() - 1;

        Word word = adapter.getWordList().get(selectedPosition);
        detailFragment.setDetailData(word, getLabel(word));
        getActivity().getSupportFragmentManager().beginTransaction().detach(detailFragment).attach(detailFragment).commit();
    }

    private String getLabel(Word word) {

        int index = adapter.getWordList().indexOf(word) + 1;
        String label = index + "/" + adapter.getWordList().size();

        return label;
    }

}