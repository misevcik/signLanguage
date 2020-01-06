package sk.doreto.signlanguage.ui.education;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.List;

import sk.doreto.signlanguage.R;
import sk.doreto.signlanguage.database.AppDatabase;
import sk.doreto.signlanguage.database.Word;
import sk.doreto.signlanguage.ui.common.GeneralDictionaryDetailFragment;
import sk.doreto.signlanguage.ui.common.IDictionaryFragment;

import static android.widget.ListPopupWindow.MATCH_PARENT;

public class LectionDetailFragment extends GeneralDictionaryDetailFragment {


    public LectionDictionaryViewModel modelView;

    private String counterLabel;

    public LectionDetailFragment() {
    }


    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {

        View rootView = super.onCreateView(inflater, container, savedInstanceState);
        View customToolbar = inflater.inflate(R.layout.toolbar_lection_detail, null, false);

        LinearLayout toolbar = rootView.findViewById(R.id.dictionary_detail_toolbar);
        toolbar.addView(customToolbar, MATCH_PARENT, MATCH_PARENT);

        TextView dictionaryTitle = toolbar.findViewById(R.id.dictionary_detail_word_title);
        dictionaryTitle.setText(word.getWord());

        TextView wordOrder = toolbar.findViewById(R.id.word_order_in_lection);
        wordOrder.setText(counterLabel);

        return rootView;
    }

    public void setDetailData(Word word, String counterLabel) {

        this.counterLabel = counterLabel;

        if(!word.getVisited()) {
           word.setVisited(true);
           modelView.update(word);
        }

        super.setDetailData(word);
    }



}
