package sk.doreto.signlanguage.ui.common;

import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;


import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.appcompat.widget.Toolbar;


import java.util.List;

import sk.doreto.signlanguage.R;
import sk.doreto.signlanguage.VideoPlayerActivity;
import sk.doreto.signlanguage.database.AppDatabase;
import sk.doreto.signlanguage.database.Sentence;
import sk.doreto.signlanguage.database.Word;
import sk.doreto.signlanguage.ui.components.IDetailFragment;
import sk.doreto.signlanguage.ui.components.VideoControllerView;
import sk.doreto.signlanguage.utils.Utility;

import static android.widget.ListPopupWindow.MATCH_PARENT;

public class DictionaryDetailFragment extends Fragment implements IDetailFragment {

    public enum FragmentType {
        DICTIONARY,
        LECTION
    }

    private ImageView imageView;
    private VideoControllerView videoController;
    private IDictionaryFragment dictionaryFragment;
    private SentenceAdapter adapter;
    private ListView listView;

    private Word word;
    private List<Sentence> sentecneList;
    private boolean videoRotate = false;
    private boolean videoSlowMotion = false;

    private FragmentType fragmentType;

    public DictionaryDetailFragment(IDictionaryFragment dictionaryFragment, FragmentType fragmentType) {
        this.dictionaryFragment = dictionaryFragment;
        this.fragmentType = fragmentType;
    }


    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {

        View rootView = inflater.inflate(R.layout.fragment_dictionary_detail, container, false);
        View customToolbar = inflater.inflate(R.layout.dictionary_toolbar, null, false);

        if(fragmentType == FragmentType.DICTIONARY) {

            LinearLayout toolbar = rootView.findViewById(R.id.dictionary_detail_toolbar);
            toolbar.addView(customToolbar, MATCH_PARENT, MATCH_PARENT);

            TextView dictionaryTitle = toolbar.findViewById(R.id.dictionary_detail_word_title);
            dictionaryTitle.setText(word.getWord());

            ImageButton favorite = toolbar.findViewById(R.id.dictionary_detail_favorite);

            favorite.setImageResource(word.getFavorite() ? R.mipmap.icon_heart_red : R.mipmap.icon_heart_black);
            favorite.setOnClickListener(new View.OnClickListener() {
                public void onClick(View v)  {
                    word.setFavorite(!word.getFavorite());
                    favorite.setImageResource(word.getFavorite() ? R.mipmap.icon_heart_red : R.mipmap.icon_heart_black);
                }
            });


        }

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

        if(this.fragmentType == FragmentType.LECTION) {
            lectionFragment();
        }
    }

    private void lectionFragment() {

        if (!word.getVisited()) {
            word.setVisited(true);
            AppDatabase.getAppDatabase(getContext()).wordDao().updateVisited(true, word.getId());
            dictionaryFragment.updateContent();
        }
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
