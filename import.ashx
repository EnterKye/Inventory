<%@ WebHandler Language="C#" Class="import" %>

using System;
using System.Web;
using System.Data;
using System.Collections;
using Newtonsoft.Json;
using System.IO;
public class import : IHttpHandler {

   
    SQl db = new SQl();
    Excel title = new Excel();
    public void ProcessRequest (HttpContext context) {
       
        //context.Response.Write("Hello World");
        if (HttpContext.Current.Request.Files.Count > 0) 
        {
            try
            {
                HttpPostedFile file = HttpContext.Current.Request.Files[0];
                string fileName = System.IO.Path.GetFileName(file.FileName);
                string filePath = HttpContext.Current.Server.MapPath("~/files/") + fileName;// +".txt";
                file.SaveAs(filePath);

                DataTable dt = NPOIHelper.ExcelToTable(filePath);
                ArrayList listSql = new ArrayList();
                ArrayList res = new ArrayList();
                foreach (DataRow dr in dt.Rows)
                {
                    title.assetNum = dr["资产号"].ToString();
                    title.deviceName = dr["设备"].ToString();
                    title.user = dr["人员"].ToString();
                    title.address = dr["地点"].ToString();
                    title.state = dr["状态"].ToString();
                    title.markup = dr["备注"].ToString();
                    listSql.Add("insert into ManagementProperty values('" + title.assetNum + "','" + title.deviceName + "','" + title.user + "','" + title.address + "','" + DateTime.Now.ToString() + "','" + title.state + "','" + title.markup + "')");
                    title.count += 1;
                }
                Boolean result = db.ExcuteSqlTran("SqlServer", listSql);
                
                if (!result)
                {
                    
                    context.Response.Write(JsonConvert.SerializeObject("-1"));
                }
                else
                { 
                    //返回上传数据
                    res.Add(title.count);
                    context.Response.Write(JsonConvert.SerializeObject(res));
                }
            }
            catch(Exception ex)
            {
                context.Response.Write(ex.Message);
            }
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