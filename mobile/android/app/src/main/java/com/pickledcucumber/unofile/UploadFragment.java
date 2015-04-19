package com.pickledcucumber.unofile;

import android.content.Intent;
import android.support.v4.app.Fragment;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import unofile.pickledcucumber.com.unofile.R;

/**
 * Created by david on 3/19/15.
 */
public class UploadFragment extends Fragment {

    /**
     * Returns a new instance of this fragment for the given section
     * number.
     */
    public void DownloadFragment() {
        DownloadFragment fragment = new DownloadFragment();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_upload, container, false);
        return rootView;
    }


}
