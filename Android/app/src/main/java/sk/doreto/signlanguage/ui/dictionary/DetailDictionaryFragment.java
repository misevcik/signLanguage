package sk.doreto.signlanguage.ui.dictionary;

import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ImageView;
import android.widget.ListView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentTransaction;


import java.util.List;

import sk.doreto.signlanguage.R;
import sk.doreto.signlanguage.VideoPlayerActivity;
import sk.doreto.signlanguage.database.AppDatabase;
import sk.doreto.signlanguage.database.Sentence;
import sk.doreto.signlanguage.database.Word;
import sk.doreto.signlanguage.ui.components.IDetailFragment;
import sk.doreto.signlanguage.ui.components.VideoControllerView;
import sk.doreto.signlanguage.utils.Utility;

public class DetailDictionaryFragment extends Fragment implements IDetailFragment {

    private ImageView imageView;
    private VideoControllerView videoController;
    private IDictionaryFragment dictionaryFragment;
    private SentenceAdapter adapter;
    private ListView listView;

    private Word word;
    private List<Sentence> sentecneList;
    private boolean videoRotate = false;
    private boolean videoSlowMotion = false;

    public DetailDictionaryFragment(IDictionaryFragment dictionaryFragment) {
        this.dictionaryFragment = dictionaryFragment;
    }


    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {

        View rootView = inflater.inflate(R.layout.fragment_dictionary_detail, container, false);

        imageView = rootView.findViewById(R.id.image_view);

        videoController = rootView.findViewById(R.id.video_controller);
        videoController.setDefaultVideoRotate(videoRotate);
        videoController.setDefaultVideoSlowMotion(videoSlowMotion);
        videoController.setDetailFragment(this);

        adapter = new SentenceAdapter(sentecneList, getContext());
        listView = rootView.findViewById(R.id.sentence_list);
        listView.setAdapter(adapter);

        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {

            }
        });


        drawThumbnail();

        return rootView;
    }

    public void setDetailData(Word word) {
        this.word = word;

        sentecneList = AppDatabase.getAppDatabase(getContext()).wordSentenceJoinDao().getSentencesForWord(word.getId());
    }


    public void videoPlay() {
        Intent videoPlaybackActivity = new Intent(getContext(), VideoPlayerActivity.class);

        String videoPath;
        if(this.videoRotate)
            videoPath = "android.resource://" + getContext().getPackageName() + "/" + Utility.getResourceId(getContext(), word.getVideoSide(), "raw");
        else
            videoPath = "android.resource://" + getContext().getPackageName() + "/" + Utility.getResourceId(getContext(), word.getVideoFront(), "raw");


        videoPlaybackActivity.putExtra("videoPath", videoPath);
        videoPlaybackActivity.putExtra("videoSlowMotion", videoSlowMotion);
        startActivity(videoPlaybackActivity);
    }

    public void videoForward() {
        dictionaryFragment.videoForward();
    }

    public void videoBackward() {
        dictionaryFragment.videoBackward();
    }

    public void videoRotate(boolean videoRotate) {

        this.videoRotate = videoRotate;
        drawThumbnail();
    }

    public void videoSlowMotion(boolean videoSlowMotion) {
        this.videoSlowMotion = videoSlowMotion;
    }

    private void drawThumbnail() {
        Drawable drawable = Utility.getThumbnail(getContext(), this.videoRotate ? word.getVideoSide() : word.getVideoFront());
        imageView.setImageDrawable(drawable);
    }

}
