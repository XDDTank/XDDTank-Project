using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Game.Server.GameObjects;
using Game.Base.Packets;
using SqlDataProvider.Data;
using Bussiness.Managers;
using Game.Server.GameUtils;

namespace Game.Server.Packets.Client
{
    [PacketHandler((int)ePackageType.TREASURE_IN, "Đào kho báu")]
    public class TreasureInHandler : IPacketHandler
    {
        int[] ItemArray = new int[16];
        public void AddItemToArray()
        {
            int i, itemid = 7024;
            for (i = 0; i < 16; i++)
            {
                ItemArray[i] = itemid;
                itemid++;
            }
        }
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.TREASURE_IN, client.Player.PlayerCharacter.ID);
            int cmd = packet.ReadInt();//đọc số client trả về;
            switch (cmd)
            {
                case (int)TreasurePackageType.IN_TREASURE://click vào icon kho báu
                    AddItemToArray();
                    pkg.WriteInt((byte)TreasurePackageType.IN_TREASURE);
                    pkg.WriteInt(1);//TreasureModel.instance.logoinDays = event.pkg.readInt();
                    pkg.WriteInt(3);//PlayerManager.Instance.Self.treasure = event.pkg.readInt();
                    pkg.WriteInt(2);//var _loc_2:* = event.pkg.readInt();
                    pkg.WriteInt(2);//TreasureModel.instance.friendHelpTimes = event.pkg.readInt();
                    pkg.WriteBoolean(true);//TreasureModel.instance.isEndTreasure = event.pkg.readBoolean();
                    pkg.WriteBoolean(false);//TreasureModel.instance.isBeginTreasure = event.pkg.readBoolean();
                    pkg.WriteInt(16);//_loc_3 = event.pkg.readInt();
                    int _loc_4 = 0;
                    while (_loc_4 < 16)
                    {
                        pkg.WriteInt(ItemArray[_loc_4]);//_loc_6.TemplateID = event.pkg.readInt();
                        pkg.WriteInt(1);//_loc_7.ValidDate = event.pkg.readInt();
                        pkg.WriteInt(1);//_loc_7.Count = event.pkg.readInt();
                        _loc_4++;
                    }
                    pkg.WriteInt(16);
                    int _loc_5 = 0;
                    while (_loc_5 < 16)
                    {
                        pkg.WriteInt(ItemArray[_loc_5]);//_loc_8.TemplateID = event.pkg.readInt();
                        pkg.WriteInt(_loc_5);//_loc_9.pos = event.pkg.readInt();
                        pkg.WriteInt(1);//_loc_9.ValidDate = event.pkg.readInt();
                        pkg.WriteInt(1);//_loc_9.Count = event.pkg.readInt();
                        _loc_5++;
                    }
                    client.Out.SendTCP(pkg);
                    Console.WriteLine("TREASURE_IN : IN_TREASURE");
                    break;
                case (int)TreasurePackageType.ARRANGE_FRIEND_FARM:
                    Console.WriteLine("TREASURE_IN : ARRANGE_FRIEND_FARM");
                    break;
                case (int)TreasurePackageType.START_GAME://bắt đầu
                    pkg.WriteInt((int)TreasurePackageType.START_GAME);
                    pkg.WriteBoolean(true);
                    client.Out.SendTCP(pkg);
                    Console.WriteLine("TREASURE_IN : START_GAME");
                    break;
                case (int)TreasurePackageType.END_TREASURE://kết thúc
                    
                    Console.WriteLine("TREASURE_IN : END_TREASURE");
                    break;
                case (int)TreasurePackageType.DIG://đào
                    int position = packet.ReadInt();
                    Console.WriteLine("TREASURE_IN : DIG "+position);
                    break;
                default:
                    Console.WriteLine("TREASURE_IN : DEFAULT_CASE");
                    break;
            }
            return 0;
        }
    }
}
