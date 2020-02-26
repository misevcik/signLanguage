package sk.doreto.signlanguage.ui.education;

import android.content.Context;
import android.content.Intent;
import android.content.res.Configuration;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.text.format.DateUtils;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Random;
import java.util.Timer;
import java.util.TimerTask;


import sk.doreto.signlanguage.R;
import sk.doreto.signlanguage.VideoPlayerActivity;
import sk.doreto.signlanguage.database.AppDatabase;
import sk.doreto.signlanguage.database.Lection;
import sk.doreto.signlanguage.database.Word;
import sk.doreto.signlanguage.ui.common.ITestDetailFragment;
import sk.doreto.signlanguage.ui.common.ITestFragment;
import sk.doreto.signlanguage.ui.components.TestAnswerControllerView;
import sk.doreto.signlanguage.utils.Utility;


public class TestDetailFragment extends Fragment implements ITestDetailFragment {

    public LectionViewModel modelView;
    public ITestFragment testFragment;

    private int MAX_ANSWER_COUNT = 3;

    private int wordCount;
    private int questionCollectionSize;
    private int timeElapsedSecond = 0;
    private Timer timer;
    private TextView testTime;
    private ImageView videoPreview;
    private ImageButton playButton;
    private Lection lection;
    private List<QuestionItem> questionCollection = new ArrayList<>();
    private View root;
    private String videoPath = "";

    public TestDetailFragment(ITestFragment testFragment, Lection lection) {
        this.lection = lection;
        this.testFragment = testFragment;
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

        root = inflater.inflate(R.layout.fragment_test_detail, container, false);

        TestAnswerControllerView testAnswerController = root.findViewById(R.id.testAnswerControllerView);
        testAnswerController.setCallback(this);
        testAnswerController.fillTestData(questionCollection);

        testTime = root.findViewById(R.id.test_time);

        videoPreview = root.findViewById(R.id.video_preview);
        if (getResources().getConfiguration().orientation == Configuration.ORIENTATION_LANDSCAPE) {
            videoPreview.setScaleType(ImageView.ScaleType.FIT_CENTER);
        } else {
            videoPreview.setScaleType(ImageView.ScaleType.CENTER_CROP);
        }


        playButton = root.findViewById(R.id.video_play);
        playButton.setOnClickListener(new View.OnClickListener()   {
            public void onClick(View v)  {
                videoPlay();
            }
        });

        drawThumbnail();

        root.setFocusableInTouchMode(true);
        root.requestFocus();
        root.setOnKeyListener(new View.OnKeyListener() {
            @Override
            public boolean onKey(View v, int keyCode, KeyEvent event) {
                if (event.getAction() == KeyEvent.ACTION_DOWN) {
                    if (keyCode == KeyEvent.KEYCODE_BACK) {

                        TestFinishFragment testFinishFragment = new TestFinishFragment();
                        FragmentManager fragmentManager = getActivity().getSupportFragmentManager();
                        testFinishFragment.show(fragmentManager, "testFinishFragmentDialog");

                        testFinishFragment.setOnContinueClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                testFinishFragment.dismiss();
                            }
                        });

                        testFinishFragment.setOnFinishClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                testFinishFragment.dismiss();
                                lection.setTestScore(-1);
                                modelView.updateTestData(lection);
                                getActivity().onBackPressed();
                            }
                        });

                        return true;
                    }
                }
                return false;
            }
        });

        return root;
    }

    @Override
    public void onDestroy() {
        super.onDestroy();

        timer.cancel();

    }


    public void setVideo(String videoPath) {
        this.videoPath = videoPath;
        this.drawThumbnail();
    }

    public void finishTest(int score) {

        Date date = new Date();
        lection.setTestScore(score);
        lection.setTestDate(date);
        modelView.updateTestData(lection);
        //show result fragment
        TestStatisticsFragment result = new TestStatisticsFragment(lection);
        result.setOnFinishClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                getActivity().getSupportFragmentManager().popBackStackImmediate();
                getActivity().onBackPressed();

            }
        });

        result.setOnRepeatClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                testFragment.repeatTest(lection);
            }
        });

        FragmentTransaction ft = getActivity().getSupportFragmentManager().beginTransaction();
        ft.add(R.id.viewLayout, result);
        ft.addToBackStack("TestStatisticsFragment").commit();

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
        videoPlaybackActivity.putExtra("videoPath", videoPath);
        startActivity(videoPlaybackActivity);
    }

    private void drawThumbnail() {

        try {
            int resourceId = Utility.getResourceId(getContext(), videoPath, "raw");
            videoPreview.setImageResource(resourceId);
        }
        catch (Exception e){

        }
    }

    private void loadTestData() {

        List<Word> wordList = AppDatabase.getAppDatabase(getContext()).wordDao().getWordsForLection(lection.getId());
        wordCount = wordList.size();

        questionCollectionSize = wordCount / 3 + 1;

        for(int i = 0; i < questionCollectionSize; ++i) {


            QuestionItem questionItem = new QuestionItem();

            final int correctAnswerIndex =  (int)(Math.random() * 10) % 3;
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
