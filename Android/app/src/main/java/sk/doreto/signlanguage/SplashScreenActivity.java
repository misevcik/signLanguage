package sk.doreto.signlanguage;

import android.app.Activity;
import android.app.PendingIntent;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.res.Resources;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.util.Log;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.crashlytics.android.Crashlytics;
import com.google.android.vending.expansion.downloader.DownloadProgressInfo;
import com.google.android.vending.expansion.downloader.Helpers;
import com.google.android.vending.expansion.downloader.impl.BroadcastDownloaderClient;
import com.google.android.vending.expansion.downloader.impl.DownloaderService;



import io.fabric.sdk.android.Fabric;
import sk.doreto.signlanguage.database.AppDatabase;

import static com.google.android.vending.expansion.downloader.impl.DownloadsDB.LOG_TAG;


class DownloaderClient extends BroadcastDownloaderClient {

    Activity activity;

    public DownloaderClient(Activity activity) {
        this.activity = activity;
    }

    @Override
    public void onDownloadStateChanged(int newState) {
        if (newState == STATE_COMPLETED) {
            // downloaded successfully...
        } else if (newState >= 15) {
            //TODO - show alert-dialog
            int message = Helpers.getDownloaderStringResourceIDFromState(newState);
            Log.i("DownloaderClient", "Failed: " + message);

        }
    }

    @Override
    public void onDownloadProgress(DownloadProgressInfo progress) {
        if (progress.mOverallTotal > 0) {
            long percent = progress.mOverallProgress * 100 / progress.mOverallTotal;
            ((SplashScreenActivity)activity).setProgressBarValue((int)percent);

            //String percent = Helpers.getDownloadProgressPercent(progress.mOverallProgress, progress.mOverallTotal);
            //Log.i("DownloaderClient", "downloading progress: " + progress);
        }
    }
}

public class SplashScreenActivity extends Activity {


    private static class XAPKFile {
        public final boolean mIsMain;
        public final int mFileVersion;
        public final long mFileSize;

        XAPKFile(boolean isMain, int fileVersion, long fileSize) {
            mIsMain = isMain;
            mFileVersion = fileVersion;
            mFileSize = fileSize;
        }
    }

    private static final XAPKFile[] xAPKS = {
            new XAPKFile(true, 1, 301266911L)
    };

    //public key to app can be found: Google Play Console / Posunkuj s Nami / Development / Services & APIs
    public static final String BASE64_PUBLIC_KEY = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAiGyD4imSv4O+1iBuxfuqbtjYbGd3OGZOvtdWMzDPuNb/qfvbtsPB67nN76JwRw4IVSYjEHMIT9++2ME23rl5g+DQhVSDNztGDnfbd+zklwWKiGSySG6oWFih3ip81Knj/0HPebvyvZ3SBBvK/6MaMT03iWeYefS7sKuOt5PnlboT3gbLggJe+e2h78Zn/1DcKGIG+HUj8ai6ftXT2WfDbLmWnk41M9uz2Yvq0axpx2k63BEC1JzvzkxMgVe4zuHTNOopTKpPy/QcivXpMA5QA8o2KhR1r61DaoMU/serp2zd49itam6CStxcp9xgB3EfYhwAtV5nC8fjizqLmE3tswIDAQAB";
    public static final byte[] SALT = new byte[] { 1, 42, -12, -1, 54, 98,
            -100, -12, 43, 2, -8, -4, 9, 5, -106, -107, -33, 45, -1, 84
    };


    private ProgressBar progressBar;
    private TextView progressBarText;
    private final DownloaderClient mClient = new DownloaderClient(this);

    public void setProgressBarValue(int progress) {

        Resources res = getApplicationContext().getResources();
        progressBarText.setText(String.format(res.getString(R.string.download_text),progress));
        progressBar.setProgress(progress);
    }



    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        Fabric.with(this, new Crashlytics());

        downloadExpansionFile();

        setContentView(R.layout.activity_splash_screen);
        AppDatabase.getAppDatabase(this);

        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                Intent intent = new Intent(getApplicationContext(), MainActivity.class);
                startActivity(intent);
                finish();
            }
        }, 1000);

    }

    @Override
    protected void onStart() {
        super.onStart();
        mClient.register(this);
    }

    @Override
    protected void onStop() {
        mClient.unregister(this);
        super.onStop();
    }

    private boolean expansionFilesExist() {

        for (XAPKFile xf : xAPKS) {
            String fileName = Helpers.getExpansionAPKFileName(this, xf.mIsMain, xf.mFileVersion);
            if (!Helpers.doesFileExist(this, fileName, xf.mFileSize, false))
                return false;
        }

        return true;
    }

    boolean xAPKFilesReadable() {
        for (XAPKFile xf : xAPKS) {
            String fileName = Helpers.getExpansionAPKFileName(this, xf.mIsMain, xf.mFileVersion);
            if ( Helpers.getFileStatus(this, fileName) == Helpers.FS_CANNOT_READ ) {
                return false;
            }
        }
        return true;
    }

    private void downloadExpansionFile() {

        //TODO - check if storage is avaliable for reading
        //TODO - Create donwloade-channel

        if (expansionFilesExist()) {

            if (Helpers.canWriteOBBFile(this)) {
                launchDownloader();
            } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                //xAPKFilesReadable();
            }
        }
    }

    private void launchDownloader() {

        try {
            Intent notifierIntent = new Intent(this, SplashScreenActivity.this.getClass());
            notifierIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TOP);
            PendingIntent pendingIntent = PendingIntent.getActivity(this, 0, notifierIntent, PendingIntent.FLAG_UPDATE_CURRENT);

            int startResult = DownloaderService.startDownloadServiceIfRequired(this, "downloader-channel", pendingIntent, SALT, BASE64_PUBLIC_KEY);
            if (startResult != DownloaderService.NO_DOWNLOAD_REQUIRED) {
                setContentView(R.layout.download_progress_bar);
                progressBar = findViewById(R.id.progress_bar);
                progressBarText = findViewById(R.id.progress_bar_text);
                return;
            }
        } catch (PackageManager.NameNotFoundException e) {
            Log.e(LOG_TAG, "Cannot find own package!");
            e.printStackTrace();
        }
    }
}
