using System;
using System.Collections.Generic;
using System.Text;

namespace SqlDataProvider.Data
{
    public class CardTemplateInfo
    {
        public int ID { set; get; }
        public int CardID { set; get; }
        public int CardType { set; get; }
        public int probability { set; get; }
        public int AttackRate { set; get; }
        public int AddAttack { set; get; }
        public int DefendRate { set; get; }
        public int AddDefend { set; get; }
        public int AgilityRate { set; get; }
        public int AddAgility { set; get; }
        public int LuckyRate { set; get; }
        public int AddLucky { set; get; }
        public int DamageRate { set; get; }
        public int AddDamage { set; get; }
        public int GuardRate { set; get; }
        public int AddGuard { set; get; }
    }
}
