package sk.doreto.signlanguage.ui.components;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.util.AttributeSet;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ToggleButton;

import sk.doreto.signlanguage.R;

public class VideoControllerView extends LinearLayout {

    private IVideoControllerView videoController;

    private ImageView videoSpeed;
    private ImageView videoBackward;
    private ImageView videoPlay;
    private ImageView videoForward;
    private ImageView videoRotate;


    public VideoControllerView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init(context, attrs);

    }

    public void setVideoController(IVideoControllerView videoController) {
        this.videoController = videoController;
    }

    private void init(Context context, AttributeSet attrs) {

        inflate(context, R.layout.video_controller_view, this);
        initComponents();
    }

    private boolean state = false;

    private void initComponents() {

        videoSpeed = findViewById(R.id.video_speed);
        videoBackward = findViewById(R.id.video_backward);
        videoPlay = findViewById(R.id.video_play);
        videoForward = findViewById(R.id.video_forward);
        videoRotate = findViewById(R.id.video_rotate);

        videoSpeed.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v)  {
                Log.i("VideoController", "videoSpeed");
                if (state == false ) {
                    Drawable image=(Drawable)getResources().getDrawable(R.mipmap.icon_rotate);
                    videoSpeed.setBackground(image);
                } else {
                    Drawable image=(Drawable)getResources().getDrawable(R.mipmap.icon_clock);
                    videoSpeed.setBackground(image);
                }
                state = !state;

            }
        });

        videoBackward.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v)  {
                Log.i("VideoController", "videoBackward");
            }
        });

        videoPlay.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v)  {
                videoController.videoPlay();
            }
        });

        videoForward.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v)  {
                Log.i("VideoController", "videoForward");
            }
        });

        videoRotate.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v)  {
                Log.i("VideoController", "videoRotate");
            }
        });
    }
}
