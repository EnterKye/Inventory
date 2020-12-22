using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// import 的摘要说明
/// </summary>
public class Excel
{
    /// <summary>
    /// 资产号
    /// </summary>
    public string assetNum { get; set; }
    /// <summary>
    /// 设备名称
    /// </summary>
    public string deviceName { get; set; }
    /// <summary>
    /// 移动人员
    /// </summary>
    public string user { get; set; }
    /// <summary>
    /// 移动位置
    /// </summary>
    public string address { get; set; }
    /// <summary>
    /// 状态
    /// </summary>
    public string state { get; set; }
    /// <summary>
    /// 备注
    /// </summary>
    public string markup { get; set; }
    /// <summary>
    /// 总数
    /// </summary>
    public int count { get; set; }
}