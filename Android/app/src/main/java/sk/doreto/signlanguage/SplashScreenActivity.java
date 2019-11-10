package sk.doreto.signlanguage;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;

import sk.doreto.signlanguage.database.AppDatabase;
import sk.doreto.signlanguage.database.DatabaseInitializer;

public class SplashScreenActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_splash_screen);

        //DatabaseInitializer.populateAsync(AppDatabase.getAppDatabase(this));


        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                Intent intent = new Intent(getApplicationContext(), MainActivity.class);
                startActivity(intent);
                finish();
            }
        }, 1000);

    }
}
