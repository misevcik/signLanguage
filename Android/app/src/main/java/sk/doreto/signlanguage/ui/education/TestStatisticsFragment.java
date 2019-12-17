package sk.doreto.signlanguage.ui.education;

import android.content.Context;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;

import java.text.DateFormat;
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
    private Date mDate;
    private int mScore;
    private View.OnClickListener mOnRepeatTestEvent = null;
    private View.OnClickListener mOnFinishTestEvent = null;
    private Button mRepeatTest;
    private Button mFinishTest;

    public TestStatisticsFragment(Date date, int score){
        mDate = date;
        mScore = score;
    }

    public void setOnFinishClickListener(View.OnClickListener l) {
        mOnFinishTestEvent = l;
    }

    public void setOnRepeatClickListener(View.OnClickListener l) {
        mOnRepeatTestEvent = l;
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

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(@NonNull LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {

        View rootView = inflater.inflate(R.layout.fragment_test_statistics, container, false);
        mTestSummary = rootView.findViewById(R.id.test_item_summary);
        mTestSummary.setValue(mScore);
        mTestDate = rootView.findViewById(R.id.test_item_date);
        mTestDate.setValue("Date", DateFormat.getDateInstance().format(mDate));
        mCorrectAnswers = rootView.findViewById(R.id.test_item_correct);
        mCorrectAnswers.setValue("Correct", String.valueOf(mScore));
        mWrongAnswers = rootView.findViewById(R.id.test_item_wrong);
        mWrongAnswers.setValue("Wrong", String.valueOf(mScore));
        mRepeatTest = rootView.findViewById(R.id.btn_repeat_test);
        mFinishTest = rootView.findViewById(R.id.btn_finish_test);
        mRepeatTest.setOnClickListener( mOnRepeatTestEvent);
        mFinishTest.setOnClickListener( mOnFinishTestEvent);
        return rootView;
    }
}
