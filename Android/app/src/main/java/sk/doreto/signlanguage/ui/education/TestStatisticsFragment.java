package sk.doreto.signlanguage.ui.about;

import android.content.Context;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;

import java.util.Date;

import sk.doreto.signlanguage.NavigationBarController;
import sk.doreto.signlanguage.R;
import sk.doreto.signlanguage.ui.components.TestResultItem;
import sk.doreto.signlanguage.ui.components.TestResultItemSummary;


public class TestStatisticsFragment extends Fragment {

    private NavigationBarController navigationBarController;
    private TestResultItemSummary mTestSummary;
    private TestResultItem mTestDate;
    private TestResultItem mCorrectAnswers;
    private TestResultItem mWrongAnswers;
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
        mTestSummary = rootView.findViewById(R.id.test_item_summary);
        mTestDate = rootView.findViewById(R.id.test_item_date);
        mCorrectAnswers = rootView.findViewById(R.id.test_item_correct);
        mWrongAnswers = rootView.findViewById(R.id.test_item_wrong);
        return rootView;
    }

    public void setStatistics(Date date, int score){
        mTestSummary.setValue(score);
        mTestDate.setValue("Date", date.toString());
        mCorrectAnswers.setValue("Correct", String.valueOf(score));
        mWrongAnswers.setValue("Wrong", String.valueOf(score));
    }
}
