package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

//输出去标点的分词的结果
public class RemoveTxtFileController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // TODO Auto-generated method stub
        doPost(req, resp);
    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // TODO Auto-generated method stub
        resp.setContentType("text/text;charset=utf-8");
        String contents = req.getParameter("fileContents");
        System.out.println(contents);
        String removeResult =  contents.toString().replaceAll("\\pP", "");// 去除标点符号
        System.out.println("removeResult=="+removeResult);
        resp.getWriter().println(removeResult);
    }
}

