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
    [PacketHandler((byte)ePackageType.LATENT_ENERGY, "场景用户离开")]
    public class LatentEnergyHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            int type = packet.ReadByte();
            int BagType = packet.ReadInt();
            int Place = packet.ReadInt();
            int ItemBagType = -1;
            int ItemPlace = -1;
            ItemInfo equipCell = client.Player.GetItemAt((eBageType)BagType, Place);
            ItemInfo itemCell =null;
            PlayerInventory inventory = client.Player.GetInventory((eBageType)BagType);
            string msg = "Kích hoạt tiềm năng thành công!";
            //GSPacketIn pkg = packet.Clone();
            //pkg.ClearContext();
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.LATENT_ENERGY, client.Player.PlayerCharacter.ID);
            ThreadSafeRandom random = new ThreadSafeRandom();
            //Console.WriteLine("?????????type: " + type);
            if (type == 1)
            {
                ItemBagType = packet.ReadInt();
                ItemPlace = packet.ReadInt();
                itemCell = client.Player.GetItemAt((eBageType)ItemBagType, ItemPlace);
                PlayerInventory storeBag = client.Player.GetInventory((eBageType)ItemBagType);
                storeBag.RemoveCountFromStack(itemCell, 1);
                ItemTemplateInfo Temp = ItemMgr.FindItemTemplate(itemCell.TemplateID);
                int curStr = Temp.Property3;//random.Next(Temp.Property2, Temp.Property3);
                string tepmCurStr = curStr.ToString();
                for (int i = 1; i < 4; i++)
                {
                    tepmCurStr += "," + curStr.ToString();
                }
                if (equipCell.latentEnergyCurStr.Split(',')[0] == "0")
                {
                    equipCell.latentEnergyCurStr = tepmCurStr;// "1,1,1,1";
                }
                equipCell.latentEnergyNewStr = tepmCurStr;
                equipCell.latentEnergyEndTime = DateTime.Now.AddDays(Temp.Property4);
            }
            else
            {
                client.Player.MainBag.UpdatePlayerProperties();
                equipCell.latentEnergyCurStr = equipCell.latentEnergyNewStr;
                msg = "Cập nhật tiềm năng thành công!";
            }
            equipCell.IsBinds = true;
            inventory.UpdateItem(equipCell);
            inventory.SaveToDatabase();//保存到数据库
            pkg.WriteInt(equipCell.Place);//_loc_3.place = _loc_2.readInt();
            pkg.WriteString(equipCell.latentEnergyCurStr);//_loc_3.curStr = _loc_2.readUTF();
            pkg.WriteString(equipCell.latentEnergyNewStr);//_loc_3.newStr = _loc_2.readUTF();
            pkg.WriteDateTime(equipCell.latentEnergyEndTime);//_loc_3.endTime = _loc_2.readDate();
            client.Out.SendTCP(pkg);
            client.Player.SendMessage(msg);
            return 0;
        }
    }
}
