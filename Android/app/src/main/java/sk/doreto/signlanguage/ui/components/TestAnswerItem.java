package sk.doreto.signlanguage.ui.components;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import sk.doreto.signlanguage.R;
import sk.doreto.signlanguage.ui.education.QuestionItem;

public class TestAnswerItem extends LinearLayout {

    private TextView answerText;
    private TextView answerStatus;
    private RelativeLayout layout;
    private boolean isCorect = false;

    public TestAnswerItem(Context context, AttributeSet attrs) {
        super(context, attrs);
        init(context, attrs);
    }

    public void reset() {
        layout.setBackgroundResource(R.drawable.test_answer_round_white);
        answerStatus.setVisibility(INVISIBLE);
    }

    public void clicked() {
        layout.setBackgroundResource(R.drawable.test_answer_round_gray);
    }

    public void showRightAnswer() {
        layout.setBackgroundResource(R.drawable.test_answer_round_green);
    }


    public void selectWrongAnswer() {
        layout.setBackgroundResource(R.drawable.test_answer_round_red);
        answerStatus.setText("Nespravna");
        answerStatus.setVisibility(VISIBLE);
    }

    public void selectRightAnswer() {
        layout.setBackgroundResource(R.drawable.test_answer_round_green);
        answerStatus.setText("Spravna");
        answerStatus.setVisibility(VISIBLE);
    }

    private void init(Context context, AttributeSet attrs) {

        inflate(context, R.layout.test_answer_item, this);
        initComponents();
    }

    private void initComponents() {

        layout = findViewById(R.id.answer_layout);
        answerText = findViewById(R.id.answer_text);
        answerStatus = findViewById(R.id.answer_status);

    }

    public void setValue(QuestionItem.AnswerItem item){
        this.answerText.setText(item.answerText);
        this.isCorect = item.isCorrect;
    }
    public boolean isCorrect(){return isCorect;}
}
