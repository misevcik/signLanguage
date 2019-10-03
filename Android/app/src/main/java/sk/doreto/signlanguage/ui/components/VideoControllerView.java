package sk.doreto.signlanguage.ui.components;

import android.content.Context;
import android.util.AttributeSet;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;

import sk.doreto.signlanguage.R;

public class VideoControllerView extends LinearLayout {

    ImageView videoSpeed;
    ImageView videoBackward;
    ImageView videoPlay;
    ImageView videoForward;
    ImageView videoRotate;




    public VideoControllerView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init(context, attrs);
    }

    private void init(Context context, AttributeSet attrs) {

        inflate(context, R.layout.video_controller_view, this);
        initComponents();
    }

    private void initComponents() {

        videoSpeed = findViewById(R.id.video_speed);
        videoBackward = findViewById(R.id.video_backward);
        videoPlay = findViewById(R.id.video_play);
        videoForward = findViewById(R.id.video_forward);
        videoRotate = findViewById(R.id.video_rotate);

        videoSpeed.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v)  {
                Log.i("VideoController", "videoSpeed");
            }
        });

        videoBackward.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v)  {
                Log.i("VideoController", "videoBackward");
            }
        });

        videoPlay.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v)  {
                Log.i("VideoController", "videoPlay");
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
