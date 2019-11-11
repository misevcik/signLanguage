package sk.doreto.signlanguage.ui.info;

import android.content.Context;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListView;

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

        return rootView;

    }
}
