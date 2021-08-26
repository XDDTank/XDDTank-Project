using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;

namespace GameServerScript.AI.Messions
{
    public class Labyrinth7001 : AMissionControl
    {
        private List<SimpleNpc> someNpc = new List<SimpleNpc>();

        private int dieRedCount = 0;

        private int npcIDs =  40001;

        private int[] birthX = { 52, 115, 183, 253, 320, 1206, 1275, 1342, 1410, 1475 };

        public override int CalculateScoreGrade(int score)
        {
            base.CalculateScoreGrade(score);
            if (score > 1870)
            {
                return 3;
            }
            else if (score > 1825)
            {
                return 2;
            }
            else if (score > 1780)
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
            int[] resources = { npcIDs };
            int[] gameOverResources = { npcIDs };
            Game.LoadResources(resources);
            Game.LoadNpcGameOverResources(gameOverResources);
            Game.SetMap(1224);
        }

        //public override void OnPrepareStartGame()
        //{
        //    base.OnPrepareStartGame();
        //}
        //public override void OnStartGame()
        //{
        //    base.OnStartGame();
        //}

        public override void OnStartGame()
        {

            base.OnStartGame();
            //左边五只小怪
            
            someNpc.Add(Game.CreateNpc(npcIDs, 52, 506, 1));
            someNpc.Add(Game.CreateNpc(npcIDs, 100, 507, 1));
            someNpc.Add(Game.CreateNpc(npcIDs, 155, 508, 1));
            someNpc.Add(Game.CreateNpc(npcIDs, 210, 507, 1));
            someNpc.Add(Game.CreateNpc(npcIDs, 253, 507, 1));
            someNpc.Add(Game.CreateNpc(npcIDs, 52, 506, 1));
            someNpc.Add(Game.CreateNpc(npcIDs, 100, 507, 1));
            someNpc.Add(Game.CreateNpc(npcIDs, 155, 508, 1));
            someNpc.Add(Game.CreateNpc(npcIDs, 210, 507, 1));
            someNpc.Add(Game.CreateNpc(npcIDs, 253, 507, 1));
            
        }

        public override void OnNewTurnStarted()
        {
            base.OnNewTurnStarted();

            if (Game.GetLivedLivings().Count == 0)
            {
                Game.PveGameDelay = 0;
            }

            if (Game.TurnIndex > 1 && Game.CurrentPlayer.Delay > Game.PveGameDelay)
            {
                if (Game.GetLivedLivings().Count < 10)
                {
                    for (int i = 0; i < 10 - Game.GetLivedLivings().Count; i++)
                    {
                        if (someNpc.Count == Game.MissionInfo.TotalCount)
                        {
                            break;
                        }
                        else
                        {
                            int index = Game.Random.Next(0, birthX.Length);
                            int NpcX = birthX[index];

                            ////int direction = -1;

                            //if (NpcX <= 320)
                            //{
                            //    direction = 1;
                            //}

                            //index = Game.Random.Next(0, npcIDs.Length);

                            //if (GetNpcCountByID(npcIDs) < 10)
                            //{
                                someNpc.Add(Game.CreateNpc(npcIDs, NpcX, 506, 1));
                            //}
                            
                        }
                    }
                }
            }

        }
        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();
        }

        public override bool CanGameOver()
        {
            bool result = true;

            base.CanGameOver();

            dieRedCount = 0;

            foreach (SimpleNpc redNpc in someNpc)
            {
                if (redNpc.IsLiving)
                {
                    result = false;
                }
                else
                {
                    dieRedCount++;
                }
            }

            if (result && dieRedCount == Game.MissionInfo.TotalCount)
            {
                Game.IsWin = true;
                return true;
            }

            return false;
        }

        public override int UpdateUIData()
        {
            return Game.TotalKillCount;
        }

        //public override void OnPrepareGameOver()
        //{
        //    base.OnPrepareGameOver();
        //}

        public override void OnGameOver()
        {
            base.OnGameOver();
            if (Game.GetLivedLivings().Count == 0)
            {
                Game.IsWin = true;
                List<LoadingFileInfo> loadingFileInfos = new List<LoadingFileInfo>();
                loadingFileInfos.Add(new LoadingFileInfo(2, "image/map/2/show", ""));
                Game.SendLoadResource(loadingFileInfos);
            }
            else
            {
                Game.IsWin = false;
            }

        }

        protected int GetNpcCountByID(int Id)
        {
            int Count = 0;
            foreach (SimpleNpc npc in someNpc)
            {
                if (npc.NpcInfo.ID == Id)
                    Count++;
            }
            return Count;
        }
    }
}
