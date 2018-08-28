package controller;

import java.io.IOException;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import languagemodel.DataProcessing;

public class SegmentController extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // TODO Auto-generated method stub
        doPost(req, resp);
    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/text;charset=utf-8");
        String fileName = req.getParameter("fileName");
        boolean isChinese = true;
        DataProcessing dataProcessing = new  DataProcessing();
        String dataDir = this.getServletContext().getRealPath("/data");
        dataProcessing.fetchDocuments(dataDir, isChinese);
        System.out.println("分词成功");
        String segments = dataProcessing.getSegments().get(fileName);
        System.out.println("segments=="+segments);
        resp.getWriter().println(segments);
    }
}
