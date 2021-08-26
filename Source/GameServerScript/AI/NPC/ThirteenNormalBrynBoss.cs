using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic;
using Game.Logic.Phy.Object;

namespace GameServerScript.AI.NPC
{
    public class ThirteenSimpleBrynBoss : ABrain
    {
        private int m_attackTurn = 0;

        private int m_turn = 0;

        private int IsEixt = 0;

        private int npcID = 3212;
      //  private Point[] brithPoint = { new Point(979, 630), new Point(1013, 630), new Point(1052, 630), new Point(1088, 630), new Point(1142, 630) };


        #region NPC 说话内容
        private static string[] AllAttackChat = new string[] { 
             "Trận động đất, bản thân mình! ! <br/> bạn vui lòng Ay giúp đỡ",
       
             "Hạ vũ khí xuống!",
       
             "Xem nếu bạn có thể đủ khả năng, một số ít!！"
        };

        private static string[] StandChat = new string[]{
             "Chi hua hua ! Chi hua hua",
                              
        };
        private static string[] CallChat = new string[]{
             "Chi hua hua ! Chi hua hua",
                              
        };
        private static string[] ShootChat = new string[]{
             "Chi hua hua ! Chi hua hua",
                              
        };

        private static string[] ShootedChat = new string[]{
           "Ah ~ ~ Tại sao bạn tấn công? <br/> tôi đang làm gì?",
                   
            "Oh ~ ~ nó thực sự đau khổ! Tại sao tôi phải chiến đấu? <br/> tôi phải chiến đấu ..."

        };

        private static string[] KillPlayerChat = new string[]{
             "Mathias không kiểm soát tôi!",       

             "Đây là thách thức số phận của tôi!",

             "Không! !Đây không phải là ý chí của tôi ..." 
        };

        private static string[] AddBooldChat = new string[]{
            "Xoắn ah xoay ~ <br/>xoắn ah xoay ~ ~ ~",
               
            "~ Hallelujah <br/>Luyaluya ~ ~ ~",
                
            "Yeah Yeah Yeah, <br/> để thoải mái!"
         
        };

        private static string[] KillAttackChat = new string[]{
            "Con rồng trong thế giới! !"
        };

        private static string[] FrostChat = new string[]{
            "Hương vị này",
               
            "Hãy để bạn bình tĩnh",
               
            "Bạn đã giận dữ với tôi."
              
        };

        private static string[] WallChat = new string[]{
             "Chúa, cho tôi sức mạnh!",

             "Tuyệt vọng, xem tường thủy tinh của tôi!"
         };

        #endregion
        
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
            bool result = false;
            int maxdis = 0;
            foreach (Player player in Game.GetAllFightPlayers())
            {
                if (player.IsLiving && player.X > 620 && player.X < 1160)
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
                AllAttack();
                m_attackTurn++;
            }
            else if (m_attackTurn == 1)
            {
                AllAttack1();
                m_attackTurn++;
            }
            else if (m_attackTurn == 2)
            {
                Stand();
                m_attackTurn++;
            }
            else if (m_attackTurn == 3)
            {
                PersonalAttack2();
                m_attackTurn++;
            }
            else
            {

                AllAttack3();
                m_attackTurn = 0;
            }
        }
     
        //private void CriticalStrikes()
        //{
        //    Player target = Game.GetFrostPlayerRadom();
        //    List<Player> players = Game.GetAllFightPlayers();
        //    List<Player> NotFrostPlayers = new List<Player>();
        //    foreach (Player player in players)
        //    {
        //        if (player.IsFrost == false)
        //        {
        //            NotFrostPlayers.Add(player);
        //        }
        //    }

        //    ((SimpleBoss)Body).CurrentDamagePlus = 30;
        //    if (NotFrostPlayers.Count != players.Count)
        //    {
        //        if (NotFrostPlayers.Count != 0)
        //        {
        //            Body.PlayMovie("beat1", 0, 0);
        //            Body.RangeAttacking(Body.X - 1000, Body.X + 1000, "beat1", 1500, NotFrostPlayers);
        //        }
        //        else
        //        {
        //            Body.PlayMovie("beat1", 0, 0);
        //            Body.RangeAttacking(Body.X - 1000, Body.X + 1000, "beat1", 1500, null);
        //        }
        //    }
        //    else
        //    {
        //        Body.Say("Nhỏ mà họ đã cho tôi một bài học tốt đối phương!", 1, 3300);
        //        Body.PlayMovie("renew", 3500, 0);
        //        Body.CallFuction(new LivingCallBack(CreateChild), 6000);
        //    }
        //}

        //private void FrostAttack()
        //{
        //    int mtX = Game.Random.Next(798, 980);
        //    Body.MoveTo(mtX, Body.Y, "walk", 0, new LivingCallBack(NextAttack));
        //}

        private void AllAttack()
        {
            Body.CurrentDamagePlus = 0.5f;
            int index = Game.Random.Next(0, AllAttackChat.Length);
            Body.Say(AllAttackChat[index], 1, 0);
            Body.PlayMovie("callA", 2400, 0);
            Body.RangeAttacking(Body.X - 2000, Body.X + 2000, "cry", 4000, null);
        }
        private void AllAttack3()
        {
            Body.CurrentDamagePlus = 0.5f;
            int index = Game.Random.Next(0, AllAttackChat.Length);
            Body.Say(AllAttackChat[index], 1, 0);
            Body.PlayMovie("beatC", 1400, 0);
            Body.RangeAttacking(Body.X - 2000, Body.X + 2000, "cry", 4000, null);
        }
        private void PersonalAttack2()
        {
            Player target = Game.FindRandomPlayer();


            if (target != null)
            {
                Body.CurrentDamagePlus = 0.8f;
                int index = Game.Random.Next(0, ShootChat.Length);
                Body.Say(ShootChat[index], 1, 0);
                int dis = Game.Random.Next(670, 880);


                int mtX = Game.Random.Next(target.X - 10, target.X + 10);

                if (Body.ShootPoint(target.X, target.Y, 55, 1000, 10000, 1, 1.5f, 2550))
                {
                    Body.PlayMovie("beatB", 1700, 0);
                }
				}
        }
        private void AllAttack1()
        {
          //  Body.CurrentDamagePlus = 0.5f;
           // int index = Game.Random.Next(0, AllAttackChat.Length);
           // Body.Say(AllAttackChat[index], 1, 0);
            Body.PlayMovie("callA", 2400, 0);
            Body.CallFuction(new LivingCallBack(CreateChild),2400);
        //    Body.RangeAttacking(Body.X - 2000, Body.X + 2000, "cry", 4000, null);
        }
        public void CreateChild()
        {
            Player target = Game.FindRandomPlayer();
            ((SimpleBoss)Body).CreateChild(npcID, target.X, target.Y, 1, 4);
        }
        private void Stand()
        {
            
            Body.PlayMovie("stand", 500, 0);
        }
   //     private void CreatChild()
     //   {
        //
         //   Body.PlayMovie("stand", 500, 0);
        //}
        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }
    }
}
