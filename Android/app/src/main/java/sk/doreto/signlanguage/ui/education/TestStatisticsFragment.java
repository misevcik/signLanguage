package sk.doreto.signlanguage.ui.about;

import android.content.Context;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;

import sk.doreto.signlanguage.NavigationBarController;
import sk.doreto.signlanguage.R;


public class TestStatisticsFragment extends Fragment {

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

        View rootView = inflater.inflate(R.layout.fragment_test_statistics, container, false);
        return rootView;
    }
}
