package sk.doreto.signlanguage.ui.components;

import android.content.Context;
import android.os.Handler;
import android.util.AttributeSet;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;

import java.util.ArrayList;
import java.util.List;

import sk.doreto.signlanguage.R;
import sk.doreto.signlanguage.ui.education.QuestionItem;


public class TestAnswerControllerView extends LinearLayout {

    private TextView quistionText;
    private ArrayList<TestAnswerItem> answerItems = new ArrayList<TestAnswerItem>(3);
    private List<QuestionItem> mQuestions;
    private ArrayList<QuestionItem> mAnswered = new ArrayList<>();

    public TestAnswerControllerView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init(context, attrs);

    }

    public void callbackFinished(){

    }

    public void fillData(List<QuestionItem> questions){
        if (!questions.isEmpty()) {
            mQuestions = questions;
            QuestionItem questionItem = mQuestions.remove(0);
            mAnswered.clear();
            mAnswered.add(questionItem);
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
    }

    private void init(Context context, AttributeSet attrs) {

        inflate(context, R.layout.test_answer_controller_view, this);
        initComponents();
    }

    private void initComponents() {

        quistionText = findViewById(R.id.question_text);
        answerItems.add(findViewById(R.id.answer_item_1));
        answerItems.add(findViewById(R.id.answer_item_2));
        answerItems.add(findViewById(R.id.answer_item_3));

        for (TestAnswerItem item : answerItems) {
            item.setOnClickListener(new OnClickListener() {
                @Override
                public void onClick(View v) {

                    enableClick(false);

                    TestAnswerItem clickediItem = ((TestAnswerItem) v);
                    clickediItem.clicked();

                    //Show answer
                    new Handler().postDelayed(new Runnable() {
                        @Override
                        public void run() {
                            evaluateAnswer(clickediItem);
                        }
                    }, 1000);

                    if (!mQuestions.isEmpty()) {
                        new Handler().postDelayed(new Runnable() {
                            @Override
                            public void run() {
                                fillData(mQuestions.remove(0));
                                enableClick(true);
                            }
                        }, 3000);
                    }
                }
            });
        }
    }

    private void evaluateAnswer(TestAnswerItem clickediItem) {

        if(clickediItem.isCorrect()) {
            clickediItem.selectRightAnswer();
        } else {

            clickediItem.selectWrongAnswer();
            for (TestAnswerItem item : answerItems) {
                if(item.isCorrect()) {
                    item.showRightAnswer();
                }
            }
        }

    }

    private void enableClick(boolean enabled) {
        for (TestAnswerItem item : answerItems) {
            item.setEnabled(enabled);
        }
    }

}
