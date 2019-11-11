package sk.doreto.signlanguage.ui.info;


import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;


import sk.doreto.signlanguage.database.Word;

public class InfoAdatper extends BaseAdapter {

    private InfoItem[] infoItems;

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

        return null;
    }

}
