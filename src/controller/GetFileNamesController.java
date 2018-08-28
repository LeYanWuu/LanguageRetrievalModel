package controller;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import languagemodel.DataProcessing;
import net.sf.json.JSONArray;

public class GetFileNamesController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/text;charset=utf-8");
        String docDir = "F:\\LanguageModel\\data";
        DataProcessing dataProcessing = new  DataProcessing();
        ArrayList<String> fileNames = dataProcessing.getFileNames(docDir);
        JSONArray jsonArray =JSONArray.fromObject(fileNames);
        System.out.println(jsonArray);
        resp.getWriter().println(jsonArray);

    }
}
