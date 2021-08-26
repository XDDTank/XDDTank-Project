using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Game.Server.GameObjects;
using Game.Base.Packets;
using SqlDataProvider.Data;
using Bussiness;
using Bussiness.Managers;
using Game.Server.Managers;
using Game.Logic;

namespace Game.Server.Packets.Client
{
    [PacketHandler((byte)ePackageType.PET, "PET")]
    public class PetHandler : IPacketHandler
    {
        //0友好，1黑名单
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            var pet_cmd = packet.ReadByte();

            int place = -1;

            switch (pet_cmd)
            {
                case (byte)ePetType.MOVE_PETBAG:
                    {
                        Console.WriteLine("PET : MOVE_PETBAG ");
                        place = packet.ReadInt();
                    }
                    break;
                case (byte)ePetType.SKILL_UP:
                    int param1 = packet.ReadInt();//_loc_4.writeInt(param1);
                    int param2 = packet.ReadInt();//_loc_4.writeInt(param2);
                    int param3 = packet.ReadInt();//_loc_4.writeInt(param3);
                    Console.WriteLine("PET : SKILL_UP");
                    break;
                case (byte)ePetType.TRANSFORM:
                    int var_1 = packet.ReadInt();//_loc_3.writeInt(param1);
                    int var_2 = packet.ReadInt();//_loc_3.writeInt(param2);
                    Console.WriteLine("PET : TRANSFORM");
                    break;
                case (byte)ePetType.ADVANCE_PET:
                    int var_3 = packet.ReadInt();
                    Console.WriteLine("PET : ADVANCE_PET");
                    break;
                case (byte)ePetType.MAGIC_PET:
                    int var_4 = packet.ReadInt();
                    Console.WriteLine("PET : MAGIC_PET");
                    break;
                case (byte)ePetType.UPDATE_PET_SPACE:
                    Console.Write("PET : UPDATE_PET_SPACE");
                    break;
                case (byte)ePetType.CHANGE_PETNAME:
                    int pet_id = packet.ReadInt();
                    string new_name = packet.ReadString();
                    Console.WriteLine("PET : CHANGE_PET_NAME");
                    break;
            }
            //client.Player.PetBag.SaveToDatabase();
            return 0;
        }
    }
}
