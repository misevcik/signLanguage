package sk.doreto.signlanguage.ui.about;

import android.content.Context;

import android.os.Bundle;
import android.text.method.LinkMovementMethod;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;

import sk.doreto.signlanguage.NavigationBarController;
import sk.doreto.signlanguage.R;


public class AboutFragment extends Fragment {

    private NavigationBarController navigationBarController;

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

        View rootView = inflater.inflate(R.layout.fragment_about, container, false);

        TextView link = (TextView) rootView.findViewById(R.id.about_text_clickable);
        if (link != null) {
            link.setMovementMethod(LinkMovementMethod.getInstance());
        }

        return rootView;
    }
}
