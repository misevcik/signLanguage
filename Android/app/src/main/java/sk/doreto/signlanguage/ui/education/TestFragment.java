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
import sk.doreto.signlanguage.ui.common.ITestFragment;
import sk.doreto.signlanguage.utils.Utility;

public class TestFragment extends Fragment implements ITestFragment {

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

                if(lection.getTestScore() != -1) { //Test was already passed
                    showTestResult(lection);
                    return;
                }

                createTestDetailFragment(lection);

            }
        });

        return view;
    }

    public void repeatTest(Lection lection) {
        getActivity().getSupportFragmentManager().popBackStackImmediate();
        getActivity().getSupportFragmentManager().popBackStackImmediate();

        createTestDetailFragment(lection);

    }

    private void showTestResult(Lection lection) {

        TestStatisticsFragment result = new TestStatisticsFragment(lection);
        result.setOnFinishClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                getActivity().getSupportFragmentManager().popBackStackImmediate();
            }
        });

        result.setOnRepeatClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                getActivity().getSupportFragmentManager().popBackStackImmediate();
                createTestDetailFragment(lection);
            }
        });

        FragmentTransaction ft = getActivity().getSupportFragmentManager().beginTransaction();
        ft.add(R.id.viewLayout, result);
        ft.addToBackStack("TestStatisticsFragment").commit();
    }

    private void createTestDetailFragment(Lection lection) {

        TestDetailFragment testDetailFragment = new TestDetailFragment(TestFragment.this, lection);
        testDetailFragment.modelView = modelView;
        FragmentTransaction ft = getActivity().getSupportFragmentManager().beginTransaction();
        ft.add(R.id.viewLayout, testDetailFragment);
        ft.addToBackStack("TestDetailFragment").commit();

    }

}