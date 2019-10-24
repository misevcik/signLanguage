package sk.doreto.signlanguage.ui.education;

import android.content.Context;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.GridLayout;
import android.widget.GridView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentTransaction;

import java.util.List;

import sk.doreto.signlanguage.NavigationBarController;
import sk.doreto.signlanguage.R;
import sk.doreto.signlanguage.database.AppDatabase;
import sk.doreto.signlanguage.database.Lection;


public class LectionFragment extends Fragment {

    private LectionAdapter adapter;
    private GridView gridView;
    private NavigationBarController navigationBarController;

    private List<Lection> lectionList;


    public static LectionFragment newInstance() {
        return new LectionFragment();
    }

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
        try {
            navigationBarController = (NavigationBarController) context;
        } catch (ClassCastException castException) {
            /** The activity does not implement the listener. */
        }
    }

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {

        View rootView = inflater.inflate(R.layout.fragment_lection, container, false);

        //TODO - use ModelView https://www.thomaskioko.com/android-livedata-viewmodel/
        lectionList = AppDatabase.getAppDatabase(getContext()).lectionDao().getAll();

        adapter = new LectionAdapter(lectionList, getContext());
        gridView = rootView.findViewById(R.id.lection_grid);
        gridView.setAdapter(adapter);

        gridView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View v, int position, long id) {

                navigationBarController.hideBar();
                LectionDetailFragment lectionDetailFragment = new LectionDetailFragment();
                lectionDetailFragment.setDetailData(lectionList.get(position));

                FragmentTransaction ft = getActivity().getSupportFragmentManager().beginTransaction();
                ft.add(R.id.viewLayout, lectionDetailFragment);
                ft.addToBackStack("LectionDetailFragment").commit();

            }
        });

        return rootView;
    }

}
