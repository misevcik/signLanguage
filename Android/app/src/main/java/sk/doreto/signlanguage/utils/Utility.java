package sk.doreto.signlanguage.utils;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.media.MediaMetadataRetriever;
import android.net.Uri;
import android.util.Log;
import android.view.View;

import sk.doreto.signlanguage.database.AppDatabase;
import sk.doreto.signlanguage.database.Lection;

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

    public static boolean isValidMediaURI(Context context, Uri uri) {

        try {
            MediaMetadataRetriever retriever = new MediaMetadataRetriever();
            retriever.setDataSource(context, uri);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    public static Drawable getThumbnail(Context context, String resource) {

        try {

            Uri uri = ZipFileContentProvider.buildUri(resource + ".mp4");

            if(!isValidMediaURI(context, uri)) {
                return null;
            }

            MediaMetadataRetriever retriever = new MediaMetadataRetriever();
            retriever.setDataSource(context, uri);

            String duration = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION);
            int time = Integer.valueOf(duration)/2;

            Bitmap bitmap = retriever.getFrameAtTime(time * 1000, MediaMetadataRetriever.OPTION_CLOSEST);

            Drawable drawable = new BitmapDrawable(context.getResources(), bitmap);

            return drawable;

        }
        catch (Exception ex) {
            Log.e("Detail Fragment", "couldn't set thumbnail");
        }

        return null;
    }

    public static String getGrade(int score) {

        if (score < 50)
            return "F";
        else if (50 <= score && score < 60)
            return "E";
        else if (60 <= score && score < 70)
            return "D";
        else if (70 <= score && score < 80)
            return "C";
        else if (80 <= score && score < 90)
            return "B";
        else
            return "A";
    }

    public static void preventDoubleClick(final View view, int timeout){
        view.setEnabled(false);
        view.postDelayed(new Runnable() {
            public void run() {
                view.setEnabled(true);
            }
        }, timeout);
    }

    public static int[] getAnswerResultFromScore(Context context, Lection lection) {

        int wordCount = AppDatabase.getAppDatabase(context).wordDao().getWordsCountForLection(lection.getId());
        int score = lection.getTestScore();
        int result[] = new int[2];

        int testAnswerCount = (wordCount / 3) + 1;
        result[0] = (int)(testAnswerCount / 100.0 * score);
        result[1] = testAnswerCount - result[0];

        return result;
    }

    public static int roundUp(double d){
        return d > (int)d ? (int)(d + 1) : (int)d;
    }

}
