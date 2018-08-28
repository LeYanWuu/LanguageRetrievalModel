# LanguageRetrievalModel
This is a demo to show the steps of language retrieval model. Up to now, only unigram is available.

本模型中的分词采用的是Hanlp分词包，故应先将Hanlp分词包导入外部libraries中，且应在web项目中在Tomcat的configuration中导入hanlp的jar包。其他关于hanlp的HanLP.properties配置文件的修改及放置位置见http://hanlp.linrunsoft.com/doc/_build/html/getting_started.html 

本检索模型既允许用户选择后台的文件进行分词、去除标点符号、建立索引，并输入文字进行检索，亦允许用户选择本地的文件来进行分词、去除标点符号。
