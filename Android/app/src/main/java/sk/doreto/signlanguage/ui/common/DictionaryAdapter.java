package sk.doreto.signlanguage.ui.common;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import java.util.List;

import sk.doreto.signlanguage.R;
import sk.doreto.signlanguage.database.Word;

public class DictionaryAdapter extends ArrayAdapter<Word> {

    public enum NavigationBarType {
        DICTIONARY,
        FAVORITE
    }

    private List<Word> mData;
    private Context mContext;


    private static class ViewHolder {
        TextView word;
        ImageView image;
    }

    public DictionaryAdapter(List<Word> data, Context context) {
        super(context, R.layout.item_dictionary_row, data);
        this.mData = data;
        this.mContext=context;
    }


    @Override
    public int getCount() {
        return mData.size();
    }

    @Override
    public Word getItem(int position) {
        return mData.get(position);
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



}
