package sk.doreto.signlanguage.ui.common;

import android.content.Context;
import android.content.res.Resources;
import android.os.Bundle;
import android.os.Handler;
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

    protected int toolbarTitleId;
    protected DictionaryAdapter adapter;
    protected GeneralDictionaryDetailFragment detailFragment;

    private ListView listView;
    private SearchView searchView;
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

        View rootView = inflater.inflate(R.layout.fragment_dictionary, container, false);
        TextView toolbarTitleView = rootView.findViewById(R.id.toolbar_title);

        Resources res = getContext().getResources();
        toolbarTitleView.setText(res.getString(toolbarTitleId));

        listView = rootView.findViewById(R.id.dictionary_list);
        listView.setAdapter(adapter);

        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {

            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {

                preventTwoClick(listView);

                navigationBarController.hideBar();
                detailFragment.setDetailData(adapter.getWordList().get(position));
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

        Word word;

        while(true) {

            if(selectedPosition >= listView.getCount() - 1)
                selectedPosition = 0;

            word = adapter.getWordList().get(++selectedPosition);
            if(!word.isSection())
                break;

        }


        detailFragment.setDetailData(word);
        getActivity().getSupportFragmentManager().beginTransaction().detach(detailFragment).attach(detailFragment).commit();
    }

    public void videoBackward() {

        Word word;

        while(true) {

            if (selectedPosition <= 0)
                selectedPosition = listView.getCount();

            word = adapter.getWordList().get(--selectedPosition);
            if (!word.isSection())
                break;
        }

        detailFragment.setDetailData(word);
        getActivity().getSupportFragmentManager().beginTransaction().detach(detailFragment).attach(detailFragment).commit();
    }

    public void updateContent(Word word) {
        this.adapter.notifyDataSetChanged();
    }

    private static void preventTwoClick(final View view){
        view.setEnabled(false);
        view.postDelayed(new Runnable() {
            public void run() {
                view.setEnabled(true);
            }
        }, 500);
    }

    public void setListVisibility() {

        if(adapter.getWordList() == null || adapter.getWordList().isEmpty()) {
            listView.setVisibility(View.GONE);
        } else {
            listView.setVisibility(View.VISIBLE);
        }
    }

}