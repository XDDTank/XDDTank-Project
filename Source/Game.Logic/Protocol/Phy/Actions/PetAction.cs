using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Game.Logic.Phy.Actions
{
    public class PetAction
    {
        public float Time;

        public int Type;

        public int id;

        public int damage;

        public int dander;

        public int blood;
        /// <summary>
        /// 
        /// </summary>
        /// <param name="time"></param>
        /// <param name="type"></param>
        /// <param name="para1">id</param>
        /// <param name="para2">damage + critical</param>
        /// <param name="para3">critical</param>
        /// <param name="para4">blood</param>
        public PetAction(float time, PetActionType type, int _id, int _damage,  int _dander, int _blood)
        {
            Time = time;
            Type = (int)type;
            id = _id;//id
            damage = _damage;//damage           
            blood = _blood;//blood
            dander = _dander;//critical
        }

        public int TimeInt
        {
            get
            {
                return (int)Math.Round(Time * 1000);
            }
        }
    }
}
