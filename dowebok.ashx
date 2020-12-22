<%@ WebHandler Language="C#" Class="dowebok" %>

using System;
using System.Web;
using System.Data;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using System.Collections;
public class dowebok : IHttpHandler {
    SQLHelper db = new SQLHelper();
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string action = context.Request["action"].ToString();
        switch (action) 
        { 
            case "getCount":
                getCount(context);
                break;
            case "scrollData":
                scrollData(context);
                break;
            case "ngCount":
                ngCount(context);
                break;
            case "waitCount":
                waitCount(context);
                break;
            default:
                context.Response.StatusCode = 401;
                break;
        }
       
        
        
    }
    public void getCount(HttpContext context)
    {
       // string sql = "select deviceName,count(deviceName) 'count' from ManagementProperty where moveAddress='在库' group by deviceName";
        string sql="select deviceName, count(deviceName)'count' from(select * from ManagementProperty a where not exists(select 1 from ManagementProperty where assetNum = a.assetNum and moveTime  > a.moveTime)and a.moveAddress = '在库')x group by deviceName";
        
        DataTable dt = db.ExecuteQuery(sql, CommandType.Text);
        context.Response.Write(JsonConvert.SerializeObject(dt));
    }
    public void ngCount(HttpContext context)
    {
        string NGsql = "select  deviceName,COUNT(deviceName)'ngNum' from ManagementProperty  where states ='NG' and moveAddress='在库' group by deviceName";
        DataTable dt = db.ExecuteQuery(NGsql, CommandType.Text);
       

        context.Response.Write(JsonConvert.SerializeObject(dt));
    }
    public void waitCount(HttpContext context)
    {
        string NGsql = "select deviceName,COUNT(deviceName)'waitNum' from ManagementProperty  where states ='待报废' and moveAddress='在库' group by deviceName";
        DataTable dt = db.ExecuteQuery(NGsql, CommandType.Text);
        context.Response.Write(JsonConvert.SerializeObject(dt));
    }
    public void scrollData(HttpContext context)
    {
        string sql = "select top 5 moveTime,moveAddress,deviceName,assetNum from ManagementProperty order by id desc";
        DataTable dt = db.ExecuteQuery(sql, CommandType.Text);
        IsoDateTimeConverter timeConverter = new IsoDateTimeConverter { DateTimeFormat = "yyyy'-'MM'-'dd' 'HH':'mm" };//这里使用自定义日期格式，如果不使用的话，默认是ISO8601格式 
        context.Response.Write(JsonConvert.SerializeObject(dt, Formatting.Indented, timeConverter));
    }
    public bool IsReusable {
        get {
            return false;
        }
    }

}