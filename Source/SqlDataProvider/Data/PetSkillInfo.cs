using System;
using System.Collections.Generic;
using System.Text;

namespace SqlDataProvider.Data
{
    public class PetSkillInfo
    {
        public int ID { set; get; }

        public string Name { set; get; }

        public string ElementIDs { set; get; }

        public string Description { set; get; }

        public int BallType { set; get; }

        public int NewBallID { set; get; }

        public int CostMP { set; get; }

        public int Pic { set; get; }

        public string Action { set; get; }

        public string EffectPic { set; get; }

        public int Delay { set; get; }

        public int ColdDown { set; get; }

        public int GameType { set; get; }

        public int Probability { set; get; }

        public int Damage { set; get; }

        public int DamageCrit { set; get; }
                
    }
}
