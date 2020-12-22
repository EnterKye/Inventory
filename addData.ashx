<%@ WebHandler Language="C#" Class="addData" %>

using System;
using System.Web;
using System.Collections;
using System.Data;

public class addData : IHttpHandler {
    SQLHelper db = new SQLHelper();
    public void ProcessRequest (HttpContext context) {
        ArrayList info = new ArrayList();
        info.Add(context.Request["Num"]);
        info.Add(context.Request["Name"]);
        info.Add(context.Request["User"]);
        info.Add(context.Request["Address"]);
        info.Add(DateTime.Now.ToString("yyyy-MM-dd HH:mm"));        
        info.Add(context.Request["State"]);
        info.Add(context.Request["Mark"]);
        string insSql = "insert into ManagementProperty values('" + info[0] + "','" + info[1] + "','" + info[2] + "','" + info[3] + "','" + info[4] + "','" + info[5] + "','" + info[6] + "')";
        int result = db.ExecuteMonQuery(insSql, CommandType.Text);
        if (result == 1)
        {
            context.Response.Write("0");
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