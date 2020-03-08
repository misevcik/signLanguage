package sk.doreto.signlanguage.ui.common;

import android.content.Context;
import android.content.Intent;
import android.content.res.Configuration;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.InputMethodManager;
import android.widget.AdapterView;
import android.widget.ImageView;
import android.widget.ListView;


import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;


import java.util.List;

import sk.doreto.signlanguage.R;
import sk.doreto.signlanguage.VideoPlayerActivity;
import sk.doreto.signlanguage.database.AppDatabase;
import sk.doreto.signlanguage.database.Sentence;
import sk.doreto.signlanguage.database.Word;
import sk.doreto.signlanguage.ui.components.IDetailFragment;
import sk.doreto.signlanguage.ui.components.VideoControllerView;
import sk.doreto.signlanguage.utils.Utility;

public class GeneralDictionaryDetailFragment extends Fragment implements IDetailFragment {

    protected IDictionaryFragment parentFragment;
    protected Word word;

    private ImageView videoPreview;
    private VideoControllerView videoController;
    private SentenceAdapter sentenceAdapter;
    private ListView sentenceListView;

    private List<Sentence> sentenceList;
    private boolean videoRotate = false;
    private boolean videoSlowMotion = false;

    public void setParentFragment(IDictionaryFragment parentFragment) {
        this.parentFragment = parentFragment;
    }

    public GeneralDictionaryDetailFragment() {
    }


    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {

        View rootView = inflater.inflate(R.layout.fragment_dictionary_detail, container, false);

        videoPreview = rootView.findViewById(R.id.video_preview);

        if (getResources().getConfiguration().orientation == Configuration.ORIENTATION_LANDSCAPE) {
            videoPreview.setScaleType(ImageView.ScaleType.FIT_CENTER);
        } else {
            videoPreview.setScaleType(ImageView.ScaleType.CENTER_CROP);
        }

        videoController = rootView.findViewById(R.id.video_controller);
        videoController.setDetailFragment(this);
        videoController.setDefaultVideoRotate(videoRotate);
        videoController.setDefaultVideoSlowMotion(videoSlowMotion);

        sentenceAdapter = new SentenceAdapter(sentenceList, getContext());
        sentenceListView = rootView.findViewById(R.id.sentence_list);
        sentenceListView.setAdapter(sentenceAdapter);
        sentenceListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {


                Sentence sentence = sentenceList.get(position);

                Intent videoPlaybackActivity = new Intent(getContext(), VideoPlayerActivity.class);
                videoPlaybackActivity.putExtra("videoPath", sentence.getVideo());
                startActivity(videoPlaybackActivity);

            }
        });

        drawThumbnail();

        return rootView;
    }

    public void setDetailData(Word word) {

        this.word = word;
        sentenceList = AppDatabase.getAppDatabase(getContext()).wordSentenceJoinDao().getSentencesForWord(word.getId());
    }


    public void videoPlay() {
        Intent videoPlaybackActivity = new Intent(getContext(), VideoPlayerActivity.class);

        String videoPath;
        if(this.videoRotate)
            videoPath = word.getVideoSide();
        else
            videoPath = word.getVideoFront();


        videoPlaybackActivity.putExtra("videoPath", videoPath);
        videoPlaybackActivity.putExtra("videoSlowMotion", videoSlowMotion);
        startActivity(videoPlaybackActivity);
    }

    public void videoForward() {
        parentFragment.videoForward();
    }

    public void videoBackward() {
            parentFragment.videoBackward();
    }

    public void videoRotate(boolean videoRotate) {

        this.videoRotate = videoRotate;
        drawThumbnail();
    }

    public void videoSlowMotion(boolean videoSlowMotion) {
        this.videoSlowMotion = videoSlowMotion;
    }

    private void drawThumbnail() {

        if(word != null) {
            String resource = this.videoRotate ? word.getVideoSide() : word.getVideoFront();
            int resourceId = Utility.getResourceId(getContext(), resource, "raw");
            videoPreview.setImageResource(resourceId);
        }
    }
}
