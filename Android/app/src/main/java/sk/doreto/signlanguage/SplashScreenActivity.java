package sk.doreto.signlanguage;

import android.app.Activity;
import android.app.PendingIntent;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.util.Log;

import com.crashlytics.android.Crashlytics;
import com.google.android.vending.expansion.downloader.Helpers;
import com.google.android.vending.expansion.downloader.impl.DownloaderService;


import io.fabric.sdk.android.Fabric;
import sk.doreto.signlanguage.database.AppDatabase;

import static com.google.android.vending.expansion.downloader.impl.DownloadsDB.LOG_TAG;


public class SplashScreenActivity extends Activity {


    public static final String BASE64_PUBLIC_KEY = "outKey";

    public static final byte[] SALT = new byte[] { 1, 42, -12, -1, 54, 98,
            -100, -12, 43, 2, -8, -4, 9, 5, -106, -107, -33, 45, -1, 84
    };



    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        Fabric.with(this, new Crashlytics());
        setContentView(R.layout.activity_splash_screen);

        //Download expansion file
        downloadExpansionFile();

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

    private boolean expansionFilesExist() {
        //Implement Expansion file check
        return false;

    }

    private void downloadExpansionFile() {

        if (!expansionFilesExist()) {

            // does our OBB directory exist?
            if (Helpers.canWriteOBBFile(this))
                launchDownloader();
            else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                //TODO we need the write permission first
            }
        }
    }

    private void launchDownloader() {

        try {
            // Build an Intent to start this activity from the Notification
            Intent notifierIntent = new Intent(this, SplashScreenActivity.this.getClass());
            notifierIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TOP);

            PendingIntent pendingIntent = PendingIntent.getActivity(this, 0, notifierIntent, PendingIntent.FLAG_UPDATE_CURRENT);

            // Start the download service (if required)
            // Don't forget to create the channel in advance!
            int startResult = DownloaderService.startDownloadServiceIfRequired(this, "downloader-channel", pendingIntent, SALT, BASE64_PUBLIC_KEY);
            // If download has started, initialize this activity to show
            // download progress
            if (startResult != DownloaderService.NO_DOWNLOAD_REQUIRED){
                // This is where you do set up to display the download
                // progress (next step)

                return;
            }
        } catch (PackageManager.NameNotFoundException e) {
            Log.e(LOG_TAG, "Cannot find own package!");
            e.printStackTrace();
        }
    }
}
