using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;
/// <summary>
/// SQLHelper 的摘要说明
/// </summary>
public class SQLHelper
{
    private SqlConnection con = null;
    private SqlCommand cmd = null;
    private SqlDataReader dr = null;
	public  SQLHelper()
	{
		//
		// TODO: 在此处添加构造函数逻辑
		//
        string strCon = ConfigurationManager.ConnectionStrings["strCon"].ConnectionString;
        con = new SqlConnection(strCon);
	}
   
    /// <summary>
    /// 打开数据库连接
    /// </summary>
    /// <returns></returns>
    private SqlConnection GetCon()
    {
        if (con.State == ConnectionState.Closed)
        {
            con.Open();
        }
        return con;
    }
    /// <summary>
    /// 关闭数据库连接
    /// </summary>
    private void OutCon()
    {
        if (con.State == ConnectionState.Open)
        {
            con.Close();
        }  
    }
    //执行不带参数的增删改SQL语句或存储过程
    public int ExecuteMonQuery(string cmdText, CommandType ct)
    {
        int res;
        try
        {
            cmd = new SqlCommand(cmdText, GetCon());
            cmd.CommandType = ct;
            res = cmd.ExecuteNonQuery();
        }
        catch (Exception ex)
        {
            throw ex;
        }
        finally
        {
            OutCon();
        }
        return res;
    }
    /// <summary>
    /// 执行带参数的增删改SQL语句或存储过程
    /// </summary>
    /// <param name="cmdText"></param>
    /// <param name="paras"></param>
    /// <param name="ct"></param>
    /// <returns></returns>
    public int ExecuteMonQuery(string cmdText, SqlParameter[] paras, CommandType ct)
    {
        int res;
        try
        {
            cmd = new SqlCommand(cmdText, GetCon());
            cmd.CommandType = ct;
            cmd.Parameters.AddRange(paras);
            res = cmd.ExecuteNonQuery();

        }
        catch (Exception ex)
        {
            throw ex;
        }
        finally
        {
            OutCon();
        }
        return res;
    }
    /// <summary>
    /// 执行不带参数的查询SQL语句或存储过程
    /// </summary>
    /// <param name="cmdText"></param>
    /// <param name="ct"></param>
    /// <returns></returns>
    public DataTable ExecuteQuery(string cmdText, CommandType ct)
    {
        DataTable dt = new DataTable();
        cmd = new SqlCommand(cmdText, GetCon());
        cmd.CommandType = ct;
        using (dr = cmd.ExecuteReader(CommandBehavior.CloseConnection))
        {
            dt.Load(dr);
        }
        return dt;
    }
    //执行带参数的查询SQL语句或存储过程
    public DataTable ExecuteQuery(string cmdText, SqlParameter[] paras, CommandType ct)
    {
        DataTable dt = new DataTable();
        cmd = new SqlCommand(cmdText, GetCon());
        cmd.CommandType = ct;
        cmd.Parameters.AddRange(paras);
        using (dr = cmd.ExecuteReader(CommandBehavior.CloseConnection))
        {
            dt.Load(dr);
        }
        return dt;
    }
   
}