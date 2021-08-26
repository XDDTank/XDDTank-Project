using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic;
using Game.Logic.Phy.Object;

namespace GameServerScript.AI.NPC
{
    public class FiveNormalThirdNpc1 : ABrain
    {
        private int m_attackTurn = 0;
		
		private int npcID = 5122;
		
		private int npcID2 = 5123;
		
		private PhysicalObj m_moive;
		
		private PhysicalObj m_front;
		
		private PhysicalObj moive;
		
		private PhysicalObj front;
		
		private PhysicalObj wallLeft = null;

       

        public override void OnBeginSelfTurn()
        {
            base.OnBeginSelfTurn();
        }

        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();
            m_body.CurrentDamagePlus = 1;
            m_body.CurrentShootMinus = 1;
        }

        public override void OnCreated()
        {
            base.OnCreated();
        }

        public override void OnStartAttacking()
        {
            base.OnStartAttacking();
            Body.Direction = Game.FindlivingbyDir(Body);
            bool result = false;
            int maxdis = 0;
            foreach (Player player in Game.GetAllFightPlayers())
            {
                if (player.IsLiving && player.X > 0 && player.X < 0)
                {
                    int dis = (int)Body.Distance(player.X, player.Y);
                    if (dis > maxdis)
                    {
                        maxdis = dis;
                    }
                    result = true;
                }
            }


            if (m_attackTurn == 0)
            {
                AtoB();
                m_attackTurn++;
            }
            else
            {

                Body.PlayMovie("standB", 700,0);
            }
        }
        private void AtoB()
        {
            Body.PlayMovie("AtoB", 1900,0);
        }
		
        private void Damage()
        {
            Player target = Game.FindRandomPlayer();
              if (target != null)
            {
                ((SimpleBoss)Body).SetRelateDemagemRect(-41, -107, 83, 100);

                int mtX = Game.Random.Next(target.X - 10, target.Y + 20);

                if (Body.ShootPoint(target.X, target.Y, 54, 1000, 10000, 1, 3.0f, 2550))
                {
                    Body.PlayMovie("beatA", 1200, 0);
                }
            }
        }
        
	
	
		
		
		
	
        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }
    }
}
