package sk.doreto.signlanguage.ui.education;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import java.util.List;

import sk.doreto.signlanguage.R;
import sk.doreto.signlanguage.database.Lection;

public class TestAdapter extends ArrayAdapter<Lection> {

    private List<Lection> lectionList;

    private static class ViewHolder {

        TextView testName;
        TextView testStatistic;
        TextView testResult;
    }


    public TestAdapter(Context context) {
        super(context, R.layout.item_test_row);
    }


    @Override
    public int getCount() {

        if(lectionList == null)
            return 0;

        return lectionList.size();
    }

    public void setLectionList(List<Lection> lections) {
        lectionList = lections;
        notifyDataSetChanged();
    }


    @Override
    public Lection getItem(int position) {
        return lectionList.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {

        Lection lection = getItem(position);
        ViewHolder viewHolder;

        if (convertView == null) {

            viewHolder = new TestAdapter.ViewHolder();
            LayoutInflater inflater = LayoutInflater.from(getContext());
            convertView = inflater.inflate(R.layout.item_test_row, parent, false);
            viewHolder.testName = convertView.findViewById(R.id.test_name_text);
            viewHolder.testStatistic = convertView.findViewById(R.id.test_statistic_text);
            viewHolder.testResult = convertView.findViewById(R.id.test_result_text);
            convertView.setTag(viewHolder);

        } else {

            viewHolder = (ViewHolder) convertView.getTag();
        }

        String testName = (position + 1) + ". Test " + lection.getTitle();

        viewHolder.testName.setText(testName);
        viewHolder.testStatistic = convertView.findViewById(R.id.test_statistic_text);
        viewHolder.testResult = convertView.findViewById(R.id.test_result_text);

        return convertView;

    }
}
