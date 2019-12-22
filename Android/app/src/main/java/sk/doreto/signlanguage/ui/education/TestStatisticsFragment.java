package sk.doreto.signlanguage.ui.education;

import android.content.Context;

import android.content.res.Resources;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;

import java.text.DateFormat;

import sk.doreto.signlanguage.NavigationBarController;
import sk.doreto.signlanguage.R;
import sk.doreto.signlanguage.database.Lection;
import sk.doreto.signlanguage.ui.components.TestResultItem;
import sk.doreto.signlanguage.ui.components.TestResultItemSummary;
import sk.doreto.signlanguage.utils.Utility;


public class TestStatisticsFragment extends Fragment {

    private NavigationBarController navigationBarController;
    private TestResultItemSummary mTestSummary;
    private TestResultItem mTestDate;
    private TestResultItem mCorrectAnswers;
    private TestResultItem mWrongAnswers;
    private Lection lection;
    private View.OnClickListener mOnRepeatTestEvent = null;
    private View.OnClickListener mOnFinishTestEvent = null;
    private Button mRepeatTest;
    private Button mFinishTest;
    private TextView testTitle;
    private TextView testRecommendation;

    public TestStatisticsFragment(Lection lection){
        this.lection = lection;
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

        int [] result = Utility.getAnswerResultFromScore(getContext(), lection);

        View rootView = inflater.inflate(R.layout.fragment_test_statistics, container, false);
        mTestSummary = rootView.findViewById(R.id.test_item_summary);
        mTestSummary.setValue(lection.getTestScore());
        mTestDate = rootView.findViewById(R.id.test_item_date);
        mTestDate.setValue(R.string.date, DateFormat.getDateInstance().format(lection.getTestDate()));
        mCorrectAnswers = rootView.findViewById(R.id.test_item_correct);
        mCorrectAnswers.setValue(R.string.right_answers, String.valueOf(result[0]));
        mWrongAnswers = rootView.findViewById(R.id.test_item_wrong);
        mWrongAnswers.setValue(R.string.wrong_asnwers, String.valueOf(result[1]));
        mRepeatTest = rootView.findViewById(R.id.btn_repeat_test);
        mFinishTest = rootView.findViewById(R.id.btn_finish_test);
        mRepeatTest.setOnClickListener( mOnRepeatTestEvent);
        mFinishTest.setOnClickListener( mOnFinishTestEvent);
        testTitle = rootView.findViewById(R.id.test_title_text);
        testRecommendation = rootView.findViewById(R.id.test_item_recommendation);

        Resources res = getContext().getResources();
        testTitle.setText(String.format(res.getString(R.string.test_result_name), lection.getTitle()));

        if(lection.getTestScore() < 50)
            testRecommendation.setText(R.string.repeat_test);
        else if(lection.getTestScore() >= 50 && lection.getTestScore() < 80 )
            testRecommendation.setText(R.string.improve_test);
        else
            testRecommendation.setText(R.string.ok_test);

        return rootView;
    }
}
