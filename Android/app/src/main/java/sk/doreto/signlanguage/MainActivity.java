package sk.doreto.signlanguage;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.media.MediaMetadataRetriever;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.MenuItem;
import android.view.View;

import com.google.android.material.bottomnavigation.BottomNavigationView;
import com.google.android.material.bottomnavigation.LabelVisibilityMode;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;

import java.util.Locale;

import sk.doreto.signlanguage.database.AppDatabase;
import sk.doreto.signlanguage.ui.dictionary.DictionaryFragment;
import sk.doreto.signlanguage.ui.education.EducationFragment;
import sk.doreto.signlanguage.ui.favorite.FavoriteFragment;
import sk.doreto.signlanguage.ui.info.InfoFragment;


public class MainActivity extends AppCompatActivity implements  NavigationBarController {

    private BottomNavigationView bottomNavigationView;

    private final DictionaryFragment dictionary = new DictionaryFragment();
    private final EducationFragment education = new EducationFragment();
    private final FavoriteFragment favorite = new FavoriteFragment();
    private final InfoFragment info = new InfoFragment();

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        Locale current = getResources().getConfiguration().locale;
        if(current.getLanguage().compareTo("sk") != 0) {
            setLocale("sk");
        }

        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        final FragmentManager fragmentManager = getSupportFragmentManager();

        bottomNavigationView = findViewById(R.id.navigation_view);
        bottomNavigationView.setOnNavigationItemSelectedListener(
                new BottomNavigationView.OnNavigationItemSelectedListener() {
                    Fragment fragment;

                    @Override
                    public boolean onNavigationItemSelected(@NonNull MenuItem item) {
                        switch (item.getItemId()) {
                            case R.id.navigation_dictionary:
                                fragment = dictionary;
                                setTitle(item.getTitle());
                                break;
                            case R.id.navigation_education:
                                fragment = education;
                                setTitle(item.getTitle());
                                break;
                            case R.id.navigation_favorite:
                                fragment = favorite;
                                setTitle(item.getTitle());
                                break;
                            case R.id.navigation_info:
                                fragment = info;
                                setTitle(item.getTitle());
                                break;
                        }
                        fragmentManager.beginTransaction().replace(R.id.viewLayout, fragment).commit();
                        return true;
                    }
                });

        bottomNavigationView.setLabelVisibilityMode(LabelVisibilityMode.LABEL_VISIBILITY_LABELED);
        bottomNavigationView.setSelectedItemId(R.id.navigation_dictionary);

    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        AppDatabase.destroyInstance();
    }


    public void hideBar() {
        bottomNavigationView.setVisibility(View.GONE);
    }

    public void showBar() {
        bottomNavigationView.setVisibility(View.VISIBLE);
    }

    @Override
    public void onBackPressed() {

        if (getSupportFragmentManager().getBackStackEntryCount() > 1) {
            getSupportFragmentManager().popBackStack();
        }
        else if(getSupportFragmentManager().getBackStackEntryCount() == 1) {
            getSupportFragmentManager().popBackStack();
            this.showBar();
        }
        else {
            super.onBackPressed();
        }
    }

    private void setLocale(String lang) {

        Locale myLocale = new Locale(lang);
        Locale.setDefault(myLocale);
        Resources res = getResources();
        DisplayMetrics dm = res.getDisplayMetrics();
        Configuration conf = res.getConfiguration();
        conf.locale = myLocale;
        res.updateConfiguration(conf, dm);
    }

    private boolean isLargeDevice(Context context) {
        int screenLayout = context.getResources().getConfiguration().screenLayout;
        screenLayout &= Configuration.SCREENLAYOUT_SIZE_MASK;

        switch (screenLayout) {
            case Configuration.SCREENLAYOUT_SIZE_SMALL:
            case Configuration.SCREENLAYOUT_SIZE_NORMAL:
                return false;
            case Configuration.SCREENLAYOUT_SIZE_LARGE:
            case Configuration.SCREENLAYOUT_SIZE_XLARGE:
                return true;
            default:
                return false;
        }
    }

}
