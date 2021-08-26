using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Text;
using Game.Base.Packets;
using Bussiness;
using SqlDataProvider.Data;
using Game.Server.Managers;
using Bussiness.Managers;
//using Game.Server.Statics;

namespace Game.Server.Packets.Client
{
    [PacketHandler((int)ePackageType.CARDS_DATA, "防沉迷系统开关")]
    class CardDataHander : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {            
            int cmdCard = packet.ReadInt();
            //Console.WriteLine("====>cmdCard: " + cmdCard);
            PlayerInfo info = client.Player.PlayerCharacter;
            ItemInfo item ;
            int count = 0;
            var cardBag = client.Player.CardBag;
            ThreadSafeRandom random = new ThreadSafeRandom();
            //cardBag.BeginChanges();
            string msg = "";
            switch (cmdCard)
            {
                case 0:
                    {
                        //sendMoveCards/ sendUpdateSLOT
                        int PlaceCard = packet.ReadInt();
                        int PlaceSlot = packet.ReadInt();
                        int temId = cardBag.GetItemAt(PlaceCard).TemplateID;
                        if (cardBag.FindEquipCard(temId) && PlaceCard != PlaceSlot)
                        {
                            msg = "Thẻ này đã trang bị!";
                        }
                        else
                        {
                            if (PlaceCard != PlaceSlot)
                            {
                                msg = "Trang bị thành công!";
                            }
                            cardBag.MoveItem(PlaceCard, PlaceSlot);
                            client.Player.MainBag.UpdatePlayerProperties();
                        }
                        if (msg != "")
                        {
                            client.Out.SendMessage(eMessageType.Normal, msg);
                        }
                    }
                    break;
                case 1:
                    {
                        //sendOpenViceCard/ sendOpenCardBox
                        int placeCard = packet.ReadInt();
                        count = packet.ReadInt();
                        item = client.Player.MainBag.GetItemAt(placeCard);
                        int templateId = item.Template.Property5;
                        int place = client.Player.CardBag.FindFirstEmptySlot(5);
                        UsersCardInfo card = new UsersCardInfo();
                        CardTemplateInfo cardInfo =  CardMgr.GetCard(item.Template.Property5);
                        bool getPoint = false;
                        if (cardInfo != null)
                        {
                            if (client.Player.CardBag.FindPlaceByTamplateId(5, templateId) == -1)
                            {
                                card.CardType = cardInfo.CardType;
                                card.UserID = client.Player.PlayerCharacter.ID;
                                card.Place = place;
                                card.TemplateID = cardInfo.CardID;
                                card.isFirstGet = true;
                                card.Attack = 0;
                                card.Agility = 0;
                                card.Defence = 0;
                                card.Luck = 0;
                                card.Damage = 0;
                                card.Guard = 0;
                                client.Player.CardBag.AddCardTo(card, place);
                                client.Out.SendGetCard(client.Player.PlayerCharacter, card);
                            }
                            else { getPoint = true; }
                        }
                        else { getPoint = true; }

                        if (getPoint)
                        {
                            int point = random.Next(5, 50);
                            client.Player.AddCardSoul(point);
                            client.Player.Out.SendPlayerCardSoul(client.Player.PlayerCharacter, true, point);
                        }

                        client.Player.MainBag.RemoveCountFromStack(item, count);
                    }
                    break;

                case 4:
                    {
                        //OpenRandomBox
                        int placeBox = packet.ReadInt();
                        count = packet.ReadInt();
                        item = client.Player.PropBag.GetItemAt(placeBox);
                        int id = random.Next(CardMgr.CardCount());
                        CardTemplateInfo tempcard = CardMgr.GetSingleCard(id);
                        bool getPoint = false;
                        if (tempcard == null)
                        {
                            getPoint = true;
                        }
                        else
                        {
                            int place = client.Player.CardBag.FindFirstEmptySlot(5);
                            int templateId = tempcard.CardID;
                            
                            CardTemplateInfo cardInfo = CardMgr.GetCard(templateId);
                            UsersCardInfo card = new UsersCardInfo();
                            if (cardInfo == null)
                            {
                                getPoint = true;
                            }
                            else
                            {
                                if (client.Player.CardBag.FindPlaceByTamplateId(5, templateId) == -1)
                                {
                                    card.CardType = cardInfo.CardType;
                                    card.UserID = client.Player.PlayerCharacter.ID;
                                    card.Place = place;
                                    card.TemplateID = cardInfo.CardID;
                                    card.isFirstGet = true;
                                    card.Attack = 0;
                                    card.Agility = 0;
                                    card.Defence = 0;
                                    card.Luck = 0;
                                    card.Damage = 0;
                                    card.Guard = 0;
                                    client.Player.CardBag.AddCardTo(card, place);
                                    client.Out.SendGetCard(client.Player.PlayerCharacter, card);
                                }
                                else { getPoint = true; }
                            }
                        }
                        if (getPoint)
                        {
                            int point = random.Next(5, 50);
                            client.Player.AddCardSoul(point);
                            client.Player.Out.SendPlayerCardSoul(client.Player.PlayerCharacter, true, point);
                        }
                        client.Player.PropBag.RemoveCountFromStack(item, count);
                    }
                    break;                
                
            }
            //cardBag.CommitChanges();
            //cardBag.SaveToDatabase();
            return 0;
        }
    }
}
