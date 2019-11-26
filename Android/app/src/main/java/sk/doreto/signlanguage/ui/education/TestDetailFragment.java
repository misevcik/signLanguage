package sk.doreto.signlanguage.ui.education;

import android.content.Context;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;


import sk.doreto.signlanguage.R;
import sk.doreto.signlanguage.database.AppDatabase;
import sk.doreto.signlanguage.database.Lection;
import sk.doreto.signlanguage.database.Word;


public class TestDetailFragment extends Fragment {

    private int MAX_ANSWER = 3;

    private class AnswerItem {
        String answerText;
        boolean isCorrect;
    }

    private class TestItem {
        List<AnswerItem> answerList;
        int selectedAnswer = -1;
        int videoResourcePath;
    }

    private Lection lection;
    private int wordCount;
    private List<TestItem> testItems;

    public TestDetailFragment(Lection lection) {
        this.lection = lection;

    }

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        //TODO - consider to use model view
        loadTestData();

    }

    public View onCreateView(@NonNull LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {

        View root = inflater.inflate(R.layout.fragment_test_detail, container, false);

        return root;
    }

    private void loadTestData() {

        List<Word> wordList = AppDatabase.getAppDatabase(getContext()).wordDao().getWordsForLection(lection.getId());
        wordCount = wordList.size();

        int maxTestCount = wordCount / 3;

        for(int i = 0; i < maxTestCount; ++i) {

            final int correctAnswerIndex =  new Random().nextInt(1); //nextInt((max - min) + 1) + min;
            final ArrayList<Integer> randomIndexes = getIndexsForAnswer(wordCount);

            Log.e("","");
        }

    }

    private ArrayList<Integer> getIndexsForAnswer(int range) {

        final int min = 0;
        final int max = range;

        ArrayList<Integer> randomIndexes = new ArrayList<>();

        for(int i = 0; i < MAX_ANSWER; ++i) {
            int random;

            do {
                random = new Random().nextInt((max - min) + 1) + min;
            } while(randomIndexes.contains(random));
            randomIndexes.add(random);
        }

        return randomIndexes;

    }

}
