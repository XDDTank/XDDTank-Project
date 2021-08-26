using System;
using System.Collections.Generic;
//using System.Linq;
//using System.Text;
using Game.Base.Packets;
using Game.Server.GameObjects;
//using Game.Server.Managers;
using Bussiness;
using SqlDataProvider.Data;
//using Game.Server.Rooms;
using Game.Logic;
//using Game.Server.Statics;

namespace Game.Server.Packets.Client
{
    [PacketHandler((int)ePackageType.FARM, "游戏创建")]
    public class EnterFarmHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            byte farm_cmd = packet.ReadByte();
            switch (farm_cmd)
            {
                case (int)FarmPackageType.ACCELERATE_FIELD:
                    {
                        Console.WriteLine("FAM : ACCELERATE_FIELD ");
                        break;
                    }
                case (int)FarmPackageType.SEEDING:
                    {
                        Console.WriteLine("FARM : SEEDDING ");
                        break;
                    }
                case (int)FarmPackageType.REFRASH_FARM:
                    {
                        Console.WriteLine("FARM : REFRASH_FARM");
                        break;
                    }

                case (int)FarmPackageType.Exit_FARM:
                    {
                        Console.WriteLine("FARM : EXIT_FARM");
                        break;
                    }
                case (int)FarmPackageType.UPROOT_FIELD:
                    {
                        Console.WriteLine("FARM : UPROOT_FIELD");
                        break;
                    }

                case (int)FarmPackageType.GAIN_FIELD:
                    {
                        Console.WriteLine("FARM : GAIN_FIELD");
                        break;
                    }
            }
            return 0;
        }
    }
}
