package sk.doreto.signlanguage.ui.info;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentTransaction;

import sk.doreto.signlanguage.NavigationBarController;
import sk.doreto.signlanguage.R;
import angtrim.com.fivestarslibrary.FiveStarsDialog;
import sk.doreto.signlanguage.ui.about.AboutFragment;


public class InfoFragment extends Fragment {

    static InfoItem infoItem [] = {
                    new InfoItem(R.string.info_about, R.mipmap.icon_info),
                    new InfoItem(R.string.info_rate, R.mipmap.icon_star),
                    new InfoItem(R.string.info_email, R.mipmap.icon_email)
    };


    private NavigationBarController navigationBarController;
    private ListView listView;
    private FiveStarsDialog mFiveStarsDialog = null;
    private static final String EMAIL_ADDRESS = "info@dorteo.sk";
    private LayoutInflater mLayoutInflater;
    private ViewGroup mContainer;
    private AboutFragment mAboutFragment = new AboutFragment();

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
        mFiveStarsDialog = new FiveStarsDialog(context, EMAIL_ADDRESS);
        try {
            navigationBarController = (NavigationBarController) context;
        } catch (ClassCastException castException) {
            /** The activity does not implement the listener. */
        }
    }

    private View createInfoView() {
        mContainer.removeAllViews();
        View view = mLayoutInflater.inflate(R.layout.fragment_info, mContainer, false);

        InfoAdatper adapter = new InfoAdatper(infoItem);

        listView = view.findViewById(R.id.info_list);
        listView.setAdapter(adapter);

        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {

                switch (position) {
                    case 0:
                        createAboutView();
                        break;
                    case 1: {
                        if (mFiveStarsDialog == null) {
                            break;
                        }
                        mFiveStarsDialog.setRateText(getResources().getString(R.string.info_rate_us))
                                .setTitle(getResources().getString(R.string.info_rate))
                                .setForceMode(false)
                                .setUpperBound(2)
                                .showAfter(0);
                        //todo: if dialog was set to show NEVER or OK, disable also button. Because it will never show again
                    }
                    break;
                    case 2:
                        sendEmail();
                        break;
                }

            }
        });
        return view;
    };

    private void createAboutView(){
        navigationBarController.hideBar();
        FragmentTransaction ft = getActivity().getSupportFragmentManager().beginTransaction();
        ft.add(R.id.viewLayout, mAboutFragment);
        ft.addToBackStack("AboutFragment").commit();
    }

    public View onCreateView(@NonNull LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {

        mLayoutInflater = inflater;
        mContainer = container;

        View rootView = createInfoView();

        return rootView;

    }

    private void sendEmail(){

        Intent intent = new Intent(Intent.ACTION_SENDTO);
        intent.setData(Uri.parse("mailto:" + EMAIL_ADDRESS));
        intent.putExtra(Intent.EXTRA_SUBJECT, "My email's subject");

        try {
            startActivity(Intent.createChooser(intent, "Send mail..."));
        } catch (android.content.ActivityNotFoundException ex) {
            Toast.makeText(getActivity(), "There are no email clients installed.", Toast.LENGTH_SHORT).show();
        }
    }
}
