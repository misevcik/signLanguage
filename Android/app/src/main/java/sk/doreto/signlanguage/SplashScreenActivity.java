package sk.doreto.signlanguage;

import android.app.Activity;
import android.app.PendingIntent;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.res.AssetFileDescriptor;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.util.Log;
import android.widget.Toast;

import com.android.vending.expansion.zipfile.APKExpansionSupport;
import com.android.vending.expansion.zipfile.ZipResourceFile;
import com.crashlytics.android.Crashlytics;
import com.google.android.vending.expansion.downloader.DownloadProgressInfo;
import com.google.android.vending.expansion.downloader.Helpers;
import com.google.android.vending.expansion.downloader.impl.BroadcastDownloaderClient;
import com.google.android.vending.expansion.downloader.impl.DownloaderService;


import java.io.BufferedInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

import io.fabric.sdk.android.Fabric;
import sk.doreto.signlanguage.database.AppDatabase;
import sk.doreto.signlanguage.utils.ZipFileContentProvider;

import static com.google.android.vending.expansion.downloader.impl.DownloadsDB.LOG_TAG;


class DownloaderClient extends BroadcastDownloaderClient {

    @Override
    public void onDownloadStateChanged(int newState) {
        if (newState == STATE_COMPLETED) {
            // downloaded successfully...
        } else if (newState >= 15) {
            // failed
            int message = Helpers.getDownloaderStringResourceIDFromState(newState);
            Log.i("DownloaderClient", "Failed");
            //Toast.makeText(this, message, Toast.LENGTH_SHORT).show();
        }
    }

    @Override
    public void onDownloadProgress(DownloadProgressInfo progress) {
        if (progress.mOverallTotal > 0) {
            // receive the download progress
            // you can then display the progress in your activity
            //String progress = Helpers.getDownloadProgressPercent(progress.mOverallProgress, progress.mOverallTotal);
            Log.i("DownloaderClient", "downloading progress: " + progress);
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

    public static final String BASE64_PUBLIC_KEY = "outKey";
    public static final byte[] SALT = new byte[] { 1, 42, -12, -1, 54, 98,
            -100, -12, 43, 2, -8, -4, 9, 5, -106, -107, -33, 45, -1, 84
    };


    private final DownloaderClient mClient = new DownloaderClient();

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        Fabric.with(this, new Crashlytics());
        setContentView(R.layout.activity_splash_screen);

        //downloadExpansionFile();

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

        if (!expansionFilesExist()) {

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
            if (startResult != DownloaderService.NO_DOWNLOAD_REQUIRED){

                // Inflate layout that shows download progress
                return;
            }
        } catch (PackageManager.NameNotFoundException e) {
            Log.e(LOG_TAG, "Cannot find own package!");
            e.printStackTrace();
        }
    }
}
