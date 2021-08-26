using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Bussiness;
using Game.Base.Packets;
using SqlDataProvider.Data;
using Game.Server.Statics;

namespace Game.Server.Packets.Client
{
    [PacketHandler((int)ePackageType.ITEM_CONTINUE, "续费")]
    public class UserItemContineueHandler : IPacketHandler
    {

        //修改:  Xiaov 
        //时间:  2009-11-7
        //描述:  续费<已测试>           
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
           
            if (client.Player.PlayerCharacter.HasBagPassword && client.Player.PlayerCharacter.IsLocked)
            {
                client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("Bag.Locked"));
                return 0;
            }
            StringBuilder payGoods = new StringBuilder();                    //表示支付物品ID
            int count = packet.ReadInt();
            string msg = "UserItemContineueHandler.Success";

            for (int i = 0; i < count; i++)            
            {
                eBageType bag = (eBageType)packet.ReadByte();
                int place = packet.ReadInt();
                int Goods = packet.ReadInt();
                int type = packet.ReadByte();
                bool isDress = packet.ReadBoolean();

                if ((bag == eBageType.MainBag && place >= 31) || bag == eBageType.PropBag || bag == eBageType.Consortia)
                {
                    ItemInfo item = client.Player.GetItemAt(bag, place);
                    //if (item != null && item.ValidDate != 0 && !item.IsValidItem() && 
                    //   (bag == eBageType.MainBag || (bag == eBageType.PropBag && item.TemplateID == 10200)))
                    //{
                        int gold = 0;            //表示金币
                        int money = 0;           //表示点券
                        int offer = 0;           //表示功勋
                        int gifttoken = 0;       //表示礼劵
                        int medal = 0;
                        int oldDate = item.ValidDate;
                        DateTime oldBegindate = item.BeginDate;
                        int oldCount = item.Count;
                        bool isValid = item.IsValidItem();

                         ShopItemInfo shopitem = Bussiness.Managers.ShopMgr.GetShopItemInfoById(Goods);                             //获取商品信息
                         ItemInfo.SetItemType(shopitem, type, ref gold, ref money, ref offer,ref gifttoken, ref medal);        //获取物品价格及兑换物TemplatID, Count

                        
                       
                        if (gold <= client.Player.PlayerCharacter.Gold && 
                            money <= client.Player.PlayerCharacter.Money && 
                            offer <= client.Player.PlayerCharacter.Offer &&
                            gifttoken <= client.Player.PlayerCharacter.GiftToken)
                        {
                            client.Player.RemoveMoney(money);
                            client.Player.RemoveGold(gold);
                            client.Player.RemoveOffer(offer);
                            client.Player.RemoveGiftToken(gifttoken);
                            
                            
                                if (1 == type)
                                {
                                    item.ValidDate += shopitem.AUnit;
                                }
                                if (2 == type)
                                {
                                    item.ValidDate += shopitem.BUnit;
                                }
                                if (3 == type)
                                {
                                    item.ValidDate += shopitem.CUnit;
                                }
                                if (!isValid && item.ValidDate != 0)
                                {
                                    item.BeginDate = DateTime.Now;
                                    item.IsUsed = false;
                                }
                            

                            
                            LogMgr.LogMoneyAdd(LogMoneyType.Shop, LogMoneyType.Shop_Continue, client.Player.PlayerCharacter.ID, money, client.Player.PlayerCharacter.Money, gold, 0, 0,0, "牌子编号", item.TemplateID.ToString(), type.ToString());
                        }
                        else
                        {
                            item.ValidDate = oldDate;
                            item.Count = oldCount;
                            msg = "UserItemContineueHandler.NoMoney";
                            
                        }
                    //}
                    ///////////////////
                    if (bag == eBageType.MainBag)
                    {
                        if (isDress)
                        {
                            int solt = client.Player.MainBag.FindItemEpuipSlot(item.Template);
                            client.Player.MainBag.MoveItem(place, solt, item.Count);
                        }
                        else
                        {
                            client.Player.MainBag.UpdateItem(item);
                        }
                    }
                    else if (bag == eBageType.PropBag)
                    {
                        client.Player.PropBag.UpdateItem(item);
                    }
                    else
                    {
                        client.Player.ConsortiaBag.UpdateItem(item);
                    }

                }
                
            }

            client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation(msg));

            return 0;
        }
    }
}
