/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package vn.edu.fpt.util;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.fluent.Form;
import org.apache.http.client.fluent.Request;
import vn.edu.fpt.constant.Iconstant;
import vn.edu.fpt.model.GoogleAccount;

/**
 *
 * @author Rinaaaa
 */
public class GoogleLogin {

    public static String getToken(String code) throws ClientProtocolException, IOException, NamingException {
        Context initCtx = (Context) new InitialContext().lookup("java:comp/env");
        String secret = (String) initCtx.lookup("GOOGLE_CLIENT_SECRET");
        
        String response = Request.Post(Iconstant.GOOGLE_LINK_GET_TOKEN)
                .bodyForm(
                        Form.form()
                                .add("client_id", Iconstant.GOOGLE_CLIENT_ID)
                                .add("client_secret", secret)
                                .add("redirect_uri", Iconstant.GOOGLE_REDIRECT_URI)
                                .add("code", code)
                                .add("grant_type", Iconstant.GOOGLE_GRANT_TYPE)
                                .build()
                )
                .execute().returnContent().asString();
        JsonObject jobj = new Gson().fromJson(response, JsonObject.class);
        String accessToken = jobj.get("access_token").toString().replaceAll("\"", "");
        return accessToken;
    }

    public static GoogleAccount getUserInfo(final String accessToken) throws ClientProtocolException, IOException {
        String link = Iconstant.GOOGLE_LINK_GET_USER_INFO + accessToken;
        String response = Request.Get(link).execute().returnContent().asString();
        GoogleAccount googlePojo = new Gson().fromJson(response, GoogleAccount.class);
        return googlePojo;
    }

    public static String getGoogleLoginURL() {
        try {
            String baseURL = "https://accounts.google.com/o/oauth2/v2/auth";
            String scope = URLEncoder.encode("openid email profile", "UTF-8");
            String redirectURI = URLEncoder.encode(Iconstant.GOOGLE_REDIRECT_URI, "UTF-8");
            String clientId = Iconstant.GOOGLE_CLIENT_ID;

            String loginURL = String.format(
                    "%s?scope=%s&access_type=offline&include_granted_scopes=true&response_type=code&state=state_parameter_passthrough_value&redirect_uri=%s&client_id=%s&prompt=consent",
                    baseURL,
                    scope,
                    redirectURI,
                    clientId
            );

            return loginURL;
        } catch (UnsupportedEncodingException e) {
            throw new RuntimeException("Error encoding URL parameters", e);
        }
    }
}
