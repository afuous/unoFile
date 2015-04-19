package com.pickledcucumber.unofile;

import android.os.AsyncTask;
import android.os.Environment;

import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.params.HttpConnectionParams;
import org.apache.http.params.HttpParams;
import org.apache.http.util.ByteArrayBuffer;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.net.MalformedURLException;
import java.net.URISyntaxException;
import java.net.URL;
import java.net.URLConnection;
import java.util.List;

/**
 * Created by david on 3/19/15.
 */
public class Upload extends AsyncTask<String, Void, Void> {
    URL url;

    private static final int STREAM_LENGTH = 500;
    private List<NameValuePair> nameValuePairs;

    public Upload(List<NameValuePair> nameValuePairs) {
        this.nameValuePairs = nameValuePairs;
    }

    @Override
    protected Void doInBackground(String ... values) {
        nameValuePairs.add(new BasicNameValuePair("file", values[0]));
        nameValuePairs.add(new BasicNameValuePair("code", values[1]));
        // Create a new HttpClient and Post Header, set timeout values
        HttpClient httpClient = new DefaultHttpClient();
        HttpParams httpParams = httpClient.getParams();
        HttpConnectionParams.setConnectionTimeout(httpParams, 3000);
        HttpConnectionParams.setConnectionTimeout(httpParams, 3000);
        HttpPost httppost;
        try {
            httppost = new HttpPost(url.toURI());
            // Add data to Post request
            httppost.setEntity(new UrlEncodedFormEntity(nameValuePairs));

            // Execute HTTP Post Request
            HttpResponse response = httpClient.execute(httppost);
            String responseString =  readInputStream(response.getEntity().getContent(), STREAM_LENGTH);

        } catch (ClientProtocolException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (URISyntaxException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Reads an InputStream and converts it to a String.
    public String readInputStream(InputStream stream, int len) throws IOException {
        Reader reader = new InputStreamReader(stream, "UTF-8");
        char[] buffer = new char[len];
        reader.read(buffer);
        return new String(buffer);
    }
}
