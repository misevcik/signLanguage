package sk.doreto.signlanguage.ui.info;


import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;


import sk.doreto.signlanguage.R;

public class InfoAdatper extends BaseAdapter {

    private InfoItem[] infoItems;
    private TextView text;
    private ImageView image;

    public InfoAdatper(InfoItem[] infoItems) {
        this.infoItems = infoItems;
    }

    @Override
    public int getCount() {
        return infoItems.length;
    }

    @Override
    public InfoItem getItem(int position) {
        return infoItems[position];
    }

    @Override
    public long getItemId(int position) {
        return position;
    }


    @Override
    public View getView(int position, View convertView, ViewGroup parent) {

        LayoutInflater inflater = LayoutInflater.from(parent.getContext());
        InfoItem infoItem = getItem(position);

        convertView = inflater.inflate(R.layout.item_info_row, parent, false);

        text = convertView.findViewById(R.id.info_text);
        image = convertView.findViewById(R.id.info_icon_image);

        text.setText(infoItem.text);
        image.setImageResource(infoItem.picture);

        return convertView;
    }

}
