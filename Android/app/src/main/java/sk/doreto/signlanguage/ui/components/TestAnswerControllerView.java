package sk.doreto.signlanguage.ui.components;

import android.content.Context;
import android.util.AttributeSet;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;

import java.util.ArrayList;

import sk.doreto.signlanguage.R;
import sk.doreto.signlanguage.ui.education.QuestionItem;


public class TestAnswerControllerView extends LinearLayout {

    private TextView quistionText;
    private ArrayList<TestAnswerItem> answerItems = new ArrayList<TestAnswerItem>(3);


    public TestAnswerControllerView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init(context, attrs);

    }

    public void fillData(QuestionItem questionItem) {

        int index = 0;
        for (QuestionItem.AnswerItem item : questionItem.answerCollection) {
            answerItems.get(index++).setAnswer(item.answerText);
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
                    ((TestAnswerItem) v).clicked();
                }
            });
        }
    }

}
