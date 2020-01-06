package sk.doreto.signlanguage.ui.common;

import android.app.Application;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Filter;
import android.widget.Filterable;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.lifecycle.ViewModel;
import androidx.lifecycle.ViewModelProvider;

import java.util.ArrayList;
import java.util.List;

import sk.doreto.signlanguage.R;
import sk.doreto.signlanguage.database.Word;
import sk.doreto.signlanguage.ui.education.LectionDictionaryViewModel;


public class DictionaryAdapter extends ArrayAdapter<Word> implements Filterable {

    private static class ViewHolder {
        TextView word;
        ImageView image;
    }

    private List<Word> wordList;
    private List<Word> filteredWordList;
    private ValueFilter valueFilter;


    public DictionaryAdapter(Context context) {
        super(context, R.layout.item_dictionary_row);
    }

    public void setWordList(List<Word> wordList) {

        if(wordList == null) {
            return;
        }

        this.wordList = wordList;
        this.filteredWordList = new ArrayList<>(wordList);
        buildSection();
        notifyDataSetChanged();
    }

    public List<Word> getWordList() {
        //return filteredWordList because it is list which is shown on the screen
        return filteredWordList;
    }


    @Override
    public int getCount() {

        if (filteredWordList == null) {
            return 0;
        }

        return filteredWordList.size();
    }

    @Override
    public Word getItem(int position) {
        return filteredWordList.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }


    @Override
    public View getView(int position, View convertView, ViewGroup parent) {

        LayoutInflater inflater = LayoutInflater.from(getContext());
        Word word = getItem(position);

        if(word.isSection()) {

            convertView = inflater.inflate(R.layout.item_section_row, parent, false);
            TextView section = convertView.findViewById(R.id.section_row);
            section.setText(word.getSection());


        } else {

            ViewHolder viewHolder;

            if (convertView == null || (convertView != null && convertView.getTag() == null)) {

                viewHolder = new ViewHolder();
                convertView = inflater.inflate(R.layout.item_dictionary_row, parent, false);
                viewHolder.word = convertView.findViewById(R.id.dictionary_row_word);
                viewHolder.image = convertView.findViewById(R.id.favorite_image);
                convertView.setTag(viewHolder);

            }
            else {
                viewHolder = (ViewHolder) convertView.getTag();
            }


            viewHolder.word.setText(word.getWord());
            viewHolder.image.setImageResource(word.getFavorite() ? R.drawable.icon_heart_red : R.drawable.icon_heart_black);
        }

        return convertView;
    }

    @Override
    public Filter getFilter() {
        if (valueFilter == null) {
            valueFilter = new ValueFilter();
        }
        return valueFilter;
    }

    private void buildSection() {

        if(filteredWordList == null)
            return;

        if(filteredWordList.size() == 0)
            return;

        filteredWordList.add(0, new Word(filteredWordList.get(0).getWord().substring(0, 1).toUpperCase()));

        if(filteredWordList.size() <= 2)
            return;

        for(int i = 2; i < filteredWordList.size(); ++i) {

            String previous = filteredWordList.get(i - 1).getWord();
            String current = filteredWordList.get(i).getWord();

            //EXCEPTION because fo wrong ordering
            if((previous.charAt(0) == 'A' && current.charAt(0) == 'Á') || (previous.charAt(0) == 'Á' && current.charAt(0) == 'A'))
                continue;

            if(previous.charAt(0) != current.charAt(0)) {
                
                if(current.charAt(0) == 'C' && current.charAt(1) == 'h') {
                    filteredWordList.add(i, new Word(current.substring(0, 2).toUpperCase()));
                } else {
                    filteredWordList.add(i, new Word(current.substring(0, 1).toUpperCase()));
                }
                ++i;
            }
        }
    }

    private class ValueFilter extends Filter {

        @Override
        protected FilterResults performFiltering(CharSequence constraint) {
            FilterResults results = new FilterResults();

            if (constraint != null && constraint.length() > 0) {

                List<Word> filterList = new ArrayList<>();

                for (int i = 0; i < wordList.size(); i++) {

                    String word = wordList.get(i).getWord();
                    if ((word.toUpperCase()).startsWith(constraint.toString().toUpperCase())) {
                        filterList.add(wordList.get(i));
                    }
                }
                results.count = filterList.size();
                results.values = filterList;
            } else {
                results.count = wordList.size();
                results.values = wordList;
            }
            return results;

        }

        @Override
        protected void publishResults(CharSequence constraint, FilterResults results) {

            //Fix crash during rotation
            if(results.count == 0) {
                return;
            }

            List<Word> data = (List<Word>)results.values;
            filteredWordList = new ArrayList<>(data);
            buildSection();
            notifyDataSetChanged();
        }
    }
}
