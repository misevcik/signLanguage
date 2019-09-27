package sk.doreto.signlanguage.ui.dictionary;

import android.content.Context;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentTransaction;

import java.util.List;

import sk.doreto.signlanguage.NavigationBarController;
import sk.doreto.signlanguage.database.AppDatabase;
import sk.doreto.signlanguage.R;
import sk.doreto.signlanguage.database.Word;

public class DictionaryFragment extends Fragment{

    private ListView listView;
    private DictionaryAdapter adapter;
    private NavigationBarController navigationBarController;

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

        //TODO - use ModelView https://www.thomaskioko.com/android-livedata-viewmodel/
        List<Word> wordList = AppDatabase.getAppDatabase(getContext()).wordDao().getAll();
        adapter = new DictionaryAdapter(wordList, getContext());

        listView = rootView.findViewById(R.id.dictionary_list);
        listView.setAdapter(adapter);

        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {

                navigationBarController.hideBar();

                FragmentTransaction ft = getActivity().getSupportFragmentManager().beginTransaction();
                ft.add(R.id.viewLayout, new DetailDictionaryFragment());
                ft.commit();
            }
        });


        return rootView;
    }



}