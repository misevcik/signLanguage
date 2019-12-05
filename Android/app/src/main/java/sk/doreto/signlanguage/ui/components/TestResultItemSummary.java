package sk.doreto.signlanguage.ui.components;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import sk.doreto.signlanguage.R;

public class TestResultItemSummary extends LinearLayout {

    private TextView mResultPercent;
    private ImageView mImage;

    public TestResultItemSummary(Context context, AttributeSet attrs) {
        super(context, attrs);
        init(context, attrs);
    }

    private void init(Context context, AttributeSet attrs) {

        inflate(context, R.layout.test_result_item_summary, this);
        initComponents();
    }

    private void initComponents() {
        mResultPercent = findViewById(R.id.test_result_summary_percent);
        mImage = findViewById(R.id.test_result_summary_image);
    }

    public void setValue(double percent){
        String mark = "F";
        this.mResultPercent.setText(Double.toString(percent) + " % " + mark);
        mImage.setImageResource(R.drawable.eu_logo);
    }
}
