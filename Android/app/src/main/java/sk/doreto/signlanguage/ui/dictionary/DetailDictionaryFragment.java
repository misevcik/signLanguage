package sk.doreto.signlanguage.ui.dictionary;

import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;


import sk.doreto.signlanguage.R;
import sk.doreto.signlanguage.VideoPlayerActivity;
import sk.doreto.signlanguage.ui.components.IDetailFragment;
import sk.doreto.signlanguage.ui.components.VideoControllerView;
import sk.doreto.signlanguage.utils.Utility;

public class DetailDictionaryFragment extends Fragment implements IDetailFragment {

    private ImageView imageView;
    private VideoControllerView videoController;
    private IDictionaryFragment dictionaryFragment;

    private boolean videoRotate = false;
    private boolean videoSlowMotion = false;

    public DetailDictionaryFragment(IDictionaryFragment dictionaryFragment) {
        this.dictionaryFragment = dictionaryFragment;
    }


    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {

        View rootView = inflater.inflate(R.layout.fragment_detail_dictionary, container, false);

        imageView = rootView.findViewById(R.id.image_view);
        videoController = rootView.findViewById(R.id.video_controller);
        videoController.setDetailFragment(this);

        Drawable drawable = Utility.getThumbnail(getContext(), "hello");
        imageView.setImageDrawable(drawable);

        return rootView;
    }

    public void setDetailData() {

    }

    public void videoPlay() {
        Intent videoPlaybackActivity = new Intent(getContext(), VideoPlayerActivity.class);
        String videoPath = "android.resource://" + getContext().getPackageName() + "/" + R.raw.hello;
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
    }

    public void videoSpeed(boolean videoSlowMotion) {
        this.videoSlowMotion = videoSlowMotion;
    }

}
