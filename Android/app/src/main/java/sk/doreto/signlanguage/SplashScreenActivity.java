package sk.doreto.signlanguage;

import android.Manifest;
import android.app.Activity;
import android.app.PendingIntent;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.res.Resources;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.util.Log;
import android.view.View;
import android.widget.ProgressBar;
import android.widget.TextView;

import androidx.core.app.ActivityCompat;

import com.crashlytics.android.Crashlytics;
import com.google.android.material.snackbar.Snackbar;
import com.google.android.vending.expansion.downloader.DownloadProgressInfo;
import com.google.android.vending.expansion.downloader.Helpers;
import com.google.android.vending.expansion.downloader.impl.BroadcastDownloaderClient;
import com.google.android.vending.expansion.downloader.impl.DownloaderService;


import io.fabric.sdk.android.Fabric;
import sk.doreto.signlanguage.database.AppDatabase;


class DownloaderClient extends BroadcastDownloaderClient {

    SplashScreenActivity activity;

    public DownloaderClient(Activity activity) {
        this.activity = (SplashScreenActivity)activity;
    }

    @Override
    public void onDownloadStateChanged(int newState) {

        if (newState == STATE_COMPLETED) {
            Log.i("DownloadActivity", "Download finished");
            activity.runMainActivity(false);
        } else if (newState >= 15) {
            int message = Helpers.getDownloaderStringResourceIDFromState(newState);
            Log.e("DownloadActivity", "Download failed: " + message);
            activity.downloadFail();
        }
    }

    @Override
    public void onDownloadProgress(DownloadProgressInfo progress) {
        if (progress.mOverallTotal > 0) {
            long percent = progress.mOverallProgress * 100 / progress.mOverallTotal;
            activity.setProgressBarValue((int)percent);

            String status = Helpers.getDownloadProgressPercent(progress.mOverallProgress, progress.mOverallTotal);
            Log.i("DownloadActivity", "downloading progress: " + status);
        }
    }
}

public class SplashScreenActivity extends Activity implements  ActivityCompat.OnRequestPermissionsResultCallback{

    private static final int PERMISSION_STORAGE_READ_REQUEST_CODE = 1;
    private static final int PERMISSION_STORAGE_WRITE_REQUEST_CODE = 2;

    public static final int OBB_FILE_VERSION = 5;

    //public key to app can be found: Google Play Console / Posunkuj s Nami / Development / Services & APIs
    public static final String BASE64_PUBLIC_KEY = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAiGyD4imSv4O+1iBuxfuqbtjYbGd3OGZOvtdWMzDPuNb/qfvbtsPB67nN76JwRw4IVSYjEHMIT9++2ME23rl5g+DQhVSDNztGDnfbd+zklwWKiGSySG6oWFih3ip81Knj/0HPebvyvZ3SBBvK/6MaMT03iWeYefS7sKuOt5PnlboT3gbLggJe+e2h78Zn/1DcKGIG+HUj8ai6ftXT2WfDbLmWnk41M9uz2Yvq0axpx2k63BEC1JzvzkxMgVe4zuHTNOopTKpPy/QcivXpMA5QA8o2KhR1r61DaoMU/serp2zd49itam6CStxcp9xgB3EfYhwAtV5nC8fjizqLmE3tswIDAQAB";
    public static final byte[] SALT = new byte[] { 1, 42, -12, -1, 54, 98,
            -100, -12, 43, 2, -8, -4, 9, 5, -106, -107, -33, 45, -1, 84
    };

    private static final XAPKFile[] xAPKS = {
            new XAPKFile(true, SplashScreenActivity.OBB_FILE_VERSION, 301266911L)
    };

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



    private ProgressBar progressBar;
    private TextView progressBarText;
    private final DownloaderClient mClient = new DownloaderClient(this);

    public void setProgressBarValue(int progress) {

        Resources res = getApplicationContext().getResources();
        progressBarText.setText(String.format(res.getString(R.string.download_text),progress));
        progressBar.setProgress(progress);
    }

    public void downloadFail() {
        progressBarText.setText(R.string.download_fail);
    }


    public void runMainActivity(boolean showSplashScreen) {

        if(showSplashScreen) {
            setContentView(R.layout.activity_splash_screen);
        }
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
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        Fabric.with(this, new Crashlytics());

        if(isExpansionFilePrepared()) {
            runMainActivity(true);
        }
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

    private boolean isExpansionFilePrepared() {

        //TODO - Create donwloade-channel

        if (!expansionFilesExist()) {

            if (Helpers.canWriteOBBFile(this)) {

                Log.i("DownloadActivity", "OBB file is ready to download");
                boolean isRunning = launchDownloader();
                return !isRunning;

            } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                Log.e("DownloadActivity", "Request write permission.");
                requestStorageWritePermission();
                return false;
            }
        } else if(!xAPKFilesReadable()) {

            Log.e("DownloadActivity", "Cannot read APKx File.  Permission Perhaps?");
            if (ActivityCompat.checkSelfPermission(this, Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
                Log.e("DownloadActivity", "Need Permission!");
                requestStorageReadPermission();
                return false;
            }
        }

        return true;
    }

    private void  requestStorageWritePermission() {
        setContentView(R.layout.permission_request);
        View rootLayout = findViewById(R.id.requestPermission);

        if (ActivityCompat.shouldShowRequestPermissionRationale(this, Manifest.permission.WRITE_EXTERNAL_STORAGE)) {

            Snackbar.make(rootLayout, R.string.write_permission,
                    Snackbar.LENGTH_INDEFINITE).setAction("OK", new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    ActivityCompat.requestPermissions(SplashScreenActivity.this,
                            new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE},
                            PERMISSION_STORAGE_WRITE_REQUEST_CODE);
                }
            }).show();

        } else {
            Snackbar.make(rootLayout, R.string.write_permission, Snackbar.LENGTH_SHORT).show();
            ActivityCompat.requestPermissions(SplashScreenActivity.this,
                    new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE},
                    PERMISSION_STORAGE_WRITE_REQUEST_CODE);
        }
    }

    private void requestStorageReadPermission() {

        setContentView(R.layout.permission_request);
        View rootLayout = findViewById(R.id.requestPermission);

        if (ActivityCompat.shouldShowRequestPermissionRationale(this, Manifest.permission.READ_EXTERNAL_STORAGE)) {
            Snackbar.make(rootLayout, R.string.read_permission,
                    Snackbar.LENGTH_INDEFINITE).setAction("OK", new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    ActivityCompat.requestPermissions(SplashScreenActivity.this,
                            new String[]{Manifest.permission.READ_EXTERNAL_STORAGE},
                            PERMISSION_STORAGE_READ_REQUEST_CODE);
                }
            }).show();

        } else {
            Snackbar.make(rootLayout, R.string.read_permission, Snackbar.LENGTH_SHORT).show();
            ActivityCompat.requestPermissions(SplashScreenActivity.this,
                    new String[]{Manifest.permission.READ_EXTERNAL_STORAGE},
                    PERMISSION_STORAGE_READ_REQUEST_CODE);

        }
    }

    private boolean launchDownloader() {

        Log.i("DownloadActivity", "launchDownloader");

        try {

            Intent notifierIntent = new Intent(this, SplashScreenActivity.this.getClass());
            notifierIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TOP);
            PendingIntent pendingIntent = PendingIntent.getActivity(this, 0, notifierIntent, PendingIntent.FLAG_UPDATE_CURRENT);

            int startResult = DownloaderService.startDownloadServiceIfRequired(this, "downloader-channel", pendingIntent, SALT, BASE64_PUBLIC_KEY);
            if (startResult != DownloaderService.NO_DOWNLOAD_REQUIRED) {
                setContentView(R.layout.download_progress_bar);
                progressBar = findViewById(R.id.progress_bar);
                progressBarText = findViewById(R.id.progress_bar_text);
                this.setProgressBarValue(0);
                return true;
            }
        } catch (PackageManager.NameNotFoundException e) {
            Log.e("DownloadActivity", "Cannot find own package!");
            e.printStackTrace();
            return false;
        }

        return false;
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {

        Log.i("DownloadActivity", "Receive onRequestPermissionsResult");

        switch (requestCode) {
            case PERMISSION_STORAGE_READ_REQUEST_CODE:

                if (grantResults.length == 1 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    Log.i("DownloadActivity", "PERMISSION_STORAGE_READ_REQUEST_CODE grangted");
                    runMainActivity(false);
                } else {
                    Snackbar.make(findViewById(R.id.requestPermission), R.string.permission_denied,
                            Snackbar.LENGTH_SHORT)
                            .show();
                }
                break;
            case PERMISSION_STORAGE_WRITE_REQUEST_CODE:
                if (grantResults.length == 1 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    Log.i("DownloadActivity", "PERMISSION_STORAGE_WRITE_REQUEST_CODE grangted");
                    launchDownloader();
                } else {
                    Snackbar.make(findViewById(R.id.requestPermission), R.string.permission_denied,
                            Snackbar.LENGTH_SHORT)
                            .show();
                }
                break;

        }
    }
}
