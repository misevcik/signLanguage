package sk.doreto.signlanguage.ui.education;

import android.content.Context;
import android.os.Bundle;
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
import sk.doreto.signlanguage.ui.components.TestAnswerControllerView;


public class TestDetailFragment extends Fragment {

    private int MAX_ANSWER_COUNT = 3;

    private int wordCount;
    private int questionCollectionSize;
    private int acutalQuestionIndex = 0;
    private Lection lection;
    private List<QuestionItem> questionCollection = new ArrayList<QuestionItem>();

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

        TestAnswerControllerView testAnswerController = root.findViewById(R.id.testAnswerControllerView);

        testAnswerController.fillData(questionCollection.get(acutalQuestionIndex));


        return root;
    }

    private void loadTestData() {

        List<Word> wordList = AppDatabase.getAppDatabase(getContext()).wordDao().getWordsForLection(lection.getId());
        wordCount = wordList.size();

        questionCollectionSize = wordCount / 3;

        for(int i = 0; i < questionCollectionSize; ++i) {


            QuestionItem questionItem = new QuestionItem();

            final int correctAnswerIndex =  new Random().nextInt(1); //nextInt((max - min) + 1) + min;
            final ArrayList<Integer> randomIndexes = getRandomIndexAnswer(wordCount);


            //Generate random answer per Question
            for(int answerIndex = 0; answerIndex < MAX_ANSWER_COUNT; ++answerIndex) {

                Word word = wordList.get(randomIndexes.get(answerIndex));

                QuestionItem.AnswerItem answer = new QuestionItem.AnswerItem();
                answer.answerText = word.getWord();

                if(correctAnswerIndex == answerIndex) {
                    answer.isCorrect = true;
                    questionItem.video = word.getVideoFront();
                } else {
                    answer.isCorrect = false;
                }

                questionItem.answerCollection.add(answer);

            }

            questionCollection.add(questionItem);
        }

    }

    private ArrayList<Integer> getRandomIndexAnswer(int range) {

        final int min = 0;
        final int max = range - 1;

        ArrayList<Integer> randomIndexes = new ArrayList<>();

        for(int i = 0; i < MAX_ANSWER_COUNT; ++i) {
            int random;

            do {
                random = new Random().nextInt((max - min) + 1) + min;
            } while(randomIndexes.contains(random));
            randomIndexes.add(random);
        }

        return randomIndexes;

    }

}
