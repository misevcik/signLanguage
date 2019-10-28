package sk.doreto.signlanguage.ui.education;

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

public class LectionDictionaryAdapter extends ArrayAdapter<Word> {

    private List<Word> mData;
    private Context mContext;


    private static class ViewHolder {
        TextView word;
        ImageView image;
    }

    public LectionDictionaryAdapter(List<Word> data, Context context) {
        super(context, R.layout.dictionary_row_item, data);
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

            viewHolder = new LectionDictionaryAdapter.ViewHolder();
            LayoutInflater inflater = LayoutInflater.from(getContext());
            convertView = inflater.inflate(R.layout.dictionary_row_item, parent, false);
            viewHolder.word = convertView.findViewById(R.id.dictionary_row_word);
            viewHolder.image = convertView.findViewById(R.id.favorite_image);
            convertView.setTag(viewHolder);

        } else {

            viewHolder = (ViewHolder) convertView.getTag();
        }


        viewHolder.word.setText(word.getWord());
        viewHolder.image.setImageResource(word.getVisited() ? R.mipmap.icon_chevron_red : R.mipmap.icon_chevron_black);

        return convertView;
    }



}
