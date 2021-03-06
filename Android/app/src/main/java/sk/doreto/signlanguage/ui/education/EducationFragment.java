package sk.doreto.signlanguage.ui.education;

import android.content.Context;
import android.content.res.Resources;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;
import androidx.viewpager.widget.ViewPager;
import com.google.android.material.tabs.TabLayout;

import sk.doreto.signlanguage.R;

public class EducationFragment extends Fragment {

    private TabFragmentAdapter adapter;
    private TabLayout tabs;
    private ViewPager viewPager;

    private LectionFragment lectionFragment = LectionFragment.newInstance();
    private TestFragment testFragment = TestFragment.newInstance();

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);

    }


    public View onCreateView(@NonNull LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {

        View root = inflater.inflate(R.layout.fragment_education, container, false);

        TextView toolbarTitleView = root.findViewById(R.id.toolbar_title);

        Resources res = getContext().getResources();
        toolbarTitleView.setText(res.getString(R.string.title_education));

        tabs = root.findViewById(R.id.tab);
        viewPager = root.findViewById(R.id.viewPager);

        //TODO - urobit tak aby sa nemuselo refreshovat
        adapter = new TabFragmentAdapter(getChildFragmentManager());
        adapter.addFragment(lectionFragment, getContext().getString(R.string.tab_lection));
        adapter.addFragment(testFragment, getContext().getString(R.string.tab_test));

        viewPager.setAdapter(adapter);
        tabs.setupWithViewPager(viewPager);
        viewPager.addOnPageChangeListener(new TabLayout.TabLayoutOnPageChangeListener(tabs));

        return root;
    }

}

