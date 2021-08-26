using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;

namespace GameServerScript.AI.Messions
{
    public class DLN5001 : AMissionControl
    {
        private SimpleBoss boss = null;

        private SimpleNpc npc = null;

        private int npcID = 21001;

        private int bossID = 5121;

        private int kill = 0;

        private PhysicalObj m_moive;

        private PhysicalObj m_front;

        public override int CalculateScoreGrade(int score)
        {
            base.CalculateScoreGrade(score);
            if (score > 1750)
            {
                return 3;
            }
            else if (score > 1675)
            {
                return 2;
            }
            else if (score > 1600)
            {
                return 1;
            }
            else
            {
                return 0;
            }
        }

        public override void OnPrepareNewSession()
        {
            base.OnPrepareNewSession();
            int[] resources = { bossID, npcID};
            Game.LoadResources(resources);
            Game.LoadNpcGameOverResources(resources);
            //Game.AddLoadingFile(2, "image/bomb/blastOut/blastOut51.swf", "shootMovie51");
            //Game.AddLoadingFile(2, "image/bomb/bullet/bullet51.swf", "bullet51");
            //Game.AddLoadingFile(2, "image/bomb/crater/50/crater.png", "");
            //Game.AddLoadingFile(2, "image/bomb/crater/50/craterbrink.png", "");           
            Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.BossBgAsset");
            Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.hongpaoxiaoemoAsset");
            Game.SetMap(1153);
        }

        public override void OnStartGame()
        {
            base.OnStartGame();
            m_moive = Game.Createlayer(0, 0, "moive", "game.asset.living.BossBgAsset", "out", 1, 1);
            m_front = Game.Createlayer(880, 210, "font", "game.asset.living.hongpaoxiaoemoAsset", "out", 1, 1);
            boss = Game.CreateBoss(bossID, 1002, 450, -1, 0, "stand");
            boss.SetRelateDemagemRect(boss.NpcInfo.X, boss.NpcInfo.Y, boss.NpcInfo.Width, boss.NpcInfo.Height);
            //boss.Say(LanguageMgr.GetTranslation("GameServerScript.AI.Messions.DCSM2002.msg1"), 0, 200, 0);
            npc = Game.CreateNpc(npcID, 1002, 453, 1);
            npc.NoTakeDamage = false;
            m_moive.PlayMovie("in", 6000, 0);
            m_front.PlayMovie("in", 6100, 0);
            m_moive.PlayMovie("out", 10000, 1000);
            m_front.PlayMovie("out", 9900, 0);
        }

        public override void OnNewTurnStarted()
        {
        }

        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();
            if (Game.TurnIndex > 1)
            {
                if (m_moive != null)
                {
                    Game.RemovePhysicalObj(m_moive, true);
                    m_moive = null;
                }
                if (m_front != null)
                {
                    Game.RemovePhysicalObj(m_front, true);
                    m_front = null;
                }
            }
        }

        public override bool CanGameOver()
        {
            if (boss != null && boss.IsLiving == false)
            {
                kill++;
                return true;
            }
            return false;
        }

        public override int UpdateUIData()
        {
            base.UpdateUIData();
            return kill;
        }

        public override void OnGameOver()
        {
            base.OnGameOver();
            if (boss.IsLiving == false)
            {

                Game.IsWin = true;
            }
            else
            {
                Game.IsWin = false;
            }
        }
    }
}
