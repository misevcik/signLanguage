package sk.doreto.signlanguage;

import android.os.AsyncTask;
import android.os.Bundle;

import com.google.android.material.bottomnavigation.BottomNavigationView;

import androidx.appcompat.app.AppCompatActivity;
import androidx.navigation.NavController;
import androidx.navigation.Navigation;
import androidx.navigation.ui.AppBarConfiguration;
import androidx.navigation.ui.NavigationUI;

import sk.doreto.signlanguage.Database.DatabaseHandler;

public class MainActivity extends AppCompatActivity {

    private DatabaseHandler mDatabaseHandler;

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        mDatabaseHandler = new DatabaseHandler(getBaseContext());

        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        BottomNavigationView navView = findViewById(R.id.nav_view);
        // Passing each menu ID as a set of Ids because each
        // menu should be considered as top level destinations.
        AppBarConfiguration appBarConfiguration = new AppBarConfiguration.Builder(
                R.id.navigation_dictionary, R.id.navigation_dashboard, R.id.navigation_notifications)
                .build();
        NavController navController = Navigation.findNavController(this, R.id.nav_host_fragment);
        NavigationUI.setupActionBarWithNavController(this, navController, appBarConfiguration);
        NavigationUI.setupWithNavController(navView, navController);

        //TODO - fill database asynchron
        mDatabaseHandler.populateDatabase();
        mDatabaseHandler.getWrods();
    }




}
