<%@ WebHandler Language="C#" Class="listInfo" %>

using System;
using System.Web;
using Newtonsoft.Json;
using System.Data;
using System.Collections;
using System.Web
public class listInfo : IHttpHandler {
    SQLHelper db = new SQLHelper();
    public void ProcessRequest (HttpContext context) {
    
        context.Response.ContentType = "text/plain";
        string str = context.Request["key"];
        string[] strArray = str.Split('?');
        string[] Array = strArray[1].Split('|');
        //主机|刘钰|在库|2020-12-22T12:08:00|可用
        string sql = "select * from ManagementProperty where deviceName='" + Array[0] + "' and moveUser='" + Array[1] + "' and moveAddress='" + Array[2] + "' and moveTime='" + Array[3] + "' and states='" + Array[4] + "'";
        DataTable dt = db.ExecuteQuery(sql, CommandType.Text);
        ArrayList list = new ArrayList();
        if (dt.Rows.Count > 0)
        {           
            for (int i = 0; i < dt.Columns.Count; i++)
            {
                list.Add(dt.Rows[0][i].ToString());
            }
            context.Response.Write(JsonConvert.SerializeObject(list));                             
        }
        else
        {
            context.Response.Write("-1");
        }
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}