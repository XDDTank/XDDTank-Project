using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic;
using Game.Logic.Phy.Object;

namespace GameServerScript.AI.NPC
{
    public class FiveNormalThirdNpc : ABrain
    {
        private int m_attackTurn = 0;
		
		
		
		private PhysicalObj m_moive;
		
		private PhysicalObj m_front;
		
		private PhysicalObj moive;
		
		private PhysicalObj front;
		
	

       

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
                Stand();
                m_attackTurn++;
            }
            else     if (m_attackTurn == 1)
            {
                Beat();
                m_attackTurn++;
            }
            else
            {

                Die();
            }
        }
        private void Stand()
        {
            Body.PlayMovie("stand",600,0);
        }
		
        private void Beat()
        {
            Player target = Game.FindRandomPlayer();
              if (target != null)
            {
                ((SimpleBoss)Body).SetRelateDemagemRect(-41, -107, 83, 100);

                int mtX = Game.Random.Next(target.X - 10, target.Y + 20);

                if (Body.ShootPoint(target.X, target.Y, 54, 1000, 10000, 1, 3.0f, 2550))
                {
                    Body.PlayMovie("beatA", 2800, 0);
                }
            }
        }
        private void Die()
        {
            Body.Die(1800);
        }
        
	
	
		
		
		
	
        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }
    }
}
