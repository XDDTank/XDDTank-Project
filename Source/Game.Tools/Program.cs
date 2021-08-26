using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Bussiness.Managers;
using Game.Logic;
using SqlDataProvider.Data;
using System.Diagnostics;
using Game.Server.Managers;
using Bussiness;
using Game.Server.GameObjects;
namespace Game.Tools
{
    class Program
    {
         public static string m_pvepermissions;
        static void Main(string[] args)
        {
            //GC.Collect();
            //DropMgr.Init();
            //System.Diagnostics.Stopwatch stopwatch = new Stopwatch();
            //stopwatch.Start(); //  开始监视代码运行时间            
            //List<ItemInfo> tempItem=null;
            //for (int i = 0; i < 100000; i++)
            //{
            //    DropInventory.PvEQuestsDrop(1, ref tempItem);                
            //    DropInventory.NPCDrop(3, ref tempItem);                
            //    DropInventory.CopyDrop(1071,1, ref tempItem);                
            //}
            //stopwatch.Stop(); //  停止监视
            //TimeSpan timespan = stopwatch.Elapsed; //  获取当前实例测量得出的总时间          
            //double seconds = timespan.TotalSeconds;  //  总秒数
            //double milliseconds = timespan.TotalMilliseconds;  //  总毫秒数 
            /*/Console.WriteLine("完毕" + seconds.ToString()+"秒");
            m_pvepermissions = "11222";
            Console.WriteLine("11 : level {0} source {1}result={2}", eHardLevel.Simple, m_pvepermissions, SetPvePermission(1, eHardLevel.Simple));
            Console.WriteLine("11 : level {0} source {1}result={2}", eHardLevel.Normal, m_pvepermissions, SetPvePermission(1, eHardLevel.Normal));
            Console.WriteLine("11 : level {0} source {1}result={2}", eHardLevel.Hard, m_pvepermissions, SetPvePermission(1, eHardLevel.Hard));
            Console.WriteLine();
            m_pvepermissions = "3F222";
            Console.WriteLine("11 : level {0} source {1}result={2}", eHardLevel.Simple, m_pvepermissions, SetPvePermission(1, eHardLevel.Simple));
            Console.WriteLine("11 : level {0} source {1}result={2}", eHardLevel.Normal, m_pvepermissions, SetPvePermission(1, eHardLevel.Normal));
            Console.WriteLine("11 : level {0} source {1}result={2}", eHardLevel.Hard, m_pvepermissions, SetPvePermission(1, eHardLevel.Hard));
            Console.WriteLine();
            m_pvepermissions = "7F222";
            Console.WriteLine("11 : level {0} source {1}result={2}", eHardLevel.Simple, m_pvepermissions, SetPvePermission(1, eHardLevel.Simple));
            Console.WriteLine("11 : level {0} source {1}result={2}", eHardLevel.Normal, m_pvepermissions, SetPvePermission(1, eHardLevel.Normal));
            Console.WriteLine("11 : level {0} source {1}result={2}", eHardLevel.Hard, m_pvepermissions, SetPvePermission(1, eHardLevel.Hard));

            //m_pvepermissions = "11122";
            //Console.WriteLine("11 : level {0} source {1}result={2}", eHardLevel.Simple, m_pvepermissions, SetPvePermission(2, eHardLevel.Simple));
            //Console.WriteLine("11 : level {0} source {1}result={2}", eHardLevel.Normal, m_pvepermissions, SetPvePermission(2, eHardLevel.Normal));
            //Console.WriteLine("11 : level {0} source {1}result={2}", eHardLevel.Hard, m_pvepermissions, SetPvePermission(1, eHardLevel.Hard));
            //Console.WriteLine();
            //m_pvepermissions = "33322";
            //Console.WriteLine("11 : level {0} source {1}result={2}", eHardLevel.Simple, m_pvepermissions, SetPvePermission(2, eHardLevel.Simple));
            //Console.WriteLine("11 : level {0} source {1}result={2}", eHardLevel.Normal, m_pvepermissions, SetPvePermission(2, eHardLevel.Normal));
            //Console.WriteLine("11 : level {0} source {1}result={2}", eHardLevel.Hard, m_pvepermissions, SetPvePermission(2, eHardLevel.Hard));
            //Console.WriteLine();
            //m_pvepermissions = "7F722";
            //Console.WriteLine("11 : level {0} source {1}result={2}", eHardLevel.Simple, m_pvepermissions, SetPvePermission(2, eHardLevel.Simple));
            //Console.WriteLine("11 : level {0} source {1}result={2}", eHardLevel.Normal, m_pvepermissions, SetPvePermission(2, eHardLevel.Normal));
            /Console.WriteLine("11 : level {0} source {1}result={2}", eHardLevel.Hard, m_pvepermissions, SetPvePermission(2, eHardLevel.Hard));
            */
            m_pvepermissions = "11111";
            Console.WriteLine("11 : level {0} source {1}result={2}", eHardLevel.Simple, m_pvepermissions, SetPvePermission(5, eHardLevel.Simple));
            Console.WriteLine("11 : level {0} source {1}result={2}", eHardLevel.Normal, m_pvepermissions, SetPvePermission(5, eHardLevel.Normal));
            Console.WriteLine("11 : level {0} source {1}result={2}", eHardLevel.Hard, m_pvepermissions, SetPvePermission(5, eHardLevel.Hard));
            Console.WriteLine("11 : level {0} source {1}result={2}", eHardLevel.Terror, m_pvepermissions, SetPvePermission(5, eHardLevel.Terror));
            Console.WriteLine();
            m_pvepermissions = "33323";
            Console.WriteLine("11 : level {0} source {1}result={2}", eHardLevel.Simple, m_pvepermissions, SetPvePermission(5, eHardLevel.Simple));
            Console.WriteLine("11 : level {0} source {1}result={2}", eHardLevel.Normal, m_pvepermissions, SetPvePermission(5, eHardLevel.Normal));
            Console.WriteLine("11 : level {0} source {1}result={2}", eHardLevel.Hard, m_pvepermissions, SetPvePermission(5, eHardLevel.Hard));
            Console.WriteLine("11 : level {0} source {1}result={2}", eHardLevel.Terror, m_pvepermissions, SetPvePermission(5, eHardLevel.Terror));
            Console.WriteLine();
            m_pvepermissions = "7F72F";
            Console.WriteLine("11 : level {0} source {1}result={2}", eHardLevel.Simple, m_pvepermissions, SetPvePermission(5, eHardLevel.Simple));
            Console.WriteLine("11 : level {0} source {1}result={2}", eHardLevel.Normal, m_pvepermissions, SetPvePermission(5, eHardLevel.Normal));
            Console.WriteLine("11 : level {0} source {1}result={2}", eHardLevel.Hard, m_pvepermissions, SetPvePermission(5, eHardLevel.Hard));
            Console.WriteLine("11 : level {0} source {1}result={2}", eHardLevel.Terror, m_pvepermissions, SetPvePermission(5, eHardLevel.Terror));
            //Console.WriteLine("Count: " + PetMgr.GetPetTemplateByStar(5).Count);
            //Console.WriteLine("Count: " + PetMgr.GetPetSkillByKindID(4, 1));
            //Console.WriteLine("PetTemplate: " + PetMgr.FindPetTemplate(100701).Name);
            //string str = PetMgr.GetPetSkillTemplate(10).SkillID.ToString() == null ? "null" : "not null";
            List<int> infos = PetMgr.GetPetSkillByKindID(2, 65);// PetMgr.GetPetTemplateByStar(5);
            string str = infos.Count.ToString();
            int test = PetMgr.UpdateEvolution(120602, 35);
            //using (PlayerBussiness db = new PlayerBussiness())
            //{
                
            //}
            //120602
            List<CardGrooveUpdateInfo> gro = CardMgr.FindCardGrooveUpdate(0);
            List<CardTemplateInfo> card = CardMgr.FindCardBox(314106);
            Console.WriteLine("TestPetMgr: " + str);
            for (int index = 0; index < infos.Count; index++)
            {
                Console.WriteLine("Template: " + infos[index]);
            }
            DateTime _now = DateTime.Now;
            int _hour = _now.Hour;
            int _min = _now.Minute;
            int validH = 24 - _hour;
            int validM = 60 - _min;
            DateTime PlantTime = Convert.ToDateTime("2013-02-06 03:55:50");
            int FieldValidDate = 480;
            int tiem = AccelerateTimeFields(PlantTime, FieldValidDate);
            Console.WriteLine("Hour: " + validH + " Min:" + validM);
            Console.WriteLine(LevelMgr.GetMaxLevel());
            using (PlayerBussiness db = new PlayerBussiness())
            {
                
            }
            int orgXu = 50;
            int orgVang = 8;
            int totalXu = 0;
            int totalvang = 0;
            int xu = 0;
            int vang = 0;
            for (int index = 0; index < 47; index++)
            {
                totalXu += orgXu + index;
                xu = orgXu + index;
                totalvang += orgVang + index;
                vang = orgVang + index;
            }
            //Console.WriteLine("Xu can: " + xu);
            //Console.WriteLine("Tong xu co duoc: " + totalXu);
            //Console.WriteLine("vang can: " + vang);
            //Console.WriteLine("Tong vang can: " + totalvang);
            //Console.WriteLine("Tong lv: " + CardMgr.GetLevel(44444, 0));
            //List<CardTemplateInfo> lists = CardMgr.GetAllCard();
            //List<PetSkillElementInfo> lists = PetMgr.GameNeedPetSkill();
            //for (int i = 0; i < lists.Count; i++)
            //{
            //    Console.WriteLine("ID: " + lists[i].ID + "  CardID: " + lists[i].EffectPic);
            //}
            CardTemplateInfo crd = CardMgr.GetCard(314148);
            Console.WriteLine("ID: " + crd.ID + "  probability: " + crd.probability);
            Console.Read();
            

             
        }
        public static int FindEmptyPetPlace(int maxlost)
        {
            int place = -1;
                for (int i = 0; i < maxlost; i++)
                {
                    //if (m_pets[i] == null)
                    //{
                        place = i;
                    //}
                }
            
            return place;
        }
        public static int AccelerateTimeFields(DateTime PlantTime, int FieldValidDate)
        {
            DateTime _now = DateTime.Now;
            int validH = _now.Hour - PlantTime.Hour;
            int validM = _now.Minute - PlantTime.Minute;
            int AccelerateTime = 0;
            
            if (validH < 0)
            {
                validH = 24 + validH;
            }
            if (validM < 0)
            {                
                validM = 60 + validM;
            }
            AccelerateTime = (validH * 60) + validM;
            if (AccelerateTime >= FieldValidDate)
            {
                AccelerateTime = FieldValidDate;
            }

            return AccelerateTime;
        }
        public static List<int> GetPetID()
        {
            List<int> petID = new List<int>();
            int _temppetID = 0; int _tempID = 0;
            
            int MaxPetCount = Convert.ToInt32(PetMgr.FindConfig("MaxPetCount").Value);
            for (int i = 0; i < MaxPetCount; i++)
            {
                string _userid = Convert.ToString(3);
                _tempID = FindEmptyPetPlace(MaxPetCount);
                _userid += _tempID;
                _temppetID = int.Parse(_userid);
                petID.Add(_temppetID);
            }
            return petID;
        }
        public static string SetPvePermission(int missionId, eHardLevel hardLevel)
        {
          
            if (hardLevel == eHardLevel.Terror)
                return "FF";
            var setPvePermision = string.Empty;
            string right = m_pvepermissions.Substring(missionId - 1, 1);
            if (hardLevel == eHardLevel.Simple && right == "1")
            {

                setPvePermision = "3";
            }
            else if (hardLevel == eHardLevel.Normal && right == "3")
            {

                setPvePermision = "7";
            }
            else if (hardLevel == eHardLevel.Hard && right == "7")
            {
                setPvePermision = "F";
            }
            else
            {
                return m_pvepermissions;
            }
            var strPvePermision = m_pvepermissions;
            var length = strPvePermision.Length;
            strPvePermision = strPvePermision.Substring(0, missionId - 1) + setPvePermision + strPvePermision.Substring(missionId , length - missionId);
            return strPvePermision;
            //return true;
        }
 

    }
}
