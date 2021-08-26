using System;
using System.Collections.Generic;
using System.Text;

namespace SqlDataProvider.Data
{
    /// <summary>
    /// 箱子掉落表
    /// </summary>
    public class LoadUserBoxInfo : DataObject
    {
        public int ID { get; set; }
        public int Type { get; set; }
        public int Level { get; set; }
        public int Condition { get; set; }
        public int TemplateID { get; set; }
    }
}
