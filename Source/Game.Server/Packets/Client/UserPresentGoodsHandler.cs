using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Game.Base.Packets;
using SqlDataProvider.Data;
using Bussiness;
using Bussiness.Managers;
using Game.Server.Managers;
using Game.Server.GameUtils;
using Game.Server.GameObjects;
using Game.Server.Statics;

namespace Game.Server.Packets.Client
{
    [PacketHandler((byte)ePackageType.GOODS_PRESENT, "购买物品")]
    public class UserPresentGoodsHandler : IPacketHandler
    {

        //public static int countConnect = 0;
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            //if (countConnect >= 3000) { client.Disconnect(); return 0; }


            int gold = 0;            //表示金币
            int money = 0;           //表示点券
            int offer = 0;           //表示功勋
            int gifttoken = 0;       //表示礼劵
            int medal = 0;
            StringBuilder payGoods = new StringBuilder();                    //表示支付物品ID
            eMessageType eMsg = eMessageType.Normal;
            string msg = "UserPresentGoodsHandler.Success";
            string filterWrod = packet.ReadString();//_loc_8.writeUTF(param5);filterWrod
            string nickName = packet.ReadString();//_loc_8.writeUTF(param6);NickName
            int count = packet.ReadInt();//_loc_8.writeInt(_loc_9); count
            
            List<ItemInfo> buyitems = new List<ItemInfo>();                 //购买物品列表            
            StringBuilder types = new StringBuilder();
            PlayerInfo info;
            GamePlayer player = Managers.WorldMgr.GetClientByPlayerNickName(nickName);
            if (player == null)                              //时间购买类型
            {
                using (PlayerBussiness db = new PlayerBussiness())
                {
                    info = db.GetUserSingleByNickName(nickName);
                }
            }
            else
            {
                info = player.PlayerCharacter;
            }
            bool isBind = false;
            
            for (int i = 0; i < count; i++)
            {
                int GoodsID = packet.ReadInt();//_loc_8.writeInt(param1[_loc_10]);GoodsID
                int type = packet.ReadInt();//_loc_8.writeInt(param2[_loc_10]);BuyType
                string color = packet.ReadString();//_loc_8.writeUTF(param3[_loc_10]);Color
                string skin = packet.ReadString();//_loc_8.writeUTF(param7[_loc_10]);Skin
                int isDiscount = packet.ReadInt();//_loc_8.writeInt(param4[_loc_10]);isDiscount

                //这里开始处理公会商店
                ShopItemInfo shopItem = ShopMgr.GetShopItemInfoById(GoodsID);                   //获取商品信息
                

                ItemTemplateInfo goods = ItemMgr.FindItemTemplate(shopItem.TemplateID);              //获取物品属性

                ItemInfo item = ItemInfo.CreateFromTemplate(goods, 1, (int)ItemAddType.Buy);                            //创建物品模板

                ////////////////////////////////////////////////////////////////////////////////////////////////////
                //判断有限期
                if (0 == shopItem.BuyType)                              //时间购买类型
                {
                    if (1 == type)
                    {
                        item.ValidDate = shopItem.AUnit;
                    }
                    if (2 == type)
                    {
                        item.ValidDate = shopItem.BUnit;
                    }
                    if (3 == type)
                    {
                        item.ValidDate = shopItem.CUnit;
                    }
                }
                else                                                  //数量购买类型
                {
                    if (1 == type)
                    {
                        item.Count = shopItem.AUnit;
                    }
                    if (2 == type)
                    {
                        item.Count = shopItem.BUnit;
                    }
                    if (3 == type)
                    {
                        item.Count = shopItem.CUnit;
                    }
                }
                ////////////////////////////////////////////////////////////////////////////////////////////////////////

                if (item == null && shopItem == null)
                    continue;
                item.Color = color == null ? "" : color;
                item.Skin = skin == null ? "" : skin;
                if (isBind == true)
                {
                    item.IsBinds = true;
                }
                else
                {
                    item.IsBinds = Convert.ToBoolean(shopItem.IsBind);
                }

                types.Append(type);
                types.Append(",");
                buyitems.Add(item);
                
                ItemInfo.SetItemType(shopItem, type, ref gold, ref money, ref offer, ref gifttoken, ref medal);
               
            }

            if (buyitems.Count == 0)
                return 1;
            if (client.Player.PlayerCharacter.HasBagPassword && client.Player.PlayerCharacter.IsLocked)
            {
                client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("Bag.Locked"));
                return 1;
            }



            

            //判断金币或礼券等是否足够
            if (gold <= client.Player.PlayerCharacter.Gold && 
                money <= client.Player.PlayerCharacter.Money &&
                gifttoken <= client.Player.PlayerCharacter.GiftToken)
                // && medal <= client.Player.PlayerCharacter.medal)
            {
                client.Player.RemoveMoney(money);
                client.Player.RemoveGold(gold);
                //client.Player.RemoveOffer(offer);
                client.Player.RemoveGiftToken(gifttoken);
                //client.Player.RemoveMedal(medal);

                string itemIDs = "";
                int annexIndex = 0;
                MailInfo message = new MailInfo();
                StringBuilder annexRemark = new StringBuilder();
                annexRemark.Append(LanguageMgr.GetTranslation("GoodsPresentHandler.AnnexRemark"));

                for (int i = 0; i < buyitems.Count; i++)
                {
                    itemIDs += (itemIDs == "" ? buyitems[i].TemplateID.ToString() : "," + buyitems[i].TemplateID.ToString());
                    
                        using (PlayerBussiness db = new PlayerBussiness())
                        {
                            buyitems[i].UserID = 0;
                            db.AddGoods(buyitems[i]);

                            annexIndex++;
                            annexRemark.Append(annexIndex);
                            annexRemark.Append("、");
                            annexRemark.Append(buyitems[i].Template.Name);
                            annexRemark.Append("x");
                            annexRemark.Append(buyitems[i].Count);
                            annexRemark.Append(";");
                            switch (annexIndex)
                            {
                                case 1:
                                    message.Annex1 = buyitems[i].ItemID.ToString();
                                    message.Annex1Name = buyitems[i].Template.Name;
                                    break;
                                case 2:
                                    message.Annex2 = buyitems[i].ItemID.ToString();
                                    message.Annex2Name = buyitems[i].Template.Name;
                                    break;
                                case 3:
                                    message.Annex3 = buyitems[i].ItemID.ToString();
                                    message.Annex3Name = buyitems[i].Template.Name;
                                    break;
                                case 4:
                                    message.Annex4 = buyitems[i].ItemID.ToString();
                                    message.Annex4Name = buyitems[i].Template.Name;
                                    break;
                                case 5:
                                    message.Annex5 = buyitems[i].ItemID.ToString();
                                    message.Annex5Name = buyitems[i].Template.Name;
                                    break;
                            }

                            if (annexIndex == 5)
                            {
                                annexIndex = 0;
                                message.AnnexRemark = annexRemark.ToString();
                                annexRemark.Remove(0, annexRemark.Length);
                                annexRemark.Append(LanguageMgr.GetTranslation("GoodsPresentHandler.AnnexRemark"));

                                message.Content = LanguageMgr.GetTranslation("UserBuyItemHandler.Title") + message.Annex1Name + "] " + filterWrod;
                                message.Gold = 0;
                                message.Money = 0;
                                message.Receiver = info.NickName;
                                message.ReceiverID = info.ID;
                                message.Sender = client.Player.PlayerCharacter.NickName;
                                message.SenderID = client.Player.PlayerCharacter.ID;
                                message.Title = message.Content;
                                message.Type = (int)eMailType.BuyItem;
                                db.SendMail(message);

                                eMsg = eMessageType.ERROR;
                                //msg = "UserBuyItemHandler.Mail";

                                message.Revert();
                            }
                        }
                    }
                

                if (annexIndex > 0)
                {                    
                    using (PlayerBussiness db = new PlayerBussiness())
                    {
                        message.AnnexRemark = annexRemark.ToString();
                        message.Content = LanguageMgr.GetTranslation("UserBuyItemHandler.Title") + message.Annex1Name + "] " + filterWrod;
                        message.Gold = 0;
                        message.Money = 0;
                        message.Receiver = info.NickName;
                        message.ReceiverID = info.ID;
                        message.Sender = client.Player.PlayerCharacter.NickName;
                        message.SenderID = client.Player.PlayerCharacter.ID;
                        message.Title = message.Content;
                        message.Type = (int)eMailType.BuyItem;
                        db.SendMail(message);

                        eMsg = eMessageType.ERROR;
                        //msg = "UserBuyItemHandler.Mail";
                    }
                }

                if (eMsg == eMessageType.ERROR && player != null)
                {
                    player.Out.SendMailResponse(client.Player.PlayerCharacter.ID, eMailRespose.Receiver);
                }

                client.Player.OnPaid(money, gold, offer, gifttoken, medal, payGoods.ToString());//触发任务事件  
                LogMgr.LogMoneyAdd(LogMoneyType.Shop, LogMoneyType.Shop_Buy, client.Player.PlayerCharacter.ID, money, client.Player.PlayerCharacter.Money, gold, gifttoken, offer, medal, "牌子编号", itemIDs, types.ToString());
            }
            else
            {
                if (gold > client.Player.PlayerCharacter.Gold)
                {
                    msg = "UserBuyItemHandler.NoGold";
                }
                if (money > client.Player.PlayerCharacter.Money)
                {
                    msg = "UserBuyItemHandler.NoMoney";
                }
                //if (offer > client.Player.PlayerCharacter.Offer)
                //{
                //    msg = "UserBuyItemHandler.NoOffer";
                //}
                if (gifttoken > client.Player.PlayerCharacter.GiftToken)
                {
                    msg = "UserBuyItemHandler.GiftToken";
                }
                //if (medal > client.Player.PlayerCharacter.medal)
                //{
                //    msg = "UserBuyItemHandler.Medal";
                //}
                eMsg = eMessageType.ERROR;
            }
           
            client.Out.SendMessage(eMsg, LanguageMgr.GetTranslation(msg));
            return 0;
        }
    }
}
