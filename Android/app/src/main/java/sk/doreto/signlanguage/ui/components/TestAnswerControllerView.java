package sk.doreto.signlanguage.ui.components;

import android.content.Context;
import android.content.res.Resources;
import android.os.Handler;
import android.util.AttributeSet;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;

import java.util.ArrayList;
import java.util.List;

import sk.doreto.signlanguage.R;
import sk.doreto.signlanguage.ui.common.ITestDetailFragment;
import sk.doreto.signlanguage.ui.education.QuestionItem;


public class TestAnswerControllerView extends LinearLayout {

    private ITestDetailFragment testDetailFragment;
    private TextView pageText;
    private ArrayList<TestAnswerItem> answerItems = new ArrayList<TestAnswerItem>(3);
    private List<QuestionItem> questionList;
    private int questionsCount;
    private int rightAnswers = 0;


    public TestAnswerControllerView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init(context, attrs);

    }

    public void setFinishCallback(ITestDetailFragment testDetailFragment) {
        this.testDetailFragment = testDetailFragment;
    }


    public void callbackFinished() {

        double score = (double)rightAnswers / questionsCount * 100.0;
        testDetailFragment.finishTest((int) score);
    }

    public void fillTestData(List<QuestionItem> questions){

        if (!questions.isEmpty()) {
            questionsCount = questions.size();
            questionList = questions;
            QuestionItem questionItem = questionList.remove(0);
            fillData(questionItem);
        }
    }

    private void fillData(QuestionItem questionItem) {

        int index = 0;
        for (QuestionItem.AnswerItem item : questionItem.answerCollection) {
            answerItems.get(index).reset();
            answerItems.get(index).setValue(item);
            ++index;
        }

        Resources res = getContext().getResources();
        pageText.setText(String.format(res.getString(R.string.test_page), (questionsCount - questionList.size()), questionsCount));
    }

    private void init(Context context, AttributeSet attrs) {

        inflate(context, R.layout.test_answer_controller_view, this);
        initComponents();
    }

    private void initComponents() {

        pageText = findViewById(R.id.page_text);
        answerItems.add(findViewById(R.id.answer_item_1));
        answerItems.add(findViewById(R.id.answer_item_2));
        answerItems.add(findViewById(R.id.answer_item_3));

        for (TestAnswerItem item : answerItems) {
            item.setOnClickListener(new OnClickListener() {
                @Override
                public void onClick(View v) {

                    enableClick(false);

                    TestAnswerItem clickedItem = ((TestAnswerItem) v);
                    clickedItem.clicked();

                    //Show answer
                    new Handler().postDelayed(new Runnable() {
                        @Override
                        public void run() {
                            evaluateAnswer(clickedItem);
                        }
                    }, 1000);

                    if (!questionList.isEmpty()) {
                        new Handler().postDelayed(new Runnable() {
                            @Override
                            public void run() {
                                fillData(questionList.remove(0));
                                enableClick(true);
                            }
                        }, 2000);
                    }
                }
            });
        }
    }

    private void evaluateAnswer(TestAnswerItem clickedItem) {

        if(clickedItem.isCorrect()) {
            clickedItem.selectRightAnswer();
            ++rightAnswers;
        } else {
            clickedItem.selectWrongAnswer();
            for (TestAnswerItem item : answerItems) {
                if(item.isCorrect()) {
                    item.showRightAnswer();
                }
            }
        }
        if (questionList.isEmpty()){
            callbackFinished();
        }

    }

    private void enableClick(boolean enabled) {
        for (TestAnswerItem item : answerItems) {
            item.setEnabled(enabled);
        }
    }

}
