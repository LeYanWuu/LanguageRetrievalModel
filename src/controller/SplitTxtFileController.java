package controller;

import java.io.IOException;
import java.util.List;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.hankcs.hanlp.HanLP;
import com.hankcs.hanlp.seg.common.Term;
import com.hankcs.hanlp.tokenizer.StandardTokenizer;

//带标点的分词结果
public class SplitTxtFileController extends HttpServlet {
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
        HanLP.Config.ShowTermNature = false;//关闭词性标注
        List<Term> termList =StandardTokenizer.segment(contents.toString());
        List stri = termList;//将分词结果存入数组
        String strResult = "";
        for (int i = 0; i < stri.size(); i++) {
            strResult += stri.get(i) + " ";
        }
        String splitResult = strResult;//带标点的分词结果
        System.out.println("splitResult=="+splitResult);
        resp.getWriter().println(splitResult);
    }
}

