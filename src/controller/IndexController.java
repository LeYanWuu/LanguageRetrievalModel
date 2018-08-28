package controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.TreeMap;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import languagemodel.DataProcessing;
import languagemodel.DocTerm;
import languagemodel.Unigram;
import net.sf.json.JSONArray;

public class IndexController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // TODO Auto-generated method stub
        doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/text;charset=utf-8");
        Unigram unigram = new Unigram();
        DataProcessing dataProcessing = new DataProcessing();
        boolean isChinese = true;
        String dataDir = this.getServletContext().getRealPath("/data");
        dataProcessing.fetchDocuments(dataDir, isChinese);//处理文件//
        TreeMap<Integer, ArrayList<String>> documents = dataProcessing.getDocuments();
        unigram.buildResultMap(documents);//建立倒排索引
        TreeMap resultMap = unigram.getResultMap();
        Iterator<String> it = resultMap.keySet().iterator();
        String term = null;
        ArrayList posting = null;
        while (it.hasNext()) {
            term = it.next();
            posting = (ArrayList) resultMap.get(term);
            StringBuffer docIDs = new StringBuffer();
            docIDs.append(term + "--->[");
            for (int i = 0; i < posting.size(); i++) {
                DocTerm aa = (DocTerm) posting.get(i);
                docIDs.append(aa.docId + " " + aa.rate);
                docIDs.append(", ");
            }
            docIDs.append(']'+"<br>");
            System.out.println(docIDs.toString());
            resp.getWriter().println(docIDs.toString());
        }
    }
}