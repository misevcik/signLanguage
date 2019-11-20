package sk.doreto.signlanguage.ui.education;

import android.content.Context;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.GridView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentTransaction;
import androidx.lifecycle.Observer;
import androidx.lifecycle.ViewModelProviders;

import java.util.List;

import sk.doreto.signlanguage.NavigationBarController;
import sk.doreto.signlanguage.R;
import sk.doreto.signlanguage.database.Lection;


public class LectionFragment extends Fragment {

    private LectionAdapter adapter;
    private GridView gridView;
    private NavigationBarController navigationBarController;

    public static LectionFragment newInstance() {
        return new LectionFragment();
    }

    private LectinViewModel modelView;

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
        try {
            navigationBarController = (NavigationBarController) context;
        } catch (ClassCastException castException) {
            /** The activity does not implement the listener. */
        }

        if(adapter == null) {
            adapter = new LectionAdapter(getContext());
        }
    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        initData();
    }


    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {

        View rootView = inflater.inflate(R.layout.fragment_lection, container, false);

        gridView = rootView.findViewById(R.id.lection_grid);
        gridView.setAdapter(adapter);

        gridView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View v, int position, long id) {

                navigationBarController.hideBar();
                Lection lection = adapter.getLectinList().get(position);
                LectionWordListFragment lectionWordListFragment = new LectionWordListFragment(lection);

                FragmentTransaction ft = getActivity().getSupportFragmentManager().beginTransaction();
                ft.add(R.id.viewLayout, lectionWordListFragment);
                ft.addToBackStack("LectionWordListFragment").commit();

            }
        });

        return rootView;
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

}
