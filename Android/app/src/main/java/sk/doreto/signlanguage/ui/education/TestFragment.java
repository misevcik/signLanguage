package sk.doreto.signlanguage.ui.education;

import android.content.Context;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.lifecycle.Observer;
import androidx.lifecycle.ViewModelProviders;

import java.util.List;

import sk.doreto.signlanguage.R;
import sk.doreto.signlanguage.database.Lection;

public class TestFragment extends Fragment {

    public static TestFragment newInstance() {
        return new TestFragment();
    }

    private TestAdapter adapter;
    private ListView listView;

    private LectinViewModel modelView;

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);

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

        modelView = ViewModelProviders.of(this).get(LectinViewModel.class);
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

        return view;
    }

}