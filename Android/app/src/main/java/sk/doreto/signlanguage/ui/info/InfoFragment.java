package sk.doreto.signlanguage.ui.info;

import android.app.Activity;
import android.content.ActivityNotFoundException;
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

import sk.doreto.signlanguage.NavigationBarController;
import sk.doreto.signlanguage.R;

public class InfoFragment extends Fragment {

    static InfoItem infoItem [] = {
                    new InfoItem(R.string.info_about, R.mipmap.icon_forward),
                    new InfoItem(R.string.info_rate, R.mipmap.icon_forward),
                    new InfoItem(R.string.info_email, R.mipmap.icon_forward)
    };


    private NavigationBarController navigationBarController;
    private ListView listView;


    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
        try {
            navigationBarController = (NavigationBarController) context;
        } catch (ClassCastException castException) {
            /** The activity does not implement the listener. */
        }
    }

    public View onCreateView(@NonNull LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {

        View rootView = inflater.inflate(R.layout.fragment_info, container, false);

        InfoAdatper adapter = new InfoAdatper(infoItem);

        listView = rootView.findViewById(R.id.info_list);
        listView.setAdapter(adapter);

        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {

                switch (position) {
                    case 0:
                        break;
                    case 1:
                        //TODO https://ourcodeworld.com/articles/read/940/how-to-add-a-rate-my-app-dialog-to-an-android-application-using-the-android-five-stars-library
                        break;
                    case 2:
                        sendEmail();
                        break;
                }

            }
        });

        return rootView;

    }

    private void sendEmail(){

        Intent intent = new Intent(Intent.ACTION_SENDTO);
        intent.setData(Uri.parse("mailto:" + "info@dorteo.sk"));
        intent.putExtra(Intent.EXTRA_SUBJECT, "My email's subject");

        try {
            startActivity(Intent.createChooser(intent, "Send mail..."));
        } catch (android.content.ActivityNotFoundException ex) {
            Toast.makeText(getActivity(), "There are no email clients installed.", Toast.LENGTH_SHORT).show();
        }
    }
}
