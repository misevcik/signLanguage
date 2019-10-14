package sk.doreto.signlanguage.ui.dictionary;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import java.util.List;

import sk.doreto.signlanguage.R;
import sk.doreto.signlanguage.database.Sentence;
import sk.doreto.signlanguage.database.Word;

public class SentenceAdapter extends ArrayAdapter<Sentence> {

    private List<Sentence> mData;


    private static class ViewHolder {
        TextView sentence;
    }

    public SentenceAdapter(List<Sentence> data, Context context) {
        super(context, R.layout.sentence_row_item, data);
        this.mData = data;
    }


    @Override
    public int getCount() {
        return mData.size();
    }

    @Override
    public Sentence getItem(int position) {
        return mData.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }


    @Override
    public View getView(int position, View convertView, ViewGroup parent) {

        Sentence sentence = getItem(position);
        ViewHolder viewHolder;

        if (convertView == null) {

            viewHolder = new ViewHolder();
            LayoutInflater inflater = LayoutInflater.from(getContext());
            convertView = inflater.inflate(R.layout.sentence_row_item, parent, false);
            viewHolder.sentence = convertView.findViewById(R.id.dictionary_detail_row_sentence);
            convertView.setTag(viewHolder);

        } else {

            viewHolder = (ViewHolder) convertView.getTag();
        }

        viewHolder.sentence.setText(sentence.getSentence());

        return convertView;
    }
}
