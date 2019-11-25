package sk.doreto.signlanguage.ui.education;

import android.content.Context;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;
import androidx.lifecycle.LiveData;

import java.util.List;

import sk.doreto.signlanguage.R;
import sk.doreto.signlanguage.database.AppDatabase;
import sk.doreto.signlanguage.database.Lection;
import sk.doreto.signlanguage.database.Word;

public class TestDetailFragment extends Fragment {

    private Lection lection;
    private LiveData<List<Word>> words;

    public TestDetailFragment(Lection lection) {
        this.lection = lection;
    }

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);

        this.words = AppDatabase.getAppDatabase(getContext()).wordDao().getWordsForLection(lection.getId());
        return;
    }

    public View onCreateView(@NonNull LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {

        View root = inflater.inflate(R.layout.fragment_test_detail, container, false);

        return root;
    }
}
