package sk.doreto.signlanguage;
import android.os.Bundle;
import android.view.View;

import com.google.android.material.bottomnavigation.BottomNavigationView;
import androidx.appcompat.app.AppCompatActivity;
import androidx.navigation.NavController;
import androidx.navigation.Navigation;
import androidx.navigation.ui.AppBarConfiguration;
import androidx.navigation.ui.NavigationUI;

import sk.doreto.signlanguage.database.AppDatabase;


public class MainActivity extends AppCompatActivity implements  NavigationBarController {

    BottomNavigationView bottomNavigationView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        bottomNavigationView = findViewById(R.id.navigation_view);

        AppBarConfiguration appBarConfiguration = new AppBarConfiguration.Builder(
                R.id.navigation_dictionary, R.id.navigation_education, R.id.navigation_notifications)
                .build();
        
        NavController navController = Navigation.findNavController(this, R.id.viewLayout);
        NavigationUI.setupActionBarWithNavController(this, navController, appBarConfiguration);
        NavigationUI.setupWithNavController(bottomNavigationView, navController);


        //TODO Call only once
        //DatabaseInitializer.populateAsync(AppDatabase.getAppDatabase(this));
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


}
