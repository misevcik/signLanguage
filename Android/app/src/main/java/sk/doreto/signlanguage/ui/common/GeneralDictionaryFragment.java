package sk.doreto.signlanguage.ui.common;

import android.content.Context;
import android.content.res.Resources;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.SearchView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentTransaction;

import java.util.List;

import sk.doreto.signlanguage.NavigationBarController;
import sk.doreto.signlanguage.R;
import sk.doreto.signlanguage.database.Word;

public class GeneralDictionaryFragment extends Fragment implements IDictionaryFragment {

    protected List<Word> wordList;
    protected int toolbarTitleId;
    protected GeneralDictionaryDetailFragment detailFragment;

    private ListView listView;
    private SearchView searchView;
    private DictionaryAdapter adapter;
    private NavigationBarController navigationBarController;

    private int selectedPosition = -1;

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
        try {
            navigationBarController = (NavigationBarController) context;
        } catch (ClassCastException castException) {
            /** The activity does not implement the listener. */
        }
    }

    public View onCreateView(@NonNull LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {

        //TODO - use ModelView https://www.thomaskioko.com/android-livedata-viewmodel/

        View rootView = inflater.inflate(R.layout.fragment_dictionary, container, false);
        TextView toolbarTitleView = rootView.findViewById(R.id.toolbar_title);

        Resources res = getContext().getResources();
        toolbarTitleView.setText(res.getString(toolbarTitleId));

        adapter = new DictionaryAdapter(wordList, getContext());

        listView = rootView.findViewById(R.id.dictionary_list);
        listView.setAdapter(adapter);

        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {

                navigationBarController.hideBar();
                detailFragment.setDetailData(wordList.get(position));
                selectedPosition = position;

                FragmentTransaction ft = getActivity().getSupportFragmentManager().beginTransaction();
                ft.add(R.id.viewLayout, detailFragment);
                ft.addToBackStack("DictionaryDetailFragment").commit();
            }
        });

        searchView = rootView.findViewById(R.id.dictionary_search);
        searchView.setOnQueryTextListener(new SearchView.OnQueryTextListener() {
            @Override
            public boolean onQueryTextSubmit(String s) {
                return false;
            }

            @Override
            public boolean onQueryTextChange(String s) {

                adapter.getFilter().filter(s);
                return false;
            }
        });


        return rootView;
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