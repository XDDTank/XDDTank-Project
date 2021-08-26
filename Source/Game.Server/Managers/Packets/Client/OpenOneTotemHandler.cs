using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Text;
using Game.Base.Packets;
//using Game.Server.Managers;
using Game.Server.GameObjects;
using Bussiness;
using Game.Server.Managers;

namespace Game.Server.Packets.Client
{
    [PacketHandler((byte)ePackageType.TOTEM, "场景用户离开")]
    public class OpenOneTotemHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            if ((client.Player.PlayerCharacter.HasBagPassword && client.Player.PlayerCharacter.IsLocked))
            {
                client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("Bag.Locked"));                
                return 1;
            }
            int id = client.Player.PlayerCharacter.totemId;
            int needMoney = TotemMgr.FindTotemInfo(id).ConsumeExp;
            int needHonor = TotemMgr.FindTotemInfo(id).ConsumeHonor;
            if (client.Player.PlayerCharacter.Money >= needMoney && client.Player.PlayerCharacter.myHonor >= needHonor)
            {
                if (id == 0)
                {
                    client.Player.AddTotem(10001);
                }
                else
                {
                    client.Player.AddTotem(1);
                }
                client.Player.RemoveMoney(needMoney);
                client.Player.RemovemyHonor(needHonor);
                client.Player.Out.SendPlayerRefreshTotem(client.Player.PlayerCharacter);
                client.Player.MainBag.UpdatePlayerProperties();
            }
            
            return 0;
        }
    }
}
