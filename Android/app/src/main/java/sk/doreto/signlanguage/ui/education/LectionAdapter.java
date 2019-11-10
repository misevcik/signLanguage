package sk.doreto.signlanguage.ui.education;

import android.content.Context;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.TextView;

import androidx.core.graphics.drawable.RoundedBitmapDrawable;
import androidx.core.graphics.drawable.RoundedBitmapDrawableFactory;

import java.util.List;

import sk.doreto.signlanguage.R;
import sk.doreto.signlanguage.database.AppDatabase;
import sk.doreto.signlanguage.database.Lection;
import sk.doreto.signlanguage.utils.Utility;


public class LectionAdapter extends ArrayAdapter<Lection> {

    private List<Lection> mData;
    private Context mContext;

    private static class ViewHolder {
        TextView word;
        TextView wordCount;
        ImageView image;
        ProgressBar progressBar;
    }

    public LectionAdapter(List<Lection> data, Context context) {
        super(context, R.layout.item_lection_grid, data);
        this.mData = data;
        this.mContext=context;
    }

    @Override
    public int getCount() {
        return mData.size();
    }

    @Override
    public Lection getItem(int position) {
        return mData.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {

        Lection lection = getItem(position);
        int wordCount = AppDatabase.getAppDatabase(getContext()).wordDao().getWordsCountForLection(lection.getId());
        int wordVisited =  AppDatabase.getAppDatabase(getContext()).wordDao().getVisitedWordsCountForLection(lection.getId());

        LectionAdapter.ViewHolder viewHolder;

        if (convertView == null) {

            LayoutInflater inflater = LayoutInflater.from(getContext());
            convertView = inflater.inflate(R.layout.item_lection_grid, parent, false);
            viewHolder = new LectionAdapter.ViewHolder();
            viewHolder.word = convertView.findViewById(R.id.lection_grid_title);
            viewHolder.wordCount = convertView.findViewById(R.id.lection_grid_word_count);
            viewHolder.image = convertView.findViewById(R.id.lection_grid_image);
            viewHolder.progressBar = convertView.findViewById(R.id.lection_grid_progress_bar);
            convertView.setTag(viewHolder);

        } else {

            viewHolder = (LectionAdapter.ViewHolder) convertView.getTag();
        }

        Resources res = getContext().getResources();

        viewHolder.word.setText(lection.getTitle());
        viewHolder.wordCount.setText(String.format(res.getString(R.string.video_count), wordCount));

        if(wordVisited != 0) {
            viewHolder.progressBar.setVisibility(View.VISIBLE);
            viewHolder.progressBar.setMax(wordCount);
            viewHolder.progressBar.setProgress(wordVisited);
        } else {
            viewHolder.progressBar.setVisibility(View.GONE);
        }

        int imageId = Utility.getResourceId(getContext(), lection.getImage(), "drawable");
        Bitmap bitmap = BitmapFactory.decodeResource(getContext().getResources(), imageId);
        RoundedBitmapDrawable roundedBitmapDrawable = RoundedBitmapDrawableFactory.create(getContext().getResources(), bitmap);
        roundedBitmapDrawable.setCircular(true);
        viewHolder.image.setImageDrawable(roundedBitmapDrawable);

        return convertView;
    }


}
