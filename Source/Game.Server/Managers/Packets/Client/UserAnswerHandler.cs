using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Game.Base.Packets;
using Game.Logic;
using SqlDataProvider.Data;
using Game.Server.Statics;

namespace Game.Server.Packets.Client
{
    [PacketHandler((int)ePackageType.USER_ANSWER, "New User Answer Question")]
    public class UserAnswerHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            //_loc_3.writeByte(1);
            //_loc_3.writeInt(param1);
            //_loc_3.writeBoolean(param2);
            byte type = packet.ReadByte();
            int id = packet.ReadInt();
            bool isKey = false;
            if (type == 1)
            {
                isKey = packet.ReadBoolean();
            }

            if (type == 1)
            {
                List<ItemInfo> infos = null;
                if (DropInventory.AnswerDrop(id, ref infos))
                {
                    int gold = 0;
                    int money = 0;
                    int giftToken = 0;
                    int medal = 0;
                    foreach (ItemInfo info in infos)
                    {
                        ItemInfo.FindSpecialItemInfo(info, ref gold, ref money, ref giftToken, ref medal);
                        if ((info != null) && (info.Template.BagType == eBageType.PropBag))
                        {
                            client.Player.MainBag.AddTemplate(info, info.Count);
                        }
                        client.Player.AddGold(gold);
                        client.Player.AddMoney(money);
                        client.Player.AddGiftToken(giftToken);
                        //client.Player.AddMedal(medal);
                        LogMgr.LogMoneyAdd(LogMoneyType.Award, LogMoneyType.Award_Answer, client.Player.PlayerCharacter.ID, giftToken, client.Player.PlayerCharacter.Money, money, 0, 0, 0, "", "", "");
                    }
                }
                if (isKey)
                {
                    client.Player.PlayerCharacter.openFunction((Step)id);
                }
                Console.WriteLine("????????????Type: " + type + " ID: " + id + " IsKey: " + isKey);
            }
            if (type == 2)
            {
                client.Player.PlayerCharacter.openFunction((Step)id);
                Console.WriteLine("???????????Type: " + type + " ID: " + id);

            }
            client.Player.UpdateAnswerSite(id);
            return 1;
        }
    }
}
