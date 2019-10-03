package sk.doreto.signlanguage.ui.education;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;
import androidx.viewpager.widget.ViewPager;
import com.google.android.material.tabs.TabLayout;

import sk.doreto.signlanguage.R;

public class EducationFragment extends Fragment {

    private TabFragmentAdapter mAdapter;
    private TabLayout mTabs;
    private ViewPager mViewPager;

    public View onCreateView(@NonNull LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {

        View root = inflater.inflate(R.layout.fragment_education, container, false);

        //Assign view reference
        mTabs = root.findViewById(R.id.tab);
        mViewPager = root.findViewById(R.id.viewPager);


        mAdapter = new TabFragmentAdapter(getFragmentManager());
        mAdapter.addFragment(LectionFragment.newInstance(), "Tab 1");
        mAdapter.addFragment(TestFragment.newInstance(), "Tab 2");

        mViewPager.setAdapter(mAdapter);
        mTabs.setupWithViewPager(mViewPager);

        return root;
    }
}