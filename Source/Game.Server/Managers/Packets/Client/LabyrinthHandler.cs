using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Game.Base.Packets;

using Game.Server.GameObjects;

namespace Game.Server.Packets.Client
{
    [PacketHandler((byte)ePackageType.LABYRINTH, "场景用户离开")]
    public class LabyrinthHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            var labyrinth_cmd = packet.ReadInt();            
            switch (labyrinth_cmd)
            {
                case (int)LabyrinthPackageType.CLEAN_OUT:
                    {
                        bool isCleanOut = packet.ReadBoolean();
                        int currentFloor = packet.ReadByte();
                        int moneyType = packet.ReadInt();//    _loc_2.writeInt(_moneyType);-2:DDTMoney/ -1:Money
                        int needMoney = packet.ReadInt();
                        if (isCleanOut)
                        {
                            if (client.Player.PlayerCharacter.Money >= needMoney && moneyType == -1)
                            {
                                client.Player.RemoveMoney(needMoney);
                                isCleanOut = false;
                            }
                            else if (client.Player.PlayerCharacter.GiftToken >= needMoney && moneyType == -2)
                            {
                                client.Player.RemoveGiftToken(needMoney);
                                isCleanOut = false;
                            }
                        }
                        Console.WriteLine("//CLEAN_OUT ");
                        break;
                    }
                case (int)LabyrinthPackageType.CLEAN_OUT_COMPLETE:
                    {
                        Console.WriteLine("//CLEAN_OUT_COMPLETE ");
                        break;
                    }
                case (int)LabyrinthPackageType.DOUBLE_REWARD:
                    {
                        Console.WriteLine("//DOUBLE_REWARD ");
                        break;
                    }
                case (int)LabyrinthPackageType.PUSH_CLEAN_OUT_INFO:
                    {

                        Console.WriteLine("//PUSH_CLEAN_OUT_INFO ");
                        break;
                    }
                case (int)LabyrinthPackageType.REQUEST_UPDATE:
                    {
                        Console.WriteLine("//REQUEST_UPDATE ");
                        GSPacketIn response = new GSPacketIn((byte)ePackageType.LABYRINTH, client.Player.PlayerCharacter.ID);
                        response.WriteByte((byte)LabyrinthPackageType.REQUEST_UPDATE);
                        response.WriteInt(0);//_model.myProgress = _loc_2.readInt();
                        response.WriteInt(0);//_model.currentFloor = _loc_2.readInt();
                        response.WriteBoolean(false);//_model.completeChallenge = _loc_2.readBoolean();
                        response.WriteInt(0);//_model.remainTime = _loc_2.readInt(); //clean_out
                        response.WriteInt(0);//_model.accumulateExp = _loc_2.readInt();
                        response.WriteInt(0);//_model.cleanOutAllTime = _loc_2.readInt();
                        response.WriteInt(0);//_model.cleanOutGold = _loc_2.readInt();
                        response.WriteInt(0);//_model.myRanking = _loc_2.readInt();
                        response.WriteBoolean(true);//_model.isDoubleAward = _loc_2.readBoolean();
                        response.WriteBoolean(false);//_model.isInGame = _loc_2.readBoolean();// dang vuot ai mà thoát ra ingame = true
                        response.WriteBoolean(false);//_model.isCleanOut = _loc_2.readBoolean();
                        response.WriteBoolean(true);//_model.serverMultiplyingPower = _loc_2.readBoolean();
                        client.Player.Out.SendTCP(response);
                        break;
                    }
                case (int)LabyrinthPackageType.RESET_LABYRINTH:
                    {
                        int currentFloor = packet.ReadByte();
                        currentFloor = 1;
                        Console.WriteLine("//RESET_LABYRINTH ");
                        break;
                    }
                case (int)LabyrinthPackageType.SPEEDED_UP_CLEAN_OUT:
                    {
                        Console.WriteLine("//SPEEDED_UP_CLEAN_OUT ");
                        break;
                    }
                case (int)LabyrinthPackageType.STOP_CLEAN_OUT:
                    {
                        bool isCleanOut = packet.ReadBoolean();
                        isCleanOut = false;
                        Console.WriteLine("//STOP_CLEAN_OUT ");
                        break;
                    }
                case (int)LabyrinthPackageType.TRY_AGAIN:
                    {

                        Console.WriteLine("//TRY_AGAIN ");
                        break;
                    }
            }
            return 0;
        }
    }
}
