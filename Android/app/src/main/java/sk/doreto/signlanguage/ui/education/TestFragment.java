package sk.doreto.signlanguage.ui.education;

import android.content.Context;
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
import androidx.lifecycle.Observer;
import androidx.lifecycle.ViewModelProviders;

import java.util.List;

import sk.doreto.signlanguage.NavigationBarController;
import sk.doreto.signlanguage.R;
import sk.doreto.signlanguage.database.AppDatabase;
import sk.doreto.signlanguage.database.Lection;
import sk.doreto.signlanguage.utils.Utility;

public class TestFragment extends Fragment {

    public static TestFragment newInstance() {
        return new TestFragment();
    }

    private TestAdapter adapter;
    private ListView listView;

    private LectionViewModel modelView;
    private NavigationBarController navigationBarController;

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);

        try {
            navigationBarController = (NavigationBarController) context;
        } catch (ClassCastException castException) {
        }

        if(adapter == null) {
            adapter = new TestAdapter(getContext());
        }
    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        initData();
    }

    private void initData() {

        modelView = ViewModelProviders.of(this).get(LectionViewModel.class);
        modelView.getWordList().observe(this, new Observer<List<Lection>>() {
            @Override
            public void onChanged(@Nullable List<Lection> lections) {
                adapter.setLectionList(lections);
            }
        });

    }


    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {

        View view = inflater.inflate(R.layout.fragment_test, container, false);

        listView = view.findViewById(R.id.test_list);
        listView.setAdapter(adapter);
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {

                Utility.preventTwoClick(listView);

                navigationBarController.hideBar();

                Lection lection = adapter.getItem(position);

                TestDetailFragment testDetailFragment = new TestDetailFragment(lection);
                testDetailFragment.modelView = modelView;
                FragmentTransaction ft = getActivity().getSupportFragmentManager().beginTransaction();
                ft.add(R.id.viewLayout, testDetailFragment);
                ft.addToBackStack("TestDetailFragment").commit();
            }
        });

        return view;
    }

}