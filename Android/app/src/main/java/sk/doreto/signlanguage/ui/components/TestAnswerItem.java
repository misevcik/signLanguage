package sk.doreto.signlanguage.ui.components;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.LinearLayout;
import android.widget.TextView;

import sk.doreto.signlanguage.R;

public class TestAnswerItem extends LinearLayout {

    private TextView answerText;
    private LinearLayout layout;

    public TestAnswerItem(Context context, AttributeSet attrs) {
        super(context, attrs);
        init(context, attrs);
    }

    public void reset() {
        layout.setBackgroundResource(R.drawable.test_answer_round_white);
    }

    public void clicked() {
        layout.setBackgroundResource(R.drawable.test_answer_round_gray);
    }

    private void init(Context context, AttributeSet attrs) {

        inflate(context, R.layout.test_answer_item, this);
        initComponents();
    }

    private void initComponents() {
        answerText = findViewById(R.id.answer_text);
        layout = findViewById(R.id.answer_layout);

    }

    public void setAnswer(String answerText) {
        this.answerText.setText(answerText);
    }
}
