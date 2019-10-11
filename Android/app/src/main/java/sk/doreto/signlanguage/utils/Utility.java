package sk.doreto.signlanguage.utils;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.media.MediaMetadataRetriever;
import android.net.Uri;
import android.util.Log;

public class Utility {

    public static int getResourceId(Context context, String variableName, String resourceName)
    {
        String packageName = context.getPackageName();

        try {
            return context.getResources().getIdentifier(variableName, resourceName, packageName);
        } catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }

    public static Drawable getThumbnail(Context context, String resource) {

        int resourceId = Utility.getResourceId(context, resource, "raw");
        String path = "android.resource://" + context.getPackageName() + "/" + resourceId;

        try {

            Uri uri = Uri.parse(path);

            MediaMetadataRetriever retriever = new MediaMetadataRetriever();
            retriever.setDataSource(context, uri);

            String duration = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION);
            int time = Integer.valueOf(duration)/2;

            Bitmap bitmap = retriever.getFrameAtTime(25000000, MediaMetadataRetriever.OPTION_CLOSEST);

            Drawable drawable = new BitmapDrawable(context.getResources(), bitmap);

            return drawable;

        }
        catch (Exception ex) {
            Log.e("Detail Fragment", "couldn't set thumbnail");
        }

        return null;
    }

}
