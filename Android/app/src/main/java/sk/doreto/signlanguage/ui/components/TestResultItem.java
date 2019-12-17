package sk.doreto.signlanguage.ui.components;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.LinearLayout;
import android.widget.TextView;

import sk.doreto.signlanguage.R;
import sk.doreto.signlanguage.ui.education.QuestionItem;

public class TestResultItem extends LinearLayout {


    private TextView mResultText;
    private TextView mResultValue;

    public TestResultItem(Context context, AttributeSet attrs) {
        super(context, attrs);
        init(context, attrs);
    }

    private void init(Context context, AttributeSet attrs) {

        inflate(context, R.layout.test_result_item, this);
        initComponents();
    }

    private void initComponents() {
        mResultText = findViewById(R.id.test_result_title);
        mResultValue = findViewById(R.id.test_result_value);
    }

    public void setValue(String name, String value){
        this.mResultText.setText(name);
        this.mResultValue.setText(value);
    }
}
