package controller;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.TreeMap;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import languagemodel.DataProcessing;
import languagemodel.Retrival;
import languagemodel.Unigram;
import net.sf.json.JSONArray;

public class RetrivalController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // TODO Auto-generated method stub
        doPost(req, resp);
    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // TODO Auto-generated method stub


        System.out.println("进入IndexController!");
        resp.setContentType("text/text;charset=utf-8");
        //String docDir = "D:\\eclipse-workspace\\BooleanRetrival\\dataset";
        String dataDir = this.getServletContext().getRealPath("/data");
        //String[] terms = req.getParameterValues("terms");
        String query=req.getParameter("query");
       // String query = req.getQueryString();
        String[] λ = req.getParameterValues("λ");
        Double smooth=null;
        for (int i=0;i<λ.length;i++){
            smooth = Double.valueOf(λ[i]);
        }
        //ArrayList<String> nameResults = new ArrayList<String>();
        //ArrayList<String> contentResults = new ArrayList<String>();
        TreeMap<String, String> results = new TreeMap<String, String>();

        boolean isChinese = true;
        Unigram unigram = new Unigram();
        Retrival retrival=new Retrival();
        DataProcessing document = new DataProcessing ();
        //	document.fetchDocuments(docDir, isChinese);//处理文件//
        // String initDir = this.getServletContext().getRealPath("/lib");
        document.fetchDocuments(dataDir, isChinese);//处理文件//
        TreeMap<Integer, ArrayList<String>>documents =document.getDocuments();
        HashMap<Integer, String> docID_Name = document.getDocID_Name();
        HashMap<Integer, String> docID_Content = document.getDocID_Contents();
        unigram.buildResultMap(documents);//建立倒排索引
        TreeMap resultMap = unigram.getResultMap();
        // calcRate(boolTerms);
        ArrayList terms=retrival.querySolve(query);

        ArrayList<Integer>ResultIDs = retrival.calcRate(terms,documents,resultMap);
        if(null==ResultIDs) {//没有结果
            resp.getWriter().println(0);
        }else {
            for (int i = 0; i < ResultIDs.size(); i++) {
                int id = ResultIDs.get(i);
                //nameResults.add(docID_Name.get(id));
                //contentResults.add(docID_Content.get(id));
                results.put(docID_Name.get(id), docID_Content.get(id));
            }
            if(results.isEmpty()) {//没有结果
                resp.getWriter().println(0);
            }else {
                JSONArray jsonArray =JSONArray.fromObject(results);
                System.out.println("jsonArray是： "+jsonArray);
                resp.getWriter().println(jsonArray);
            }
            System.out.println("检索结果是："+results);
        }
    }
}
