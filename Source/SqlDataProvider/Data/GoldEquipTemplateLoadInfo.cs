using System;
using System.Collections.Generic;
using System.Text;

namespace SqlDataProvider.Data
{
    public class GoldEquipTemplateLoadInfo
    {
        public int ID { set; get; }
        public int OldTemplateId { set; get; }
        public int NewTemplateId { set; get; }
        public int CategoryID { set; get; }
        public int Strengthen { set; get; }
        public int Attack { set; get; }
        public int Defence { set; get; }
        public int Agility { set; get; }
        public int Luck { set; get; }
        public int Damage { set; get; }
        public int Guard { set; get; }
        public int Boold { set; get; }
        public int BlessID { set; get; }
        public string Pic { set; get; }

    }
}
