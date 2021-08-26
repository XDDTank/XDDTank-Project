using System;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Managers;

namespace Game.Server.Packets.Client
{
    [PacketHandler((byte)ePackageType.TOTEM, "场景用户离开")]
    public class HonorUpHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            int type = packet.ReadByte();
            bool isBland = packet.ReadBoolean();
            //Console.WriteLine("?????type: " + type + " isBland:" + isBland);
            if (client.Player.Toemview && client.Player.PlayerCharacter.totemId > 0)
            {
                client.Player.Out.SendPlayerRefreshTotem(client.Player.PlayerCharacter);
                client.Player.Toemview = false;
            }
            switch (type)
            {
                case 1://
                    {
                    }
                    break;
                case 2://get honor by monney
                    {
                        int maxBuyHonor = client.Player.PlayerCharacter.MaxBuyHonor + 1;
                        int needMoney = TotemHonorMgr.FindTotemHonorTemplateInfo(maxBuyHonor).NeedMoney;
                        int addHonnor = TotemHonorMgr.FindTotemHonorTemplateInfo(maxBuyHonor).AddHonor;
                        if (client.Player.PlayerCharacter.Money >= needMoney)
                        {

                            client.Player.AddHonor(addHonnor);
                            client.Player.AddMaxHonor(1);
                            client.Player.RemoveMoney(needMoney);
                            //Console.WriteLine("????needMoney: " + needMoney);
                        }
                    }
                    break;
            }
            //client.Player.Out.SendUpdateUpCount(client.Player.PlayerCharacter);
            return 0;
        }
    }
}
