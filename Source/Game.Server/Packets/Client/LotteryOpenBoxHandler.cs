using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Game.Server.GameObjects;
using Game.Base.Packets;
using Bussiness.Managers;
using SqlDataProvider.Data;
using Game.Server.GameUtils;
using Bussiness;
using Game.Server.Statics;

namespace Game.Server.Packets.Client
{
    [PacketHandler((byte)ePackageType.LOTTERY_OPEN_BOX, "打开物品")]
    public class LotteryOpenBoxHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            var business = new ProduceBussiness();

            if (client.Lottery != -1)
            {
                client.Out.SendMessage(eMessageType.Normal, "Rương đang hoạt động!");
                return 1;
            }

            int bag = packet.ReadByte();
            int slot = packet.ReadInt();
            int templateId = packet.ReadInt();

            PlayerInventory inventory = client.Player.GetInventory((eBageType)bag);
            ItemInfo itemAt = inventory.GetItemAt(slot);
            if (inventory.FindFirstEmptySlot() == -1)
            {
                client.Out.SendMessage(eMessageType.Normal, "Rương đã đầy không thể mở thêm!");
                return 1;
            }
            PlayerInventory propBag = client.Player.PropBag;
            ItemInfo itemHammer = propBag.GetItemByTemplateID(0, 11456);

            List<ItemInfo> infos = new List<ItemInfo>();
            bool result = false;
            GSPacketIn pkg;
            List<ItemBoxInfo> items;
            int[] bags = new int[3];
            StringBuilder msg = new StringBuilder();


            items = ItemBoxMgr.FindItemBoxAward(templateId);
            int index = ThreadSafeRandom.NextStatic(items.Count);// new Random().Next(0, items.Count - 1);
            ItemTemplateInfo infoBox = ItemMgr.FindItemTemplate(templateId);
            ItemInfo infoAward = ItemInfo.CreateFromTemplate(ItemMgr.FindItemTemplate(items[index].TemplateId), 1, 105);
            result = true;
            string name = "";
            switch (templateId)
            {
                case 112047:
                case 112100:
                case 112101:
                    {
                        name = client.Player.PlayerCharacter.NickName;
                        infoAward.BeginDate = DateTime.Now;
                        infoAward.ValidDate = 7;
                        infoAward.RemoveDate = DateTime.Now.AddDays(7);
                        if (itemHammer.Count > 4)
                        {
                            itemHammer.Count -= 4;
                            propBag.UpdateItem(itemHammer);
                        }
                        else
                        {
                            propBag.RemoveItem(itemHammer);
                        }
                    }
                    break;
                default:
                    {
                        name = infoAward.Template.Name;
                    }
                    break;
            }
            pkg = new GSPacketIn((byte)ePackageType.CADDY_GET_AWARDS, client.Player.PlayerId);
            pkg.WriteBoolean(result);
            pkg.WriteInt(1);
            pkg.WriteString(name);//_loc_5.name = _loc_2.readUTF();
            pkg.WriteInt(infoAward.TemplateID);//_loc_5.TemplateId = _loc_2.readInt();  
            pkg.WriteInt(4);//_loc_5.zoneID = _loc_2.readInt();
            pkg.WriteBoolean(false);//_loc_5.isLong = _loc_2.readBoolean();
            //if (_loc_5.isLong)
            //{
            //    _loc_5.zone = _loc_2.readUTF();
            //}      
            client.Out.SendTCP(pkg);

            inventory.AddItem(infoAward);

            msg.Append(infoAward.Template.Name);

            ItemInfo box = client.Player.PropBag.GetItemByTemplateID(0, templateId);
            if (box.Count > 1)
            {
                box.Count--;
                client.Player.PropBag.UpdateItem(box);
            }
            else
            {
                client.Player.PropBag.RemoveItem(box);
            }
            client.Lottery = -1;
            if (msg != null) //trminhpc
            {
                client.Out.SendMessage(eMessageType.Normal, "Bạn nhận được " + msg.ToString());
            }
            return 1;
        }
        
        public void OpenUpItem()
        {
           
        }
    }
}
