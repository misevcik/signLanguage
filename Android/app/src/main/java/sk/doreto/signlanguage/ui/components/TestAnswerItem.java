package sk.doreto.signlanguage.ui.components;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.LinearLayout;
import android.widget.TextView;

import sk.doreto.signlanguage.R;
import sk.doreto.signlanguage.ui.education.QuestionItem;

public class TestAnswerItem extends LinearLayout {

    private TextView answerText;
    private LinearLayout layout;
    private boolean mIsCorect = false;

    public TestAnswerItem(Context context, AttributeSet attrs) {
        super(context, attrs);
        init(context, attrs);
    }

    public void reset() {
        layout.setBackgroundResource(R.drawable.test_answer_round_white);
    }

    public void clicked() {
        layout.setBackgroundResource(mIsCorect? R.drawable.test_answer_round_gray : R.drawable.test_answer_round_red);
    }

    private void init(Context context, AttributeSet attrs) {

        inflate(context, R.layout.test_answer_item, this);
        initComponents();
    }

    private void initComponents() {
        answerText = findViewById(R.id.answer_text);
        layout = findViewById(R.id.answer_layout);

    }

    public void setValue(QuestionItem.AnswerItem item){
        this.answerText.setText(item.answerText);
        this.mIsCorect = item.isCorrect;
    }
    public boolean isCorrect(){return mIsCorect;}
}
