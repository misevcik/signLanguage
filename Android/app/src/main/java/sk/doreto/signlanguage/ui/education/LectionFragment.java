package sk.doreto.signlanguage.ui.education;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.GridLayout;
import android.widget.GridView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;

import java.util.List;

import sk.doreto.signlanguage.R;
import sk.doreto.signlanguage.database.AppDatabase;
import sk.doreto.signlanguage.database.Lection;


public class LectionFragment extends Fragment {

    private LectionAdapter adapter;
    private GridView gridView;

    public static LectionFragment newInstance() {
        return new LectionFragment();
    }

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {

        View rootView = inflater.inflate(R.layout.fragment_lection, container, false);

        //TODO - use ModelView https://www.thomaskioko.com/android-livedata-viewmodel/
        List<Lection> lectionList = AppDatabase.getAppDatabase(getContext()).lectionDao().getAll();

        adapter = new LectionAdapter(lectionList, getContext());
        gridView = rootView.findViewById(R.id.lection_grid);
        gridView.setAdapter(adapter);

        return rootView;
    }

}
