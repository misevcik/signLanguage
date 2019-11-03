package sk.doreto.signlanguage.ui.common;

import android.content.Context;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Filter;
import android.widget.Filterable;
import android.widget.ImageView;
import android.widget.TextView;

import java.util.ArrayList;
import java.util.List;

import sk.doreto.signlanguage.R;
import sk.doreto.signlanguage.database.Word;

public class DictionaryAdapter extends ArrayAdapter<Word> implements Filterable {

    private List<Word> mDataToFilter;
    private List<Word> mDataToShow;

    private ValueFilter valueFilter;
    private Context mContext;


    private static class ViewHolder {
        TextView word;
        ImageView image;
    }

    public DictionaryAdapter(List<Word> data, Context context) {
        super(context, R.layout.item_dictionary_row, data);
        this.mDataToFilter = data;
        this.mDataToShow = data;
        this.mContext=context;
    }


    @Override
    public int getCount() {
        return mDataToShow.size();
    }

    @Override
    public Word getItem(int position) {
        return mDataToShow.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }


    @Override
    public View getView(int position, View convertView, ViewGroup parent) {

        Word word = getItem(position);
        ViewHolder viewHolder;

        if (convertView == null) {

            viewHolder = new ViewHolder();
            LayoutInflater inflater = LayoutInflater.from(getContext());
            convertView = inflater.inflate(R.layout.item_dictionary_row, parent, false);
            viewHolder.word = convertView.findViewById(R.id.dictionary_row_word);
            viewHolder.image = convertView.findViewById(R.id.favorite_image);
            convertView.setTag(viewHolder);

        } else {

            viewHolder = (ViewHolder) convertView.getTag();
        }


        viewHolder.word.setText(word.getWord());
        viewHolder.image.setImageResource(word.getFavorite() ? R.mipmap.icon_heart_red : R.mipmap.icon_heart_black);

        return convertView;
    }

    @Override
    public Filter getFilter() {
        if (valueFilter == null) {
            valueFilter = new ValueFilter();
        }
        return valueFilter;
    }

    private class ValueFilter extends Filter {

        @Override
        protected FilterResults performFiltering(CharSequence constraint) {
            FilterResults results = new FilterResults();

            if (constraint != null && constraint.length() > 0) {

                List<Word> filterList = new ArrayList<>();

                for (int i = 0; i < mDataToFilter.size(); i++) {

                    String word = mDataToFilter.get(i).getWord();
                    if ((word.toUpperCase()).startsWith(constraint.toString().toUpperCase())) {
                        filterList.add(mDataToFilter.get(i));
                    }
                }
                results.count = filterList.size();
                results.values = filterList;
            } else {
                results.count = mDataToFilter.size();
                results.values = mDataToFilter;
            }
            return results;

        }

        @Override
        protected void publishResults(CharSequence constraint,
                                      FilterResults results) {
            mDataToShow = (List<Word>) results.values;
            notifyDataSetChanged();
        }

    }



}
