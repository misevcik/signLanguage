package sk.doreto.signlanguage.ui.education;

import android.content.Context;
import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.Bundle;
import android.text.format.DateUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.MediaController;
import android.widget.TextView;
import android.widget.VideoView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import java.util.Timer;
import java.util.TimerTask;


import sk.doreto.signlanguage.R;
import sk.doreto.signlanguage.VideoPlayerActivity;
import sk.doreto.signlanguage.database.AppDatabase;
import sk.doreto.signlanguage.database.Lection;
import sk.doreto.signlanguage.database.Word;
import sk.doreto.signlanguage.ui.components.TestAnswerControllerView;
import sk.doreto.signlanguage.utils.Utility;


public class TestDetailFragment extends Fragment {

    private int MAX_ANSWER_COUNT = 3;

    private int wordCount;
    private int questionCollectionSize;
    private int currentQuestionIndex = 0;
    private int timeElapsedSecond = 0;
    private Timer timer;
    private TextView testTime;
    private ImageView videoPreview;
    private ImageButton playButton;
    private Lection lection;
    private List<QuestionItem> questionCollection = new ArrayList<>();

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

        loadTestData(); //TODO - consider to use model view
        startTimer();

    }

    @Override
    public View onCreateView(@NonNull LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {

        View root = inflater.inflate(R.layout.fragment_test_detail, container, false);

        TestAnswerControllerView testAnswerController = root.findViewById(R.id.testAnswerControllerView);
        testAnswerController.fillData(questionCollection.get(currentQuestionIndex));

        testTime = root.findViewById(R.id.test_time);

        videoPreview = root.findViewById(R.id.video_preview);
        playButton = root.findViewById(R.id.video_play);
        playButton.setOnClickListener(new View.OnClickListener()   {
            public void onClick(View v)  {
                videoPlay();
            }
        });

        drawThumbnail();


        return root;
    }

    @Override
    public void onDestroy() {
        super.onDestroy();

        timer.cancel();

    }

    private void startTimer() {

        timer = new Timer();
        timer.scheduleAtFixedRate(new TimerTask() {
            @Override
            public void run() {
                if(testTime != null) {
                    ++timeElapsedSecond;

                    StringBuilder str = new StringBuilder();
                    DateUtils.formatElapsedTime(str, timeElapsedSecond);

                    getActivity().runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            testTime.setText(str.toString());
                        }
                    });
                }
            }
        }, 0, 1000);

    }


    private void videoPlay() {
        Intent videoPlaybackActivity = new Intent(getContext(), VideoPlayerActivity.class);

        String videoRaw = questionCollection.get(currentQuestionIndex).video;

        String videoPath = "android.resource://" + getContext().getPackageName() + "/" + Utility.getResourceId(getContext(), videoRaw, "raw");
        videoPlaybackActivity.putExtra("videoPath", videoPath);
        startActivity(videoPlaybackActivity);
    }

    private void drawThumbnail() {
        String videoRaw = questionCollection.get(currentQuestionIndex).video;
        Drawable drawable = Utility.getThumbnail(getContext(), videoRaw);
        videoPreview.setImageDrawable(drawable);
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
                    questionItem.video = "2131689472"; //TODO word.getVideoFront();
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
