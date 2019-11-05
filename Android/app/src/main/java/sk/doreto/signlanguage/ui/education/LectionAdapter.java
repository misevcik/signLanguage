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

        LectionAdapter.ViewHolder viewHolder;

        if (convertView == null) {

            viewHolder = new LectionAdapter.ViewHolder();
            LayoutInflater inflater = LayoutInflater.from(getContext());
            convertView = inflater.inflate(R.layout.item_lection_grid, parent, false);
            viewHolder.word = convertView.findViewById(R.id.lection_grid_title);
            viewHolder.wordCount = convertView.findViewById(R.id.lection_grid_word_count);
            viewHolder.image = convertView.findViewById(R.id.lection_grid_image);
            convertView.setTag(viewHolder);

        } else {

            viewHolder = (LectionAdapter.ViewHolder) convertView.getTag();
        }

        Resources res = getContext().getResources();

        viewHolder.word.setText(lection.getTitle());
        viewHolder.wordCount.setText(String.format(res.getString(R.string.video_count), wordCount));

        int imageId = Utility.getResourceId(getContext(), lection.getImage(), "drawable");
        Bitmap bitmap = BitmapFactory.decodeResource(getContext().getResources(), imageId);
        RoundedBitmapDrawable roundedBitmapDrawable = RoundedBitmapDrawableFactory.create(getContext().getResources(), bitmap);
        roundedBitmapDrawable.setCircular(true);
        viewHolder.image.setImageDrawable(roundedBitmapDrawable);

        return convertView;
    }


}
