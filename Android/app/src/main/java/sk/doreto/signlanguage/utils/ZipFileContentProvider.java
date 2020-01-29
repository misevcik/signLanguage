package sk.doreto.signlanguage.utils;

import android.net.Uri;

import com.android.vending.expansion.zipfile.APEZProvider;

import java.io.File;

public class ZipFileContentProvider extends APEZProvider {

    private static final String AUTHORITY = "sk.doreto.signlanguage";

    @Override
    public String getAuthority() {
        return AUTHORITY;
    }

    public static Uri buildUri(String path) {

        StringBuilder contentPath = new StringBuilder("content://");

        contentPath.append(AUTHORITY);
        contentPath.append(File.separator);
        contentPath.append(path);

        return Uri.parse(contentPath.toString());
    }
}