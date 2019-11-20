package sk.doreto.signlanguage;
import android.os.Bundle;
import android.view.MenuItem;
import android.view.View;

import com.google.android.material.bottomnavigation.BottomNavigationView;
import com.google.android.material.bottomnavigation.LabelVisibilityMode;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;

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
        AppDatabase.destroyInstance();
        super.onDestroy();
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


}
