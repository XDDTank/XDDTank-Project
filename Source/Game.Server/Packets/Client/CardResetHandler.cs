using System;
using System.Collections.Generic;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Bussiness;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
    [PacketHandler((byte)ePackageType.CARD_RESET, "场景用户离开")]
    public class CardResetHandler : IPacketHandler
    {
        
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            int cmd = packet.ReadInt();//_loc_2.writeInt(0);CardReset            
                                        //_loc_2.writeInt(1);ReplaceCardProp
            int place = packet.ReadInt();// _loc_2.writeInt(param1); Place
            //Console.WriteLine("--place:" + place + "type: " + type);
            UsersCardInfo Card = client.Player.CardBag.GetItemByPlace(0, place);
            List<int> points = new List<int>();
            ThreadSafeRandom random = new ThreadSafeRandom();
            string msg = "Tẩy điểm thành công!"; //LanguageMgr.GetTranslation("UpdateSLOT.Fail");
            int min = 1; int max = 10;
            if (Card.CardType == 2)
            {
                min = 10; max = 20;
            }
            if (Card.CardType == 1)
            {
                min = 15; max = 40;
            }

            switch (cmd)
            {
                case 0: //reset   
                    
                    int point = 0;
                    for (int i = 0; i < 4; i++)
                    {
                        point = random.Next(min, max);
                        points.Add(point);
                        switch (i)
                        {
                            case 0: //att
                                Card.Attack = point;
                                break;
                            case 1: //def
                                Card.Defence = point;
                                break;
                            case 2: //agi
                                Card.Agility = point;
                                break;
                            case 3: //luk
                                Card.Luck = point;
                                break;
                        }
                    }
                    client.Player.CardBag.UpdateTempCard(Card);
                    client.Player.RemoveCardSoul(50);
                    client.Player.Out.SendPlayerCardReset(client.Player.PlayerCharacter, points);
                    //client.Out.SendMessage(eMessageType.Normal, msg);
                    break;
                case 1://update card Prop
                    {
                        msg = "Cập nhật thay đổi thành công!";
                        client.Player.CardBag.UpdateCard();
                        //client.Out.SendMessage(eMessageType.Normal, msg);
                        if (place < 5)
                        {
                            client.Player.MainBag.UpdatePlayerProperties();
                        }
                    }
                    break;
            }
            client.Out.SendMessage(eMessageType.Normal, msg);
            return 0;
        }
    }
}
