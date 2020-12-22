<%@ WebHandler Language="C#" Class="Inventory" %>

using System;
using System.Web;
using System.Data;
using Newtonsoft.Json;
public class Inventory : IHttpHandler {
    SQLHelper db = new SQLHelper();
    string key1 = string.Empty;
    string key2 = string.Empty;
    string key3 = string.Empty;
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        int i;
        int pageSize = int.Parse(context.Request.QueryString["limit"]);
        int pageNumber = int.Parse(context.Request.QueryString["page"]);


        key1 = context.Request.QueryString["key[id]"];
        key2 = context.Request.QueryString["key[user]"];
        key3 = context.Request.QueryString["key[selectVal]"];

        if ((key1 == null || key1.Trim() == "") && (key2 == null || key2.Trim() == "") && (key3 == null || key3.Trim() == ""))
        {
            string str = JsonConvert.SerializeObject(SQLJSON(pageNumber, pageSize, out i));
            str = "{\"code\":0,\"msg\":\"\",\"count\":" + i + ",\"data\":" + str + "}";
            context.Response.Write(str);
        }
        else
        {
            string str = JsonConvert.SerializeObject(SQLjsonII(pageNumber, pageSize, out i,key1,key2,key3));
            str = "{\"code\":0,\"msg\":\"\",\"count\":" + i + ",\"data\":" + str + "}";
            context.Response.Write(str);
        }
        
        
       

    }
    /// <summary>
    /// 
    /// </summary>
    /// <param name="PageNumber"></param>
    /// <param name="PageSize"></param>
    /// <param name="i"></param>
    /// <returns></returns>
    public DataTable SQLJSON(int PageNumber, int PageSize, out int i)
    {
        int pages;
        pages = PageSize * (PageNumber - 1);
        //string sql = "select top " + PageSize + " oddNumbers,assetNumbers,line,workStation,unExplain,submitDateTime,submitUser,state from Liaison where oddNumbers not in (select top " + pages + " oddNumbers from Liaison order by oddNumbers) order by oddNumbers desc";
        string sql = "select assetNum,deviceName,moveUser,moveAddress,moveTime,states,remarks from (" + "select *,row_number() over(order by id desc) num " + "from ManagementProperty as tb_a) as tb_b" + " where num between " + ((PageNumber - 1) * PageSize + 1) + " and " + (PageNumber) * PageSize + " ";

        DataTable ds = db.ExecuteQuery(sql, CommandType.Text);
        string count = "select count(*) '数量' from ManagementProperty";
        DataTable dt = db.ExecuteQuery(count, CommandType.Text);
        i = Convert.ToInt32(dt.Rows[0]["数量"].ToString());
        return ds;
    }


    public DataTable SQLjsonII(int pageNumber, int pageSize, out int i, string key1, string key2, string key3)//参数化查询
    {

        string sqlWhere = "";
        if (key1 != "")
        {
            sqlWhere = " assetNum ='" + key1 + "'";
        }
        if (key2 != "")
        {
            if (sqlWhere == "")
            {
                sqlWhere = " moveUser='" + key2 + "'";
            }
            else
            {
                sqlWhere += " and moveUser='" + key2 + "'";
            }
        }
        if (key3 != "请选择")
        {
            if (sqlWhere == "")
            {
                sqlWhere = " states='" + key3 + "'";
            }
            else
            {
                sqlWhere += " and states='" + key3 + "'";
            }
        }

        int pages;
        pages = pageSize * (pageNumber - 1);
        string sql = string.Empty;
        if (sqlWhere == "")
        {
            sql = "select assetNum,deviceName,moveUser,moveAddress,moveTime,states,remarks from (" + "select *,row_number() over(order by id desc) num " + "from ManagementProperty as tb_a) as tb_b" + " where " + sqlWhere + " num between " + ((pageNumber - 1) * pageSize + 1) + " and " + (pageNumber) * pageSize + " ";
        }
        else
        {
            //sql = "select assetNum,deviceName,moveUser,moveAddress,moveTime,states,remarks from (" + "select *,row_number() over(order by id desc) num " + "from ManagementProperty as tb_a) as tb_b" + " where " + sqlWhere + " and num between " + ((pageNumber - 1) * pageSize + 1) + " and " + (pageNumber) * pageSize + " ";
            sql = "select assetNum,deviceName,moveUser,moveAddress,moveTime,states,remarks from (" + "select *,row_number() over(order by id desc) num " + "from ManagementProperty as tb_a) as tb_b" + " where " + sqlWhere + " ";
        }
        
        DataTable ds = db.ExecuteQuery(sql, CommandType.Text);
        string count = string.Empty;
        if (sqlWhere == "")
        {
            count = "select count(*) '数量' from ManagementProperty";
        }
        else {
            count = "select count(*) '数量' from ManagementProperty where " + sqlWhere + "";
        }
    
        DataTable dt = db.ExecuteQuery(count, CommandType.Text);
        i = Convert.ToInt32(dt.Rows[0]["数量"].ToString());
        return ds;
    }
    public bool IsReusable {
        get {
            return false;
        }
    }

}