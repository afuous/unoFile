package com.pickledcucumber.unofile;

import android.support.v4.app.Fragment;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;

import java.net.MalformedURLException;

import unofile.pickledcucumber.com.unofile.R;

/**
 * Created by david on 3/19/15.
 */
public class DownloadFragment extends Fragment {

    public void DownloadFragment() {
        DownloadFragment fragment = new DownloadFragment();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_download, container, false);
        return rootView;
    }

}
