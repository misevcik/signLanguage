package sk.doreto.signlanguage.ui.education;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;

import androidx.annotation.NonNull;
import androidx.fragment.app.DialogFragment;


import sk.doreto.signlanguage.R;

public class TestFinishFragment extends DialogFragment {

    private View.OnClickListener finishTestEvent = null;
    private View.OnClickListener continueTestEvent = null;
    private Button continueTest;
    private Button finishTest;

    public void setOnFinishClickListener(View.OnClickListener l) {
        finishTestEvent = l;
    }

    public void setOnContinueClickListener(View.OnClickListener l) {
        continueTestEvent = l;
    }


    @Override
    public View onCreateView(@NonNull LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {

        View root = inflater.inflate(R.layout.fragment_finish_test, container, false);
        continueTest = root.findViewById(R.id.btn_continue_test);
        finishTest = root.findViewById(R.id.btn_finish_test);

        continueTest.setOnClickListener(continueTestEvent);
        finishTest.setOnClickListener(finishTestEvent);

        return root;
    }
}
