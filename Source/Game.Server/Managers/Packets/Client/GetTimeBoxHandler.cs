using System;
using System.Collections.Generic;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Bussiness;
using Bussiness.Managers;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
    [PacketHandler((byte)ePackageType.GET_TIME_BOX, "场景用户离开")]
    public class GetTimeBoxHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            int type = packet.ReadInt();
            int boxId = packet.ReadInt();
            int fightLibType = packet.ReadInt();
            int fightLibLevel = packet.ReadInt();
            bool result = false;
            List<ItemInfo> infos = new List<ItemInfo>();
            int ID = client.Player.PlayerCharacter.ID;
            int receiebox = client.Player.PlayerCharacter.receiebox;
            string msg = "Nhận rương thời gian thành công!";
            switch (type)
            {
                case 0://boxCondition
                    {    
                        client.Player.UpdateTimeBox(boxId, 20, 0);
                        client.Out.SendGetBoxTime(ID, receiebox, result);
                    }
                    break;
                case 1://boxtype
                    {
                        result = true;
                        infos = ItemBoxMgr.GetItemBoxAward(ItemMgr.FindItemBoxTemplate(receiebox).TemplateID);
                        foreach (ItemInfo info in infos)
                        {
                            if (!client.Player.AddTemplate(info, info.Template.BagType, info.Count))
                            {
                                using (PlayerBussiness db = new PlayerBussiness())
                                {
                                    info.UserID = 0;
                                    db.AddGoods(info);
                                    MailInfo message = new MailInfo();
                                    message.Annex1 = info.ItemID.ToString();
                                    message.Content ="Phần thưởng từ rương thời gian.";
                                    message.Gold = 0;
                                    message.Money = 0;
                                    message.Receiver = client.Player.PlayerCharacter.NickName;
                                    message.ReceiverID = client.Player.PlayerCharacter.ID;
                                    message.Sender = message.Receiver;
                                    message.SenderID = message.ReceiverID;
                                    message.Title = "Mở rương thời gian!";
                                    message.Type = (int)eMailType.OpenUpArk;
                                    db.SendMail(message);
                                    msg = "Túi đã đầy, vật phẩm đã được chuyển vào thư!";
                                }
                                client.Out.SendMailResponse(client.Player.PlayerCharacter.ID, eMailRespose.Receiver);
                            }
                        }
                        client.Out.SendGetBoxTime(ID, receiebox, result);
                        client.Out.SendMessage(eMessageType.Normal, msg);
                    }
                    break;
                case 2://fightLib
                    {
                    }
                    break;
            }
            
            return 0;
        }
    }
}
