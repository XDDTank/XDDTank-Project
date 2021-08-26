using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Bussiness;
using SqlDataProvider.Data;
using Game.Server.GameUtils;
using Bussiness.Managers;

namespace Game.Server.Packets.Client
{
    [PacketHandler((byte)ePackageType.FIGHT_SPIRIT, "场景用户离开")]
    public class FigSpiritUpGradeHandler : IPacketHandler
    {
        private static readonly string[] places = new string[] { "0", "1", "2" };
        //private static readonly string[] lvs = new string[] { "0", "1", "2", "3", "4", "5" };
        private static readonly int[] exps = new int[] { 0, 600, 5820, 21660, 60680, 150260 };

        public int getNeedExp(int _curExp, int _curLv)
        {
            int totalExp = exps[_curLv + 1];
            int needExp = totalExp - _curExp;

            return needExp;
        }
        public bool getMax(string[] SpiritIdValue)
        {
            int max = 0;
            if (SpiritIdValue[0].Split(',')[0] == "5")
                max = 1;
            if (SpiritIdValue[1].Split(',')[0] == "5")
                max = 2;
            if (SpiritIdValue[2].Split(',')[0] == "5")
                max = 3;
            return max == 3;
        }
        public int[] getOldLv(string[] curLvs)
        {
            int[] lvs = new int[curLvs.Length];
            for (int i = 0; i < curLvs.Length; i++)
            {
                lvs[i] =  Convert.ToInt32(curLvs[i].Split(',')[0]);
            }
            return lvs;
        }
        public int[] getOldExp(string[] curLvs)
        {
            int[] exps = new int[curLvs.Length];
            for (int i = 0; i < curLvs.Length; i++)
            {
                exps[i] = Convert.ToInt32(curLvs[i].Split(',')[1]);
            }
            return exps;
        }
       
        public bool canUpLv(int exp, int _curLv)
        {
            if (exp >= exps[1] && _curLv == 0)
                return true;
            if (exp >= exps[2] &&  _curLv == 1)
                return true;
            if (exp >= exps[3] && _curLv == 2)
                return true;
            if (exp >= exps[4]  && _curLv == 3)
                return true;
            if (exp >= exps[5] && _curLv == 4)
                return true;
            return false;
        }
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {

            packet.ReadByte();//_loc_2.writeByte(FightSpiritPackageType.FIGHT_SPIRIT_LEVELUP);
            int autoBuyId = packet.ReadInt();//_loc_2.writeInt(param1.autoBuyId);
            int goodsId = packet.ReadInt();//_loc_2.writeInt(param1.goodsId);
            int type = packet.ReadInt();//_loc_2.writeInt(param1.type);
            int templeteId = packet.ReadInt();//_loc_2.writeInt(param1.templeteId);
            int fightSpiritId = packet.ReadInt();//_loc_2.writeInt(param1.fightSpiritId);
            int equipPlace = packet.ReadInt();//_loc_2.writeInt(param1.equipPlayce);
            int place = packet.ReadInt();//_loc_2.writeInt(param1.place);
            int pointXY = packet.ReadInt();//_loc_2.writeInt(param1.pointXY);
            //Console.WriteLine("??????autoBuyId: " + autoBuyId);
            //Console.WriteLine("??????type: " + type);
            //Console.WriteLine("??????fightSpiritId: " + fightSpiritId);
            //Console.WriteLine("??????equipPlayce: " + equipPlace);
            //Console.WriteLine("??????place: " + place);
            //Console.WriteLine("??????pointXY: " + pointXY);

            ItemInfo item = client.Player.PropBag.GetItemByTemplateID(0, templeteId);
            int itemCount = client.Player.PropBag.GetItemCount(templeteId);
            UserGemStone gemStone = client.Player.GetGemStone(equipPlace);
            string[] SpiritIdValues = gemStone.FigSpiritIdValue.Split('|');
            int id = client.Player.PlayerCharacter.ID;
            bool isUp = false;
            bool isMaxLevel = getMax(SpiritIdValues);
            bool isFall = true;
            int num = 1;//exp
            int dir = 0;
            string FigSpiritIdValue = "";
            int[] curExp = getOldExp(SpiritIdValues); ;// Convert.ToInt32(gemStone.FigSpiritIdValue.Split('|')[0].Split(',')[1]);
            int[] curLv = getOldLv(SpiritIdValues); ;// Convert.ToInt32(gemStone.FigSpiritIdValue.Split('|')[0].Split(',')[0]);
            int[] oldLv = curLv;// getOldLv(gemStone.FigSpiritIdValue.Split('|'));

            if (!isMaxLevel && item != null)
            {
                if (autoBuyId == 0)
                {
                    int exp = item.Template.Property2;
                    for (int i = 0; i < places.Length; i++)
                    {
                        if (curLv[i] < 5)
                        {
                            curExp[i] += exp;
                            isUp = canUpLv(curExp[i], curLv[i]); ;
                            if (isUp)
                                curLv[i]++;// getLv(curExp[i], curLv[i]);                            
                            //break;
                        }

                    }

                    client.Player.PropBag.RemoveCountFromStack(item, 1);
                }
                if (autoBuyId == 1)
                {
                    int totalCount = 1;
                    for (int i = 0; i < places.Length; i++)
                    {
                        totalCount = getNeedExp(curExp[i], curLv[i]) / item.Template.Property2;
                        if (itemCount < totalCount)
                        {
                            totalCount = itemCount;
                        }
                        int exp = item.Template.Property2 * totalCount;
                        if (curLv[i] < 5)
                        {
                            curExp[i] += exp;
                            isUp = canUpLv(curExp[i], curLv[i]);
                            if (isUp)
                            {
                                curLv[i]++;// getLv(curExp[i], curLv[i]); 
                                curExp[i] = 0;
                            }
                            //break;
                        }

                    }
                    //client.Player.PropBag.RemoveCountFromStack(item, totalCount);
                    client.Player.PropBag.RemoveTemplate(templeteId, totalCount);
                    //Console.WriteLine("??????totalCount: " + totalCount);
                }
            }
            if (isUp)
            {
                isFall = false;
                dir = 1;
                client.Player.MainBag.UpdatePlayerProperties();
            }
            FigSpiritIdValue = curLv[0] + "," + curExp[0] + "," + places[0];
            for (int i = 1; i < places.Length; i++)
            {
                FigSpiritIdValue += "|" + curLv[i] + "," + curExp[i] + "," + places[i];
            }
            //isMaxLevel = getMax(FigSpiritIdValue.Split('|'));
            gemStone.FigSpiritId = fightSpiritId;
            gemStone.FigSpiritIdValue = FigSpiritIdValue;
            //Console.WriteLine("??????SpiritIdValue: " + FigSpiritIdValue);
            using (PlayerBussiness db = new PlayerBussiness())
            {
                db.UpdateGemStoneInfo(gemStone);
            }
            
            client.Player.Out.SendPlayerFigSpiritUp(id, gemStone, isUp, isMaxLevel, isFall, num, dir);
            return 0;
        }
    }
}
