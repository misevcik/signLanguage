package sk.doreto.signlanguage.ui.dictionary;

import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.media.MediaPlayer;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;


import sk.doreto.signlanguage.R;
import sk.doreto.signlanguage.VideoPlayerActivity;
import sk.doreto.signlanguage.ui.components.IVideoControllerView;
import sk.doreto.signlanguage.ui.components.VideoControllerView;
import sk.doreto.signlanguage.utils.Utility;

public class DetailDictionaryFragment extends Fragment implements IVideoControllerView {

    private ImageView imageView;
    private VideoControllerView videoController;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {

        View rootView = inflater.inflate(R.layout.fragment_detail_dictionary, container, false);

        imageView = rootView.findViewById(R.id.image_view);
        videoController = rootView.findViewById(R.id.video_controller);
        videoController.setVideoController(this);

        Drawable drawable = Utility.getThumbnail(getContext(), "hello");
        imageView.setImageDrawable(drawable);

        return rootView;

    }

    public void videoPlay() {
        Intent videoPlaybackActivity = new Intent(getContext(), VideoPlayerActivity.class);
        String videoPath = "android.resource://" + getContext().getPackageName() + "/" + R.raw.hello;
        videoPlaybackActivity.putExtra("videoPath", videoPath);
        startActivity(videoPlaybackActivity);
    }

    public void videoForward() {

    }

    public void videoBackward() {

    }

    public void videoRotate() {

    }

    public void videoSpeed() {

    }

}
